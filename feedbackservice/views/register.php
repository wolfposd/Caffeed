<?php

/**
 * This is the basic Template for controller-classes
 */
class Register
{
	private $database;
	
	private $mode = "normal";

	private $isRegisterSuccess = false;
	private $insertErrorMessage ="";
	
	function __construct(database $database)
	{
		$this->database = $database;
	}
	function __destruct()
	{
	}

	
	function setup()
	{
	    if($this->isUserTryingToCreateAccount())
	    {
	        $this->mode = "register";
	        
	        // TODO additional checks for fields user,pwd,firstname,lastname
	         
	        $this->isRegisterSuccess = $this->database->registerNewUser($_POST["user"], $_POST["pwd"],$_POST["firstname"], $_POST["lastname"]);
	         
	        if(! $this->isRegisterSuccess)
	        {
	            $this->insertErrorMessage = $this->database->lastError();
	            
	            if($this->stringContains($this->insertErrorMessage, "Duplicate"))
	            {
	                if($this->stringContains($this->insertErrorMessage, "for key 'email'"))
	                {
	                    $this->insertErrorMessage = "eMail address ".$_POST["user"]." is already taken";
	                }
	            }
	            else
	            {
	                $this->insertErrorMessage = "Unknown error";
	            }
	        }
	        else
	        {
	            //TODO SEND ACTIVATION EMAIL
	        }
	    }
	}
	
	function stringContains($string, $contains)
	{
	    $val = strpos($string, $contains);
	    var_dump($val);
        return $val !== false;	    
	}
	
	function display()
	{
	    switch($this->mode)
	    {
	        case "register":
	            {
	                if($this->isRegisterSuccess)
	                {
	                    echo "Successfully created >>". $_POST["user"] . "<< account";
	                }
	                else
	                {
	                    echo "No success creating<br>error: ".$this->insertErrorMessage;
	                }
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
		});' . javascript_check_email(); // additional javascript
	}
	
	
	function isUserTryingToCreateAccount()
	{
	    return isset($_POST["pwd"]) && isset($_POST["pwd_again"]) && isset($_POST["user"]) && isset($_POST["firstname"]) && isset($_POST["lastname"]);
	}

}


function javascript_check_email()
{
    return '
function checkLecture(lecture) 
{
	$.get("rest.php/internal_emailfree/" + lecture, function (data) 
	{
		if(data !== "true")
		{
			$("#userfree").html("<span style=\'color:red;font-size:200%\'  class=\'glyphicon glyphicon-remove\'></span>").removeAttr("style");
            $("#formgroupuser").addClass("has-error");
		}
        else
        {
			$("#userfree").html("").css("visibility", "hidden");
            $("#formgroupuser").removeClass("has-error");
        }
	});
}

$("#user").keyup(function () 
{
    var val = $("#user").val();
	if(val.indexOf("@") > -1)
    {
    	checkLecture(val);
    }
    else
    {
    	$("#userfree").html("").css("visibility", "hidden");
    }
});
            ';
}

function show_register_form()
{
    ?>
<div class="col-md-4 col-lg-4" style="float: none; margin: 0 auto;">
	<form class="form-horizontal" method="post">
		<h2 class="form-signin-heading text-center">Please fill out the registration form</h2>
        <div class="form-group has-feedback" id="formgroupuser">
    		<input type="email" class="form-control" placeholder="Email address" name="user" id="user" required autofocus>
    		<span id="userfree" class="form-control-feedback" style="visibility:hidden"></span>
        </div>
		<p></p>
        <div class="form-group has-feedback">
    		<input type="text" class="form-control" placeholder="First name" name="firstname" id="firstname" required>
        </div>
		<p></p>
        <div class="form-group has-feedback">
    		<input type="text" class="form-control" placeholder="Last name" name="lastname" id="lastname" required >
        </div>
		<p></p>
        <div class="form-group has-feedback">
    		<input type="password" class="form-control" placeholder="Password" name="pwd" id="pwd" required>
        </div>
		<p></p>
        <div class="form-group has-feedback">
    		<input type="password" class="form-control"	placeholder="Repeat Password" name="pwd_again" id="pwd_again" required>
        </div>
		<p></p>
		<button class="btn btn-lg btn-primary btn-block" type="submit" id="register">Register</button>
		<div class="text-center">
		    <span id="errorfield"  style="color:#FF0000;font-size:200%"></span>
		</div>
	</form>
</div>
<?php 
}


?>