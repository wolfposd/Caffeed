<?php




function basiceditor($title, $type, $others = "")
{
    ob_start();
    ?>
    <div class="row" id="div_module_XXXX">
        <h4><?php echo $title;?></h4>
            <div class="col-md-5 divbordersheeteditor">
            <input type="hidden" name="module_XXXX_type" value="<?php echo $type;?>">
            <p>Text: <input class="form-control" type="text" name="module_XXXX_text" placeholder="Display Text"></p>
            <?php echo $others;?>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-danger" onclick="$('#div_module_XXXX').remove(); return false;">X</button>
            </div>
        </div>
    <?php 
    return ob_get_clean();
}

?>