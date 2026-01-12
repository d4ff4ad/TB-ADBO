<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Carbon\Carbon;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        return response()->json([
            'message' => 'List of Transactions',
            'data' => Transaction::where('user_id', $request->user()->id)->with('product')->get()
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
            'pickup_time' => 'required', // Format HH:mm
            'return_time' => 'required',
            'payment_method' => 'required|in:qris,bank_transfer',
            'payment_proof' => 'required|image|max:5000', // Wajib upload gambar
        ]);
        
        $product = Product::findOrFail($validated['product_id']);
        
        // Hitung Harga
        $start = Carbon::parse($validated['start_date']);
        $end = Carbon::parse($validated['end_date']);
        $days = $start->diffInDays($end) + 1;
        $totalPrice = $product->price_per_day * $days;
        
        // Simpan Gambar Bukti
        $proofPath = null;
        if ($request->hasFile('payment_proof')) {
            // Simpan ke storage/app/public/payments
            $proofPath = $request->file('payment_proof')->store('payments', 'public');
        }
        
        $transaction = Transaction::create([
            'user_id' => $request->user()->id,
            'product_id' => $product->id,
            'start_date' => $validated['start_date'],
            'end_date' => $validated['end_date'],
            'pickup_time' => $validated['pickup_time'],
            'return_time' => $validated['return_time'],
            'payment_method' => $validated['payment_method'],
            'payment_proof' => $proofPath,
            'total_price' => $totalPrice,
            'status' => 'pending'
        ]);
        
        // Update Stok Produk
        if ($product->stock > 0) {
            $product->decrement('stock');
            
            // Jika stok habis, ubah status jadi rented
            if ($product->stock == 0) {
               $product->update(['status' => 'rented']);
            }
        }
        
        return response()->json(['message' => 'Booking Success', 'data' => $transaction]);
    }

    public function adminIndex(Request $request) {
        // Ensure user is admin
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $transactions = Transaction::with(['product', 'user'])->latest()->get(); 
        
        return response()->json([
            'message' => 'All Transactions',
            'data' => $transactions
        ]);
    }

    public function updateStatus(Request $request, $id) {
        // Ensure user is admin
        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $transaction = Transaction::findOrFail($id);
        
        // Validasi input status
        $request->validate([
            'status' => 'required|string|in:pending,active,finished,cancelled,rejected' // Added rejected
        ]);

        $oldStatus = $transaction->status;

        $transaction->update([
            'status' => $request->status
        ]);

        // Logic Pengembalian Stok
        if (in_array($request->status, ['rejected', 'cancelled', 'finished']) && !in_array($oldStatus, ['rejected', 'cancelled', 'finished'])) {
            $product = Product::find($transaction->product_id);
            if ($product) {
                $product->increment('stock');
                
                // Jika status sebelumnya rented, kembalikan jadi available
                if ($product->status === 'rented' && $product->stock > 0) {
                    $product->update(['status' => 'available']);
                }
            }
        }

        return response()->json([
            'message' => 'Status updated',
            'data' => $transaction->load('product'), // Return data terbaru
        ]);
    }
}
