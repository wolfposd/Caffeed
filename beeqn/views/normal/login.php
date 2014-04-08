<?php


class Login 
{
	private $mysqli;
	function __construct(&$mysqli)
	{	
		$this->mysqli = $mysqli;
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
		if(!$this->isShowLoginForm())
		{
			include_once 'functions.php';
			return reloadPageJavascriptTextForBody(3000);
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
			
		}
	}
	
	
	function checkLogin()
	{
		
		
		
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
	    <label class="checkbox">
	    	<input type="checkbox" value="remember-me"> Remember me
	    </label>
	    <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
	</form>
</div>
	<?php 
}

?>