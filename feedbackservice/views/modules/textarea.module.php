<?php

include_once 'textfield.module.php';

class textarea extends textfield
{
    public function javascript()
    {
        $length = isset($this->values["length"]) ? $this->values["length"] : false;
        $id = $this->id;
        $addonid = "addon-".$this->id;
        
        if($length === false)
        {
            return "";
        }
        else
        {
            return '$("#'.$id.'").keyup(function(){if(this.value.length>'.$length.'){return false}$("#'.$addonid.'").html("Remaining characters: "+('.$length.'-this.value.length))});';
        }
    }

    public function html()
    {
        $length = isset($this->values["length"]) ? $this->values["length"] : false;
        
        $maxlength = $length !== false ? "maxlength=\"$length\"" : "";
        
        ?>
	    <div class="text-center">
	        <p><?php echo $this->values["text"]?></p>
	        <textarea rows="5" style="width: 75%;margin-bottom:5px;" <?php echo $maxlength?> name="<?php echo $this->id?>" id="<?php echo $this->id?>"></textarea>
	        <p><span id='<?php echo "addon-".$this->id;?>'><?php echo $length !== false ? "Remaining characters: ".$length : "";?></span></p>
	        <p></p>
	    </div>
        <?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        $text = '<p>Length: <input type="text" name="module_XXXX_length" value="160">  (empty = infinite)<p>';
        echo basiceditor("Textarea Module","textareamodule",$text);
    }
    
}


?>