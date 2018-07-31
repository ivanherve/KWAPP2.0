<?php

namespace App\Http\Controllers;

class AuthController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Check the email and the password hashed to the database.
     * If these elements do not exist, the function shows an error message.
     * If they exist, the function will create a new token for the authenticated user if this one does not have a token yet.
     * If the user already has a token, the function will create another token to him/her or
     * it will update the database to insert a token id, the user id and a new token.
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        $password = hash('sha256', $request->input('password'));
        $user = User::all()->where("Email", "=", $request->input('email'))
            ->where("Password", "=", $password)->first();

        if (!$user) {
            return $this->jsonRes('error', 'Adresses e-mail ou mot de passe inéxistant', 401);
        }

        $userId = $user->userId;
        $hasNotToken = Token::all()->where('userId','=', $userId)->where('api_token','=',null)->first();
        $tokenId = Token::all()->where('userId','=', $userId)->where('api_token','=',null)->pluck('tokenId')->first();

        if ($hasNotToken){
            $token = str_random(60);
            $newToken = DB::select('UPDATE Token SET api_token = \''.$token.'\' WHERE tokenId = '.$tokenId.';');
            $newToken = Token::all()->where('userId','=', $userId)->where('api_token','=',$token)->first();
            return $this->jsonRes('success',['user' => $user, 'token' => $newToken],200);
        }
        else {
            $newToken = Token::create([
                'userId' => $userId,
                'api_token' => str_random(60)
            ]);
        }

        return $this->jsonRes('success',['user' => $user, 'token' => $newToken],200);
    }
}
