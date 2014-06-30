<?php

function presentResults($headings, $results, $textmappings)
{
    
//     echo "<span class=\"badge\">" . $size . "</span>";
    ?>
    <h1>Results</h1>
	<?php 
	   foreach($headings as $heading) {
       $classname = str_replace("module", "", $heading["class"]);
	?>
<div class="panel-group" id="accordion">
	<div class="panel panel-default">
		<div class="panel-heading">
		<h4 class="panel-title">
		  <a data-toggle="collapse" data-parent="#accordion" href="<?php echo "#".$heading["id"]; ?>">
		      <span class="glyphicon glyphicon-chevron-down"></span> <span class="badge"> <?php echo count($results[$heading["id"]])?></span> <?php echo $heading["text"]; ?> - type:<?php echo $classname;?>
		  </a>
		</h4></div>
		<div id="<?php echo $heading["id"]; ?>" class="panel-collapse collapse">
			<div class="panel-body"> 
			<ul>
			<?php foreach($results[$heading["id"]] as $value) { 
			 $text = (isset($textmappings[$heading["id"]])) ? $textmappings[$heading["id"]][$value] : $value;
			    ?>
    			<li><?php echo $text; ?></li>
			<?php }	?>
			</ul>
			</div>
		</div>
	</div>
</div>
	<?php }?>
<?php
}

?>