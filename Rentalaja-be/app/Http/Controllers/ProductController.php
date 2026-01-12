<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller {
    public function index() {
        return response()->json([
            'message' => 'Success',
            'data' => Product::all()
        ]);
    }

    public function show($id) {
        $product = Product::find($id);

        if (!$product) {
            return response()->json(['message' => 'Product not found'], 404);
        }

        return response()->json([
            'message' => 'Detail Data Product',
            'data' => $product
        ]);
    }

    public function store(Request $request) {
        // Pastikan user login
        $user = auth()->user();
        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
        
        // Cek Role
        if ($user->role !== 'admin') { 
                return response()->json(['message' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price_per_day' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'image' => 'required|image|max:5000', // Max 5MB
            'status' => 'nullable|in:available,rented,maintenance',
        ]);

        $imagePath = null;
        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('products', 'public');
        }

        $product = Product::create([
            'name' => $validated['name'],
            'description' => $validated['description'],
            'price_per_day' => $validated['price_per_day'],
            'stock' => $validated['stock'],
            'image_url' => $imagePath,
            'status' => $validated['status'] ?? 'available',
        ]);

        return response()->json([
            'message' => 'Product created successfully',
            'data' => $product
        ], 201);
    }

    public function update(Request $request, $id) {
        // Ensure user is admin
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $product = Product::find($id);
        if (!$product) {
            return response()->json(['message' => 'Product not found'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price_per_day' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'image' => 'nullable|image|max:5000', // Optional on update
            'status' => 'nullable|in:available,rented,maintenance',
        ]);

        $updateData = [
            'name' => $validated['name'],
            'description' => $validated['description'],
            'price_per_day' => $validated['price_per_day'],
            'stock' => $validated['stock'],
            'status' => $validated['status'] ?? $product->status,
        ];

        // Handle Image Upload
        if ($request->hasFile('image')) {
            // Delete old image
            if ($product->image_url && \Illuminate\Support\Facades\Storage::disk('public')->exists($product->image_url)) {
                \Illuminate\Support\Facades\Storage::disk('public')->delete($product->image_url);
            }
            // Store new
            $imagePath = $request->file('image')->store('products', 'public');
            $updateData['image_url'] = $imagePath;
        }

        $product->update($updateData);

        return response()->json([
            'message' => 'Product updated successfully',
            'data' => $product
        ]);
    }

    public function destroy(Request $request, $id) {
        // Ensure user is admin
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $product = Product::find($id);
        if (!$product) {
            return response()->json(['message' => 'Product not found'], 404);
        }

        // Delete image
        if ($product->image_url && \Illuminate\Support\Facades\Storage::disk('public')->exists($product->image_url)) {
            \Illuminate\Support\Facades\Storage::disk('public')->delete($product->image_url);
        }

        $product->delete();

        return response()->json(['message' => 'Product deleted successfully']);
    }
}
