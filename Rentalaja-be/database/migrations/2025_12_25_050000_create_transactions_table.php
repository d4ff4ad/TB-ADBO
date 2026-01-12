<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('product_id')->constrained('products')->onDelete('cascade');
            
            $table->date('start_date');
            $table->date('end_date');
            $table->time('pickup_time'); // Baru: Jam Ambil
            $table->time('return_time'); // Baru: Jam Balik
            
            $table->decimal('total_price', 15, 2);
            
            // Info Pembayaran
            $table->string('payment_method'); // 'qris' or 'bank_transfer'
            $table->string('payment_proof')->nullable(); // Foto bukti
            
            $table->enum('status', ['pending', 'active', 'finished', 'cancelled'])->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
