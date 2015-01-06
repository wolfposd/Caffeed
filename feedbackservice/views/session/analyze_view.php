<?php



function showOverview($sheet, $contexts = false)
{
    ?>
    <p>Please select a sheet for inspection:</p>
    <ul>
    <?php foreach($sheet as $sheetinfo) { ?>
        <li>
            <p><a href="?view=session/overview&sub=analyze&sheet=<?php echo $sheetinfo[0];?>"><?php echo $sheetinfo[0];?></a><br>
            Title: <b><?php echo $sheetinfo[1];?></b> <br>Date: <?php echo $sheetinfo[2];?></p>
        </li>
    <?php }?>
    </ul>
    <br>
    <br>
    <br>
    <p>Or select a context group for inspection<p>
    <?php 
    
    if($contexts)
    {
           ?> <ul>
           <?php foreach($contexts as $context) { 
           ?>
                <li>
                    <p><a href="?view=session/overview&sub=analyze&ct=<?php echo $context["contextid"];?>"><?php echo $context["groupname"];?></a><br>
                </li>
            
            <?php } ?>
            </ul>
            <?php 
    }
}

function presentResults($headings, $analyzes, $resultsText = "Results")
{
    ?>
    <h3><?php echo $resultsText ?></h3>
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
<?php }
}

?>