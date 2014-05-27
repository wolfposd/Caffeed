<?php

session_start();


include_once 'Content.php';
include_once 'navbar.php';
$content = new Content();

$content->handleCookies();

$content->setup();


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
		<div class="<?php echo $maindiv?>" id="maindiv">
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

?>