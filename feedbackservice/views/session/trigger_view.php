<?php



function displayListOfContextGroups($groups)
{
    ?>
    <div class="row">
    <h1>Context Groups</h1>
    <?php foreach ($groups as $group) { ?>
    <div class="row">
        <div class="col-sm-6 well">
            <h4>Contextgroup: <?php echo $group["groupname"]?></h4>
            <?php foreach($group["extra"] as $extra) { ?>
                <p>Preview: <a href="?view=sheet&sheet=<?php echo $extra["sheetinfo"]["restid"]?>" target="_blank"><?php echo $extra["sheetinfo"]["title"] ;?></a></p>
            <?php } ?>
            
            <a href="?view=session/overview&sub=trigger&edit=<?php echo $group["contextid"]?>"><button class="btn btn-sm btn-warning">Edit</button></a>
        </div>
    </div>
    <?php } ?>
    </div>
    <?php 
}


function displayAddContextGroup(array $beacons)
{
    ?>
    <hr>
    <div class="row">
    <div class="col-sm-6 row well">
       <h2>Add new Context Group</h2>
        <form method="post" id="beaconform">
            <?php 
            makeThreePanelInputGroup("Group Name", "cname", true);
            ?>
            <div class="row" style="padding-bottom:20px;">
                <div class="input-group">
                  <input type="text" class="form-control" id="cbeacon" name="cbeacon" placeholder="Main Beacon">
                  <div class="input-group-btn dropup">
                    <button type="button" class="btn btn-default dropdown-toggle" tabindex="-1" data-toggle="dropdown">MyBeacons <span class="caret"></span></button>
                    <ul class="dropdown-menu dropup dropdown-menu-right" role="menu">
                    <?php 
                    foreach ($beacons as $beacon)
                    {
                        $output = $beacon->uuid."-".$beacon->major."-".$beacon->minor;
                        ?>
                        <li><a href="" data-uuid="<?php echo $output; ?>" onclick="$('#cbeacon').val($(this).data('uuid'));return false;"><?php echo $output?></a></li>
                        <?php 
                    }
                    ?>
                    </ul>
                  </div><!-- /btn-group -->
                </div><!-- /input-group -->
            </div>
            
            <button type="submit" class="btn btn btn-success">Add Context Group</button>
        </form>
    </div>
    </div>
    <?php 
}

function makeThreePanelInputGroupWithContent($placeholder, $inputname, $required, $input ="")
{
?>
<div class="row" style="padding-bottom:20px;">
    <div class="input-group">
        <input type="text" class="form-control" placeholder="<?php echo $placeholder?>" name="<?php echo $inputname;?>" id="form<?php echo $inputname;?>"
        <?php
         if ($required) echo " required=\"required\"";
         if ($inputname!="") echo " id=\"$inputname\"";
         if($input!="") echo " value=\"$input\"";
         ?>>
        <span class="input-group-addon" id=""><?php echo $placeholder ?></span>
    </div>
</div>
<?php 
}

function makeThreePanelInputGroupWithContentAndButtonToTarget($placeholder, $inputname, $required, $input, $targetName, $targetJS)
{
    ?>
<div class="row" style="padding-bottom:20px;">
    <div class="input-group">
        <input type="text" class="form-control" placeholder="<?php echo $placeholder?>" name="<?php echo $inputname;?>" id="form<?php echo $inputname;?>"
        <?php
         if ($required) echo " required=\"required\"";
         if ($inputname!="") echo " id=\"$inputname\"";
         if($input!="") echo " value=\"$input\"";
         ?>>
        <span class="input-group-addon" id=""><?php echo $placeholder ?></span>
        <a href="#" class="btn input-group-addon" onclick="<?php echo $targetJS;?>"><?php echo $targetName?> <span class="glyphicon glyphicon-list"></span></a>
    </div>
</div>
<?php 
}

function makeThreePanelInputGroup($placeholder, $inputname, $required,  $idforinput="")
{
?>
<div class="row" style="padding-bottom:20px;">
    <div class="input">
        <input type="text" class="form-control" placeholder="<?php echo $placeholder?>" name="<?php echo $inputname;?>" id="form<?php echo $inputname;?>"
        <?php
         if ($required) echo " required=\"required\"";
         if ($idforinput!="") echo " id=\"$idforinput\"";
         ?>>
    </div>
</div>
<?php 
}



// ==========================================================================================
//                                 EDIT MODE
// ==========================================================================================


