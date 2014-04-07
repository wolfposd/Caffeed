<?php
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

new NavigationBarTop(array("Home"=>"?"),array("Login"=>"?login"));

?>
<div class="container-fluid">
	<div class="row">
		<?php 
		if($content->showNavigationBarLeft() !== false)
		{
			new NavigationBarLeft($content->getNavigationBarLeftContent());
		}

		?>
		<div class="col-md-offset-2 main">
			<?php $content->display();?>
		</div>
	</div>
</div>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/stuff.js"></script>
</body>
</html>
<?php 






?>