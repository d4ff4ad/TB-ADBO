<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{id}', [ProductController::class, 'show']);

// Public Auth Routes
Route::post('/register', [\App\Http\Controllers\AuthController::class, 'register']);
Route::post('/login', [\App\Http\Controllers\AuthController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/logout', [\App\Http\Controllers\AuthController::class, 'logout']);
    Route::post('/update-profile', [\App\Http\Controllers\AuthController::class, 'updateProfile']);
    
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    
    Route::post('/transactions', [\App\Http\Controllers\TransactionController::class, 'store']);
    Route::get('/transactions', [\App\Http\Controllers\TransactionController::class, 'index']);
    
    // Admin Transaction Routes
    Route::get('/admin/transactions', [\App\Http\Controllers\TransactionController::class, 'adminIndex']);
    Route::post('/transactions/{id}/status', [\App\Http\Controllers\TransactionController::class, 'updateStatus']);

    Route::post('/products', [ProductController::class, 'store']);
    Route::post('/products/{id}', [ProductController::class, 'update']); // Use POST for FormData Update
    Route::delete('/products/{id}', [ProductController::class, 'destroy']);

    // Reviews
    Route::post('/reviews', [\App\Http\Controllers\ReviewController::class, 'store']);

    // Chats
    Route::get('/chats', [\App\Http\Controllers\ChatController::class, 'index']);
    Route::post('/chats', [\App\Http\Controllers\ChatController::class, 'store']);
    Route::get('/chats/{id}/messages', [\App\Http\Controllers\ChatController::class, 'showMessages']);
    Route::post('/chats/{id}/messages', [\App\Http\Controllers\ChatController::class, 'storeMessage']);
    Route::post('/chats/{id}/read', [\App\Http\Controllers\ChatController::class, 'markAsRead']);
});
