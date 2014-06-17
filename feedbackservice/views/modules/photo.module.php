<?php



class photo implements IModule
{
    private $values;
    private $id;
    
    function __construct(array $values, $id)
    {    
        $this->values = $values;
        $this->id = $id;
    }

    /**
     * Returns Javascript code
    */
    public function javascript()
    {
        return "";
    }

    /**
     * Echos the HTML code
    */
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