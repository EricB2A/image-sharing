<?php

use Illuminate\Foundation\Testing\WithoutMiddleware;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\DatabaseTransactions;

class LoginTest extends TestCase
{
    use DatabaseMigrations;
    /*
     * Goes to the login page from the root page
     *
     * @return void
     */
    public function testGotoLogin(){
        $this->visit("/")
            ->click("Login")
            ->seePageIs("/login");
    }

    /*
     * Tries to login with a wrong username/passord
     *
     * @return void
     */
    public function testWrongLogin(){
        $this->visit("/login")
            ->type("wrong.email@whitehouse.gov", "email")
            ->type("obama1234", "password")
            ->press("Login")
            ->seePageIs("/login");
    }

    /*
     * In case of wrong-login, is there a message error
     *
     * @return void
     */
    public function testErrorMessageWrongLogin(){
        $this->visit("/login")
            ->type("osama.obama@whitehouse.gov", "email")
            ->type("ilovepenauts", "password")
            ->press("Login")
            ->see("These credentials do not match our records.");
    }


}
