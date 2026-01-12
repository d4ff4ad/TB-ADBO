<?php

namespace App\Http\Controllers;

use App\Models\Review;
use App\Models\Transaction;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function store(Request $request) {
        $user = $request->user();

        $validated = $request->validate([
            'transaction_id' => 'required|exists:transactions,id',
            'product_id' => 'required|exists:products,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        // Verify transaction belongs to user
        $transaction = Transaction::where('id', $validated['transaction_id'])
                        ->where('user_id', $user->id)
                        ->where('product_id', $validated['product_id'])
                        ->first();

        if (!$transaction) {
            return response()->json(['message' => 'Transaction not found or invalid.'], 404);
        }

        // Optional: Check status (e.g. only finished transactions can be reviewed)
        if (!in_array($transaction->status, ['active', 'finished'])) {
             return response()->json(['message' => 'Cannot review a pending or cancelled transaction.'], 400);
        }

        // Check if already reviewed
        $existingReview = Review::where('transaction_id', $transaction->id)->first();
        if ($existingReview) {
            return response()->json(['message' => 'You have already reviewed this transaction.'], 400);
        }

        $review = Review::create([
            'user_id' => $user->id,
            'product_id' => $validated['product_id'],
            'transaction_id' => $validated['transaction_id'],
            'rating' => $validated['rating'],
            'comment' => $validated['comment'],
        ]);

        return response()->json([
            'message' => 'Review submitted successfully',
            'data' => $review
        ], 201);
    }
}
