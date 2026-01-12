<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ElectronicItem extends Model
{
    protected $fillable = [
        'name',
        'description',
        'price_per_day',
        'stock',
        'image_url',
        'status',
    ];

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'item_id');
    }
}
