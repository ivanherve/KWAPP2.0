<?php
/**
 * Created by PhpStorm.
 * User: Ivan HERVE
 * Date: 31-07-18
 * Time: 13:17
 */

namespace App;

use Illuminate\Database\Eloquent\Model;


class Token extends Model
{
    protected $table = 'Token';

    protected $primaryKey = 'tokenId';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'userId', 'api_token',
    ];

    public function user()
    {
        return $this->belongTo(User::class,'userId');
    }
}