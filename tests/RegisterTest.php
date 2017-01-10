<?php

use Illuminate\Foundation\Testing\WithoutMiddleware;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\DatabaseTransactions;

class RegisterTest extends TestCase
{
    use DatabaseMigrations;
    /*
     * Goes to the registration page from the root page
     *
     * @return void
     */
    public function testGoToResiter(){
        $this->visit("/")
            ->click("Register")
            ->seePageIs("/register");
    }

    public function testRegisterEmptyForm(){
        $this->visit("/register")
             ->press("Register")
             ->seePageIs("/register");
    }

    public function testRegisterWithoutEmail(){
        $this->visit("/register")
             ->type("Mo", "name")
             ->type("1234", "password")
             ->type("1234", "password_confirmation")
             ->press("Register")
             ->seePageIs("/register");
    }

    public function testRegisterDifferentPasswords(){
        $this->visit("/register")
             ->type("Momo", "name")
             ->type("justin.timberlake@whitehouse.gov", "email")
             ->type("123456789", "password")
             ->type("secret1234", "password_confirmation")
             ->press("Register")
             ->see("The password confirmation does not match.");
    }

}
