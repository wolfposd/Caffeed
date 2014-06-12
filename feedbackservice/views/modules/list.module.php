<?php


/**
 * Interface for modules
 */
class listmodule implements IModule
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
        <p>Pick one of the following</p>
        <p>
        <?php foreach($this->values["elements"] as $value){?>
	        <button type="button" class="btn-primary btn-sm" name="<?php echo $this->id?>" id="<?php echo $this->id?>"><?php echo $value?></button>
        <?php }?>
	    </p>
    </div>
<?php 
    }
    
    /**
     * Echos the HTML code needed for creation of a sheet
     */
    public function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("List Module","listmodule", '<p>Elements: (seperated by &lt;newline&gt;)</p><textarea rows="5" cols="40" name="module_XXXX_elements"></textarea>');
    }

}

?>