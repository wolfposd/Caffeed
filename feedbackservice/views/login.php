<?php

class login
{
    private $database;

    private $mode = 0;

    function __construct(database &$database)
    {
        $this->database = $database;
    }
    function __destruct()
    {
    }

    function setup()
    {
        if(isset($_POST["user"]) && isset($_POST["pwd"]))
        {
            $this->mode = 1;
        }
        else
        {
            // display login form
        }
    }

    function display()
    {
        switch($this->mode)
        {
            case 1:
                {
                    // verify login informations
                }
                break;
                 
            default:
                show_login();
        }
         
    }

    /**
     * Remove function if not necessary
     * @return string
     */
    function modifiedBodyValues()
    {
        return ""; // <body> tag not modified
    }

    /**
     * Remove function if not necessary
     * @return string
     */
    function additionalJavascript()
    {
        return ""; // additional javascript
    }

}


function show_login()
{
    ?>
<div class="col-md-4" style="float: none; margin: 0 auto;">
	<form class="form-signin" method="post">
		<h2 class="form-signin-heading">Please sign in</h2>
		<input type="email" class="form-control" placeholder="Email address" name="user" required="required" autofocus="autofocus"> <input
			type="password" class="form-control" placeholder="Password" name="pwd" required="required">
		<!-- <label class="checkbox"><input type="checkbox" value="remember-me">Remember me </label> -->
		<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
	</form>
	<p />
	<p>
		<a href="?view=register">Register a new Account</a>
	</p>
</div>
<?php 
}


?>