function display_edit_mode_for_group($groupname, $triggers)
{
   ?>
   <h2><?php echo $groupname; ?></h2>
   <div class="container-fluid">
   <h3>Current Triggers:</h3>
   <?php foreach ($triggers as $index => $trigger ) { 
       $editString  ="";
   ?>
   <div class="row well col-sm-8" id="formdiv<?php echo $index?>">
           <p>Sheet: <?php echo $trigger["extra"]["sheetinfo"]["title"]?></p>
           <p>Priority: <?php echo $trigger["priority"]?></p>
           <div class="col-sm-7">
               <form method="post" id="triggereditform<?php echo $index ?>">
               <p>Trigger: <?php echo $trigger["type"]?></p>
                   <div class="row">
                       <div class="col-sm-7">
                       <input type="hidden" name="cgid" value="<?php echo $trigger["id"];?>">
                       <?php 
                       foreach ($trigger["extra"] as $name => $value)
                       {
                           if($name == "beacon")
                           {
                               makeThreePanelInputGroupWithContentAndButtonToTarget($name, "cg".$name, true, "".$value, "", "showdiv('hiddenbeaconlist');return false;");
                           }
                           else if($name == "sheetid")
                           {
                               makeThreePanelInputGroupWithContentAndButtonToTarget($name, "cg".$name, true, "".$value, "", "showdiv('hiddensheetlist');return false;");
                           }
                           else if($name != "sheetinfo")
                           {
                               makeThreePanelInputGroupWithContent($name, "cg".$name, true, "".$value);
                           }
                       }
                       ?>
                       </div>
                   </div>
               </form>
               <button class="btn btn-sm btn-success" data-sheet="<?php echo $index ?>" onclick="updateTrigger(this);return false;">Update</button>
               <button class="btn btn-sm btn-danger" data-sheet="<?php echo $index ?>" onclick="deleteTrigger(this);return false;">Delete</button>
           </div>
           <div class="col-sm-5" id="messagediv<?php echo $index?>"></div>
   </div><!-- row well -->
   <?php }?>
   </div> <!-- container -->
   
   
   <div class="container-fluid">
       <h2>Add new Trigger</h2>
       
       <div class="row">
           <div class="col-sm-6 well">
               <form method="post" id="triggereditform">
                   <div class="row" style="padding-bottom:20px;">
                        <div class="input-group">
                          <input type="text" class="form-control" id="cttype" name="cttype" placeholder="Context-Trigger Type">
                          <div class="input-group-btn">
                            <button type="button" class="btn btn-default dropdown-toggle" tabindex="-1" data-toggle="dropdown">ContextTriggers <span class="caret"></span></button>
                            <ul class="dropdown-menu dropdown-menu-right" role="menu">
                            <?php 
                            $triggers = array( 
                                            array("json"=>'{"beacon":0,"detectamount":0,"mintimebetween":0,"sheetid":0}', "name"=>"BeaconTrigger"), 
                                           // array("json"=>"test", "name"=>"AndTrigger") 
                                        );
                            foreach ($triggers as $trigger)
                            {
                                ?>
                                <li><a href="" data-json="<?php echo urlencode($trigger["json"]); ?>" onclick="$('#formctjson').val(decodeURIComponent($(this).data('json'))); $('#cttype').val('<?php echo $trigger["name"]?>');return false;"><?php echo $trigger["name"]?></a></li>
                                <?php 
                            }
                            ?>
                            </ul>
                          </div><!-- /btn-group -->
                        </div><!-- /input-group -->
                    </div>
               
                       <?php 
                       makeThreePanelInputGroup("Context-Trigger JSON", "ctjson", true);
                       makeThreePanelInputGroup("Priority", "ctprio", true);
                       ?>
                   <button type="submit" class="btn btn-success">Add new group</button>
               </form>
           </div>
       </div>
   </div>
   
   
   <?php 
}



function hiddenBeaconList(array $beacons)
{
    ?>
    <div id="hiddenbeaconlist" style="display: none;" title="Your Beacons">
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>UUID</th>
                <th>Major</th>
                <th>Minor</th>
            </tr>
        </thead>
        <tbody>
        <?php foreach($beacons as $beacon) { ?>
            <tr>
                <td><?php echo $beacon->id?></td>
                <td><?php echo $beacon->uuid ?></td>
                <td><?php echo $beacon->major?></td>
                <td><?php echo $beacon->minor?></td>
            </tr>
        <?php } ?>
        </tbody>
    </table>
    </div>
    <?php 
}

function hiddenSheetList(array $sheets)
{
    ?>
    <div id="hiddensheetlist" style="display: none;" title="Your Sheets">
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
            </tr>
        </thead>
        <tbody>
        <?php foreach($sheets as $sheet) { ?>
            <tr>
                <td><?php echo $sheet["id"]?></td>
                <td><?php echo $sheet["title"] ?></td>
            </tr>
        <?php } ?>
        </tbody>
    </table>
    </div>
    <?php 
}









?>