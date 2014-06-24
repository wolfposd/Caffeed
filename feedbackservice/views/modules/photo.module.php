<?php



class photo extends AbstractModule
{

    public function html()
    {
        ?>
        <div class="text-center">
            <p></p>
    	    <p><?php echo $this->values["text"]?><p>
    	    <button class="btn btn-primary">Select</button>
        </div>
        <?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Photo Module","photomodule");
    }
}


?>