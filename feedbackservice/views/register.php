<?php

/**
 * This is the basic Template for controller-classes
 */
class Register
{
	private $mysqli;
	
	private $mode = 0;

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;
	}
	function __destruct()
	{
	}

	
	function setup()
	{
	    if(isset($_POST["pwd"]))
	    {
	        $this->mode = 1;
	    }
	    else
	    {
	        
	    }
	}
	
	function display()
	{
	    switch($this->mode)
	    {
	        case 1:
	            {
	                echo "user has pressed button";
	                break;
	            }
	        default:
	            show_register_form();
	    }
	}


	/**
	 * Remove function if not necessary
	 * @return string
	 */
	function additionalJavascript()
	{
		return '$(function(){
			$("#register").click(function(){
				$(".error").hide();
				var passwordVal = $("#pwd").val();
				var checkVal = $("#pwd_again").val();
				if (passwordVal == "") {
					$("#errorfield").html("Please enter a password!");
		            $("#pwd").focus();
					return false;
				} else if (checkVal == "") {
					$("#errorfield").html("Please retype your password!");
		            $("#pwd_again").focus();
					return false;
				} else if (passwordVal != checkVal ) {
					$("#errorfield").html("The passwords do not match");
		            $("#pwd_again").focus();
					return false;
				}
				return true;
			});
		});'; // additional javascript
	}

}

function show_register_form()
{
    ?>
<div class="col-md-4 col-lg-4" style="float: none; margin: 0 auto;">
	<div id="message"></div>
	<form class="form-signin" method="post">
		<h2 class="form-signin-heading text-center">Please fill out the registration form</h2>
		<input type="email" class="form-control" placeholder="Email address" name="user" id="user" required autofocus>
		<p></p>
		<input type="text" class="form-control" placeholder="First name" name="firstname" id="firstname" required>
		<p></p>
		<input type="text" class="form-control" placeholder="Last name" name="lastname" id="lastname" required >
		<p></p>
		<input type="password" class="form-control" placeholder="Password" name="pwd" id="pwd" required>
		<p></p>
		<input type="password" class="form-control"	placeholder="Repeat Password" name="pwd_again" id="pwd_again" required>
		<p></p>
		<button class="btn btn-lg btn-primary btn-block" type="submit" id="register">Register</button>
		<div class="text-center"><span id="errorfield"  style="color:#FF0000;font-size:200%"></span></div>
	</form>
</div>
<?php 
}


?>