<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'name', 'description', 'price_per_day', 'stock', 'image_url', 'status'
    ];

    protected function imageUrl(): \Illuminate\Database\Eloquent\Casts\Attribute
    {
        return \Illuminate\Database\Eloquent\Casts\Attribute::make(
            get: fn ($value) => $value ? url('storage/' . $value) : null,
        );
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    protected $appends = ['average_rating'];

    public function getAverageRatingAttribute()
    {
        return round($this->reviews()->avg('rating'), 1) ?? 0;
    }
}
