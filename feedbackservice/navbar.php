<?php


class NavigationBarTop
{
	function __construct($elements)
	{
		?>
<div class="navbar navbar-inverse navbar-fixed-top navbar-blue" role="navigation">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="?view=home">CAF-Feed</a>
		</div>
		<div class="navbar-collapse collapse">

			<ul class="nav navbar-nav">
				<?php  foreach ($elements[0] as $key => $value) {?>
				<li><a href="<?php echo $value?>"><?php echo $key?> </a></li>
				<?php }?>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<?php  foreach ($elements[1] as $key => $value) {?>
				<li><a href="<?php echo $value?>"><?php echo $key?> </a></li>
				<?php }?>
			</ul>
		</div>
	</div>
</div>
<?php 
	}
}



class NavigationBarLeft
{
	function __construct($elements)
	{
		?>
<div class="col-sm-3 col-md-2 sidebar">
	<?php 
	foreach($elements as $key => $subkey)
	{
		?>
	<ul class="nav nav-sidebar">
		<?php foreach($subkey as $value) {	?>
		<li <?php if (isset($value["active"])) echo "class=\"active\""?>><a href="<?php echo $value["link"]?>"><?php echo $value["name"]?> </a></li>
		<?php 
		}
		?>
	</ul>
	<hr style="color:#A0A0A0; background-color:#A0A0A0;height: 1px;">
	<?php 
	}
	?>
</div>
<?php 
	}
}


?>