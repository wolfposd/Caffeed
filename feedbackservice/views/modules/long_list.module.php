<?php

include_once 'list.module.php';
/**
 * Interface for modules
 */
class long_list extends listmodule
{

    /**
     * Echos the HTML code
     */
    public function html()
    {
?>
    <div class="text-center">
        <p><?php echo $this->values["text"]?></p>
       <select class="selectpicker" data-style="btn-primary" data-live-search="true" name="<?php $this->id?>"> 
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
    '<p>Elements: (separated by &lt;newline&gt;)</p><textarea rows="5" cols="40" name="module_XXXX_elements"></textarea>');
    }
     
    public function getElements()
    {
        return $this->values["elements"];
    }
}

?>