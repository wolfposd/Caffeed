<?php


class star extends AbstractModule
{

    /**
     * Echos the HTML code
    */
    public function html()
    {
        ?>
        <div class="text-center">
	        <p/>
		    <p><?php echo $this->values["text"]?></p>
		    <div class="rating">
                <input type="radio" name="<?php echo $this->id?>" value="1" /><span></span>
                <input type="radio" name="<?php echo $this->id?>" value="2" /><span></span>
                <input type="radio" name="<?php echo $this->id?>" value="3" checked="checked"/><span></span>
                <input type="radio" name="<?php echo $this->id?>" value="4" /><span></span>
                <input type="radio" name="<?php echo $this->id?>" value="5" /><span></span>
            </div>
		    <p>
	    </div>
        <?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        echo basiceditor("Star Module","starmodule");
    }
    
}
?>