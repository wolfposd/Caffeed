<?php



class checkbox extends AbstractModule
{
    
    public function html()
    {
        ?>
        <div class="text-center">
	        <p/>
		    <p><?php echo $this->values["text"]?> <input type="checkbox" name="<?php echo $this->id?>"><p>
	    </div>
        <?php 
    }
    
    public function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Checkbox Module","checkboxmodule");
    }
}


?>