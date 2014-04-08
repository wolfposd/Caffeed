<?php


class Login
{
	private $mysqli;
	private $loginSuccess = false;

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;

		if(!$this->isShowLoginForm())
		{
			$this->loginSuccess = $this->checkLogin();
		}
	}
	function __destruct()
	{
	}

	function showNavigationBarLeft()
	{
		return false;
	}

	function modifiedBodyValues()
	{
		if(!$this->isShowLoginForm() && $this->loginSuccess)
		{
			include_once 'functions.php';
			return redirectPageJavaScriptTextForBody(3000,"?overview");
		}
		else
		{
			return "";
		}
	}

	function display()
	{
		if($this->isShowLoginForm())
		{
			show_login_form();
		}
		else
		{
			include_once 'functions.php';
			show_succes_or_error($this->loginSuccess, "Success", "Successfully logged in", "Error", "Username or Password wrong");
			
			if(!$this->loginSuccess)
			{
				show_login_form();
			}
		}
	}


	function checkLogin()
	{
		include_once 'functions.php';
		global $_POST;
		$email = $this->mysqli->real_escape_string($_POST["user"]);
		$pwd =  hash_SHA265($_POST["pwd"]);
		
		$query = "SELECT * FROM beacon_owner WHERE email = '$email' AND pwd = '$pwd'";
		$result = $this->mysqli->query($query);

		if($result !== false && $result->num_rows == 1)
		{
			$row = $result->fetch_assoc();
				
			if($row["email"] === $email)
			{
				$_SESSION["email"] = $email;
				$_SESSION["ownerid"] = $row["id"];
				$_SESSION["login"] = true;
				return true;
			}
		}
		return false;
	}

	function isShowLoginForm()
	{
		return !(isset($_POST["user"]) && isset($_POST["pwd"]));
	}

}




function show_login_form()
{
	?>
<div class="col-md-4" style="float: none; margin: 0 auto;">
	<form class="form-signin" role="form" method="post">
		<h2 class="form-signin-heading">Please sign in</h2>
		<input type="email" class="form-control" placeholder="Email address" name="user" required autofocus> 
		<input type="password" class="form-control" placeholder="Password" name="pwd" required>
		<label class="checkbox"><input type="checkbox" value="remember-me">Remember me	</label>
		<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
	</form>
</div>
<?php 
}

?>