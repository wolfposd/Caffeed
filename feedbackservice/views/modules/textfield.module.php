<?php


class textfield extends AbstractModule
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
	        <input type="text" style="width: 75%;" <?php echo $maxlength?> id="<?php echo $this->id?>" name="<?php echo $this->id?>">
	        <p><span id='<?php echo "addon-".$this->id;?>'><?php echo $length !== false ? "Remaining characters: ".$length : "";?></span></p>
	        <p/>
	    </div>
        <?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        $text = '<p>Length: <input type="text" name="module_XXXX_length" value="160">  (empty = infinite)<p>';
        echo basiceditor("Textfield Module","textfieldmodule",$text);
    }
    
    
    function analyzehtml($results, $mappings =array())
    {
        $values = $this->countSameElements($results);
        ob_start();
        ?>
        <ul>
        <?php foreach ($values as $value => $valuecount) { ?>
            <li><?php echo $value; ?> <span class="badge"><?php echo $valuecount?></span></li>
        <?php } ?>
        </ul>
        <?php 
        return ob_get_clean();
    }
    
}


?>