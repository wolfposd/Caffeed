<?php
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


$maindiv = $content->showNavigationBarLeft() ? "col-md-offset-2 main" : "main"; 


new NavigationBarTop($content->getNavigationBarTopContent());

?>
<div class="container-fluid">
	<div class="row">
		<?php 
		if($content->showNavigationBarLeft() !== false)
		{
			new NavigationBarLeft($content->getNavigationBarLeftContent());
		}

		?>
		<div class="<?php echo $maindiv?>">
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