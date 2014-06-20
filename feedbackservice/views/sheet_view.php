<?php

include_once 'rest.php';



function showPages($sheettitle , $pagearray)
{
?>
<div class="row text-center">
<h1><?php echo $sheettitle;?></h1>
    <ul class="pager" id="pageTabs">
    <?php foreach($pagearray as $page) {
        $pagetitle = $page["title"];
        $pageid = $page["id"];
        ?>
        <li><a href="<?php echo "#".$pageid;?>" data-toggle="tab"><?php echo $pagetitle;?></a></li>
    <?php }?>
    </ul>
    <div id="pageTabsContent" class="tab-content">
    <?php foreach($pagearray as $page) { 
        $pagetitle = $page["title"];
        $pageid = str_replace(" ", "", $pagetitle);
        ?>
        <div class="tab-pane fade" id="<?php echo $pageid?>">
        <?php foreach($page["elements"] as $module) 
            { 
                ?>
                <div style="border: 1px solid #A0A0A0; margin-bottom: 20px; " class="text-center">
                    <?php $module->html();?>
                </div>
                <?php 
            }
        ?>
        
        </div>
    <?php } ?>
    </div>
</div>
<?php
}






?>