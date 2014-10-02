<?php



function showOverview($sheet)
{
    ?>
    Please select a sheet for inspection:<p></p>
    <ul>
    <?php foreach($sheet as $sheetinfo) { ?>
        <li>
            <p><a href="?view=session/overview&sub=analyze&sheet=<?php echo $sheetinfo[0];?>"><?php echo $sheetinfo[0];?></a><br>
            Title: <b><?php echo $sheetinfo[1];?></b> <br>Date: <?php echo $sheetinfo[2];?></p>
        </li>
    <?php }?>
    </ul>
    <?php 
}

function presentResults($headings, $analyzes)
{
    ?>
    <h1>Results</h1>
	<?php 
	   foreach($headings as $index => $heading) {
       $classname = str_replace("module", "", $heading["class"]);
	?>
<div class="panel-group" id="accordion<?php echo $index;?>">
	<div class="panel panel-default">
		<div class="panel-heading" data-toggle="collapse" data-parent="#accordion<?php echo $index;?>" href="<?php echo "#".$heading["id"]; ?>">
		<h4 class="panel-title">
		  <a data-toggle="collapse" data-parent="#accordion<?php echo $index;?>" href="<?php echo "#".$heading["id"]; ?>">
		      <span class="glyphicon glyphicon-chevron-down"></span> <?php echo $heading["text"]; ?> - type:<?php echo $classname;?> <span class="badge">Results: <?php echo $analyzes[$heading["id"]][0];?></span>
		  </a>
		</h4></div>
		<div id="<?php echo $heading["id"]; ?>" class="panel-collapse collapse">
			<div class="panel-body"> 
			<?php echo $analyzes[$index][1]; ?>
			</div>
		</div>
	</div>
</div>
	<?php }?>
<?php
}

?>