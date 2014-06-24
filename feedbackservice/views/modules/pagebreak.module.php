<?php



class pagebreak extends AbstractModule
{
    
    function editorhtml()
    {
        $hline ="";
        for($i=0; $i <= 20;$i++)
        {
            $hline.="&#8211;";
        }
        
        ?>
            <div class="row" id="div_module_XXXX">
                <h4>
                    <font color="red"><?php echo $hline?> Pagebreak <?php echo $hline?></font>
                    <button type="button" class="btn btn-danger" onclick="$('#div_module_XXXX').remove(); return false;">X</button>
                </h4>
                <input type="hidden" name="module_XXXX_type" value="pagebreak">
            </div>
        <?php 
    }
}


?>