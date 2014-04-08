<?php


class Content
{
	private $mysqli;
	private $subcontent = false;

	function __construct()
	{
		include_once 'config.php';
		$this->mysqli = getConnection();


		global $_SESSION;
		$loggedin = $_SESSION["login"];

		if($loggedin === true)
		{
			include_once 'views/LoggedIn.php';
			$this->subcontent = new LoggedInContent($this->mysqli);
		}
		else if(isset($_GET["login"]))
		{
			include_once 'views/normal/login.php';
			$this->subcontent = new Login($this->mysqli);
		}
		else
		{
			include_once 'views/Infoscreen.php';
			$this->subcontent = new InfoScreen($this->mysqli);
		}
	}
	function __destruct()
	{
		$this->mysqli->close();
	}

	function display()
	{

		if($this->subcontent !== false)
		{
			$this->subcontent->display();
		}
		else
		{
			?>
<h1 class="page-header">Hier Default Template</h1>
Hier kann auch Text stehen
<?php
		}
	}

	function modifiedBodyValues()
	{
		if(method_exists($this->subcontent, "modifiedBodyValues"))
		{
			return $this->subcontent->modifiedBodyValues();
		}
		else return "";
	}


	function showNavigationBarLeft()
	{
		if($this->subcontent !== false)
		{
			return $this->subcontent->showNavigationBarLeft();
		}
		else
		{
			return false;
		}
	}

	function getNavigationBarLeftContent()
	{
		return $this->subcontent->getNavigationBarLeftContent();
	}
	function getNavigationBarTopContent()
	{
		global $_SESSION;

		if($_SESSION["login"])
		{
			return array(array("Home"=>"?"),array("Logout"=>"?logout"));
		}
		else
		{
			return array(array("Home"=>"?"),array("Login"=>"?login"));
		}

	}
}

?>