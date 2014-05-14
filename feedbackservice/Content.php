<?php


class Content
{
	private $database;
	private $subcontent = false;

	function __construct()
	{
		include_once 'config.php';
		$this->database = getConnection();


		global $_SESSION;
		$loggedin = isset($_SESSION["login"]) ? $_SESSION["login"] : false;

		if($loggedin === true)
		{
			include_once 'views/LoggedIn.php';
			$this->subcontent = new LoggedInContent($this->database);
		}
		else if(isset($_GET["view"]))
		{
			$destination = $_GET["view"];

			if(!@include_once "views/".$destination.".php")
			{
				$this->fallBackSubcontent();
				return;
			}
			
			$classname = explode("/", $destination);
			$classname = $classname[count($classname)-1];

			$subcontent = call_user_func_array(array(new ReflectionClass($classname), 'newInstance'), array(&$this->database));

			if($subcontent !== false)
			{
				$this->subcontent = $subcontent;
			}
			else
			{
				$this->fallBackSubcontent();
			}
		}
		else
		{
			$this->fallBackSubcontent();
		}
	}
	function __destruct()
	{
		$this->database->close();
	}


	function fallBackSubcontent()
	{
		include_once 'views/home.php';
		$this->subcontent = new Home($this->database);
	}
	
	function handleCookies()
	{
	    if(method_exists($this->subcontent, "handleCookies"))
	    {
	        return $this->subcontent->handleCookies();
	    }
	}
	function setup()
	{
	    if(method_exists($this->subcontent, "setup"))
	    {
	        return $this->subcontent->setup();
	    }
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


	function getNavigationBarLeftContent()
	{
		if($this->subcontent !== false && method_exists($this->subcontent, "getNavigationBarLeftContent"))
		{
			return $this->subcontent->getNavigationBarLeftContent();
		}
		else
		{
			return false;
		}
	}

	function getNavigationBarTopContent()
	{
		global $_SESSION;

		$leftarr = array("Home"=>"?view=home");
		if(method_exists($this->subcontent, "getNavigationBarTopContent"))
		{
			foreach($this->subcontent->getNavigationBarTopContent() as $key => $value)
			{
				$leftarr[$key] = $value;
			}
		}
		
		$leftarr["REST-API"] ="?view=rest";

		if(isset($_SESSION["login"]) && $_SESSION["login"])
		{
			return array($leftarr, array("Logout"=>"?logout"));
		}
		else
		{
			return array($leftarr,array("Login"=>"?view=login"));
		}

	}


	function additionalJavascript()
	{
		if(method_exists($this->subcontent, "additionalJavascript"))
		{
			return $this->subcontent->additionalJavascript();
		}
		else
		{
			return false;
		}
	}
}

?>