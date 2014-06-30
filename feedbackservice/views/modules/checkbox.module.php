<?php



class checkbox extends AbstractModule
{
    
    public function html()
    {
        ?>
        <div class="text-center">
	        <p/>
		    <p><?php echo $this->values["text"]?> 
		    <input type='hidden' value='0' name='<?php echo $this->id?>'>
		    <input type="checkbox" name="<?php echo $this->id?>">
		    <p>
	    </div>
        <?php 
    }
    
    public function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Checkbox Module","checkboxmodule");
    }
    
    
    public function getElements()
    {
        $on = "<span class='glyphicon glyphicon-ok'></span>";
        $off = "<span class='glyphicon glyphicon-remove'></span>";
        
        return array("on" => $on, "1" => $on, "off" => $off, "0" => $off);
    }
}


?>