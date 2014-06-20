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
        return "</script>
                <script src=\"js/bootstrap-select.min.js\"></script>
                <script type=\"text/javascript\">$('.selectpicker').selectpicker();</script>
                <script type=\"text/javascript\">";
    }

    /**
     * Echos the HTML code
     */
    public function html()
    {
?>
    <div class="text-center">
        <p><?php echo $this->values["text"]?></p>
        <p>
        <select class="selectpicker" data-style="btn-primary"> 
            <?php
            $i = 0;
             foreach($this->values["elements"] as $value){?>
            <option value="<?php echo $i?>"><?php echo $value;?></option>
            <?php $i++;}?>
        </select> 
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