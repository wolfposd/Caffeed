<?php


if(isset($_GET["id"]))
{
	$id = $_GET["id"];
	
	if($id == 3)
	{
		echo '{"title":"iPhone 5s Feedback","id":3,"submitbuttononpage":1,"pages":[{"title":"Page 1","elements":[{"type":"list","id":"list1","text":"Pick one of the following","elements":["good","medium","bad"]},{"type":"photo","id":"photo1","text":"Please take a picture of your face"},{"type":"textfield","id":"textfield1","text":"Add any additonal comments"}]}]}';
	}
}
else if(isset($_POST["id"]))
{
	
	$id = $_POST["id"];
	
	if($id == 3 && isset($_POST["json"]))
	{
		$json = json_decode($_POST["json"], true);
		
		if(isset($json["list1"]) && isset($json["photo1"]) && isset($json["textfield1"]))
		{
			echo "success";
		}
		else
		{
			echo "unsuccessfull";
		}
	}
	else
	{
		echo "unsuccessfull";
	}
}

else
{
	session_start();


$isCookiesSet = false;
if($isCookiesSet !== false)
{
	// setCookies
}

include_once 'Content.php';
include_once 'navbar.php';
$content = new Content();



include_once 'header.html';

echo "<body ". $content->modifiedBodyValues() .">";


$leftNavBarContent = $content->getNavigationBarLeftContent();

$maindiv = $leftNavBarContent !== false ? "col-md-offset-2 main" : "main";

new NavigationBarTop($content->getNavigationBarTopContent());

?>
<div class="container-fluid">
	<div class="row">
		<?php 
		if($leftNavBarContent !== false)
		{
			new NavigationBarLeft($leftNavBarContent);
		}

		?>
		<div class="<?php echo $maindiv?>">
			<?php $content->display();?>
		</div>
	</div>
</div>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-additions.js"></script>
<script src="js/custom.js"></script>
<?php $js = $content->additionalJavascript(); if($js !== false) echo "<script type=\"text/javascript\">".$js."</script>"?>
</body>
</html>
<?php 
}


?>