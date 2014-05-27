<?php

/**
 * This is the basic Template for controller-classes
 */
class validate
{
	private $database;
	
	private $successPendingRemoval = false;
	
	private $mode = "nomode";
	
	private $javascript = "";

	function __construct(database $database)
	{
		$this->database = $database;
	}
	function __destruct()
	{
	}
	
	/**
	 * Remove function if not necessary
	 */
	function handleCookies()
	{
	    
	}
	
	/**
	 * Remove function if not necessary
	 */
	function setup()
	{
	    if(isset($_GET["pending"]))
	    {
	        $hash = $_GET["pending"];
	        
	        $this->successPendingRemoval = $this->database->removePendingEmail($hash);
	        $this->mode = "activate";
	    }
	    else if(isset($_POST["resend"]))
	    {
	        $email = $_POST["resend"];
	        $this->mode = "mailto";
	    }
	    else if(isset($_GET["resend"]))
	    {
	        $this->mode = "resend";
	    }
	}

	function display()
	{
	    switch($this->mode)
	    {
	        case "activate":
	            {
	                if($this->successPendingRemoval === true)
	                {
	                    show_pending_status_removed();
	                }
	                else
	                {
	                    show_pending_no_change();
	                }
	                break;
	            }
	        case "resend":
	            {
	                show_pending_resend_form();
	                break;
	            }
	        case "mailto":
	            {
	                
	                break;
	            }
	        default:
	            {
	                $this->javascript = "window.location = 'index.php';";
	            }
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
		return $this->javascript;
	}

}




function show_pending_status_removed()
{
?>
<div class="well text-center col-md-offset-3 col-md-6  col-lg-offset-3 col-lg-6">
    <h1>Account verified</h1>
    <p>Your account has been successfully verified.</p>
    <p></p>
    <p> You can now login and create, manage and edit your question sheets</p>
    <p></p>
    <a href="?view=login">Click here to login</a>
</div>
<?php 
}


function show_pending_no_change()
{
    // TODO RESEND ACTIVATION EMAIL
?>
<div class="well text-center col-md-offset-3 col-md-6  col-lg-offset-3 col-lg-6">
    <h1>Oops!</h1>
    <p>Sorry I couldn't find your account.</p>
    <p></p>
    <p>If you would like to receive another activation eMail <a href="?view=validate&resend">click here</a></p>
    <p></p>
    <p>If your account has already been activated you won't need to do so again, you can <a href="?view=login">login here</a>.</p>
    <p></p>
    <a href="?view=login">Click here to login</a>
</div>
<?php 
}


function show_pending_resend_form()
{
?>
<div class="well text-center col-md-offset-3 col-md-6  col-lg-offset-3 col-lg-6">
    <form class="form-signin" method="post">
		<h2 class="form-signin-heading">Enter eMail address</h2>
		<div class="row">
    		<div class="col-md-offset-3 col-md-6 col-lg-offset-3 col-lg-6">
    		    <input type="email" class="form-control" placeholder="Email address" name="resend" required="required" autofocus="autofocus">
    		</div>
		</div>
		<div class="row">
    		<p></p>
    		<button class="btn btn-primary" type="submit">Resend activation link</button>
		</div>
	</form>
</div>
<?php 
}

?>