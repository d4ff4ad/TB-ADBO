<?php

namespace App\Http\Controllers;

use App\Models\Chat;
use App\Models\Message;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    // GET /api/chats
    public function index(Request $request)
    {
        $user = $request->user();

        // Calculate unread count (messages not from me, and is_read = false)
        $unreadQuery = function ($query) use ($user) {
            $query->where('is_read', false)
                  ->where('sender_id', '!=', $user->id);
        };

        if ($user->role === 'admin') {
            // Admin: Get all chats, ordered by latest activity
            $chats = Chat::with(['user', 'lastMessage'])
                        ->withCount(['messages as unread_count' => $unreadQuery])
                        ->orderByDesc('updated_at')
                        ->get();
        } else {
            // Member: Get own chat
            $chats = Chat::where('user_id', $user->id)
                        ->with(['user', 'lastMessage'])
                        ->withCount(['messages as unread_count' => $unreadQuery])
                        ->get();
        }

        return response()->json(['data' => $chats]);
    }

    // POST /api/chats (Start Chat - Member)
    public function store(Request $request)
    {
        $user = $request->user();

        // Check if chat already exists
        $chat = Chat::where('user_id', $user->id)->first();

        if (!$chat) {
            $chat = Chat::create(['user_id' => $user->id]);
        }
        
        // Load relationships including unread count
        $unreadQuery = function ($query) use ($user) {
            $query->where('is_read', false)
                  ->where('sender_id', '!=', $user->id);
        };

        return response()->json([
            'message' => 'Chat session active',
            'data' => $chat->load(['user', 'lastMessage'])->loadCount(['messages as unread_count' => $unreadQuery])
        ]);
    }

    // GET /api/chats/{id}/messages
    public function showMessages(Request $request, $id)
    {
        $chat = Chat::findOrFail($id);
        
        // Ensure user has access
        $user = $request->user();
        if ($user->role !== 'admin' && $chat->user_id !== $user->id) {
             return response()->json(['message' => 'Unauthorized'], 403);
        }

        $messages = Message::where('chat_id', $chat->id)
                        ->orderBy('created_at', 'asc') // Oldest first
                        ->get();

        return response()->json(['data' => $messages]);
    }

    // POST /api/chats/{id}/read (Mark as Read)
    public function markAsRead(Request $request, $id) {
        $chat = Chat::findOrFail($id);
        $user = $request->user();

        // Ensure user has access
        if ($user->role !== 'admin' && $chat->user_id !== $user->id) {
             return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Update messages not sent by me to is_read = true
        Message::where('chat_id', $chat->id)
            ->where('sender_id', '!=', $user->id)
            ->update(['is_read' => true]);

        return response()->json(['message' => 'Messages marked as read']);
    }

    // POST /api/chats/{id}/messages
    public function storeMessage(Request $request, $id)
    {
        $chat = Chat::findOrFail($id);
        $user = $request->user();

         // Ensure user has access
        if ($user->role !== 'admin' && $chat->user_id !== $user->id) {
             return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'content' => 'required|string'
        ]);

        $message = Message::create([
            'chat_id' => $chat->id,
            'sender_id' => $user->id,
            'content' => $request->content,
            'is_read' => false
        ]);

        // Update chat updated_at timestamp to move it to top
        $chat->touch();

        return response()->json([
            'message' => 'Message sent',
            'data' => $message
        ], 201);
    }
}
