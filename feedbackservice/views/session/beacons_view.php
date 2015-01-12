<?php



/**
 * display the list of owned Beacons, Array of Beacon object
 * @param unknown $beaconArray
 */
function displayBeacons($beaconArray)
{
    ?>
    <div class="row">
    <h2>Beacons you own:</h2>
        <ul>
            <?php foreach($beaconArray as $beacon) {?>
            <li><?php echo $beacon->uuid."-".$beacon->major."-".$beacon->minor?></li>
            <?php }?>
        </ul>
    </div>
    <?php 
}


function displayAddBeaconForm()
{
    ?>
    <div class="row">
       <h2>Add new Beacon</h2>
        <form method="post" id="beaconform">
            <?php 
            makeThreePanelInputGroup("Beacon UUID", "uuid", true);
            makeThreePanelInputGroup("Beacon Major", "major", true);
            makeThreePanelInputGroup("Beacon Minor", "minor", true);
            ?>
            <button type="submit" class="btn btn btn-success">Add Beacon</button>
        </form>
    </div>
    <?php 
}

function makeThreePanelInputGroup($placeholder, $inputname, $required,  $idforinput="")
{
    ?>
<div class="row" style="padding-bottom:20px;">
    <div class="col-md-5 col-sm-5">
        <input type="text" class="form-control" placeholder="<?php echo $placeholder?>" name="<?php echo $inputname;?>" id="form<?php echo $inputname;?>"
        <?php
         if ($required) echo " required=\"required\"";
         if ($idforinput!="") echo " id=\"$idforinput\"";
         ?>>
    </div>
</div>
<?php 
}

?>