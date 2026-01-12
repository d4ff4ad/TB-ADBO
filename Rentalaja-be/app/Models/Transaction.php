<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $fillable = [
        'user_id', 'product_id', 
        'start_date', 'end_date', 'pickup_time', 'return_time', 
        'total_price', 'status', 'payment_method', 'payment_proof'
    ];

    protected function paymentProof(): \Illuminate\Database\Eloquent\Casts\Attribute
    {
        return \Illuminate\Database\Eloquent\Casts\Attribute::make(
            get: fn ($value) => $value ? url('storage/' . $value) : null,
        );
    }
    
    public function product() { 
        return $this->belongsTo(Product::class); 
    }

    public function user() {
        return $this->belongsTo(User::class);
    }
}
