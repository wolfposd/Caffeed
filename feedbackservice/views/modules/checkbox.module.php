<?php



class checkbox implements IModule
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
        return false;
       // return '$("#'.$this->id.'").datepicker({format:"dd.mm.yyyy"});';
    }

    /**
     * Echos the HTML code
    */
    public function html()
    {
        ?>
        <div class="text-center">
	        <p/>
		    <p><?php echo $this->values["text"]?> <input type="checkbox" name="<?php echo $this->id?>"><p>
	    </div>
        <?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Checkbox Module","checkboxmodule");
    }
}


?>