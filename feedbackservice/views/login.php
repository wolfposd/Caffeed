<?php

class login
{
    private $database;

    private $mode = 0;
    
    private $modifiedBody ="";

    function __construct(database $database)
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
            $correct = $this->database->isLoginCorrect($_POST["user"], $_POST["pwd"]);

            if($correct === true)
            {
                $_SESSION["login"] = true;
                $_SESSION["user"] = $_POST["user"];
                include_once 'functions.php';
                $this->modifiedBody = redirectPageJavaScriptTextForBody(1500,"?view=session/overview");
                $this->mode = 1;
            }
            else
            {
                $this->mode = 2;
            }
        }
        else
        {
            // display login form
        }
    }

    function display()
    {
        
        include_once 'functions.php';
        switch($this->mode)
        {
            case 1:
                {
                    show_message_dialog_with_text("Success","Successfully logged in");
                    break;
                }
            case 2:
                {
                    show_message_dialog_with_text("Error","Wrong password or username",false);
                    show_login();
                    break;
                }
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
        return $this->modifiedBody;
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
		<input type="email" class="form-control" placeholder="Email address" name="user" required="required" autofocus="autofocus">
		<input type="password" class="form-control" placeholder="Password" name="pwd" required="required">
		<!-- <label class="checkbox"><input type="checkbox" value="remember-me">Remember me </label> -->
		<p></p>
		<button class="btn btn-primary btn-block" type="submit">Sign in</button>
	</form>
	<p />
	<p>
		<a href="?view=register">Don't have an account? Register a new Account</a>
	</p>
</div>
<?php 
}


?>