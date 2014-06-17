<?php


/**
 * Interface for modules
 */
class long_list implements IModule
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
        <p class="text-center">Pick one of the following</p>
       <select class="selectpicker" data-style="btn-primary" data-live-search="true"> 
            <?php
            $i = 0;
             foreach($this->values["elements"] as $value){?>
            <option value="<?php echo $i?>"><?php echo $value;?></option>
            <?php $i++;}?>
        </select> 
    </div>
<?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Long List Module","longlistmodule", 
    '<p>Elements: (seperated by &lt;newline&gt;)</p><textarea rows="5" cols="40" name="module_XXXX_elements"></textarea>');
     }

}

?>