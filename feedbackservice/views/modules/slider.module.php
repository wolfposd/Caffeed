<?php


include_once 'views/modules/interface.module.php';
class slider implements IModule
{
    private $values;
    private $id;
    
    function __construct(array $values, $id)
    {    
        $this->values = $values;
        $this->id = $id;
        
    }
    
    function javascript()
    {
        return '$("#'.$this->id.'").slider({formater:function(e){return"Current value: "+e}});';
    }
    
    function html()
    {
        $this->values["middle"] = ($this->values["max"]-$this->values["min"])/2;
    ?>
    <div class="text-center">
        <p>
	    <p><?php echo $this->values["text"]?> <input type="text" class="span2" value="1" name="<?php echo $this->id?>" id="<?php echo $this->id?>" data-slider-min="<?php echo $this->values["min"]?>" data-slider-max="<?php echo $this->values["max"]?>" data-slider-step="<?php echo $this->values["step"]?>" data-slider-value="<?php echo $this->values["middle"]?>" ></p>
    </div>
    <?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Slider Module","slidermodule",'<table class="table table-condensed">
<tr>
<td>Minimum Value:</td>
<td><input type="text" name="module_XXXX_min" value="1"></td>
</tr>
<tr>
<td>Maximum Value:</td>
<td><input type="text" name="module_XXXX_max" value="5"></td>
</tr>
<tr>
<td>Steps:</td>
<td><input type="text" name="module_XXXX_step" value="1"></td>
</tr>
</table>');
    }
    
}