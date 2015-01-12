<?php


/**
 * Interface for modules
 */
class listmodule extends AbstractModule
{
    
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
        <select class="selectpicker" data-style="btn-primary" name="<?php echo $this->id;?>"> 
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
        
        echo basiceditor("List Module","listmodule", '<p>Elements: (separated by &lt;newline&gt;)</p><textarea rows="5" cols="40" name="module_XXXX_elements"></textarea>');
    }
    
    public function getElements()
    {
        return $this->values["elements"];
    }
    
    
    public function analyzehtml($results, $mappings = array())
    {
        $values = $this->countSameElements($results);
        $count = array();
        
        foreach ($mappings as $index => $map)
        {
            if(isset($values[$index]))
            {
                $count[$index] = $values[$index];
            }
            else
            {
                $count[$index] = 0;
            }
        }
        //Additional filtering
        foreach ($values as $countValueKey => $countValue)
        {
           $index =  array_search($countValueKey, $mappings);
           if($index !== false)
           {
               $count[$index] += $countValue;
           }
        }
        
        ob_start();
        ?>
        <ul>
        <?php foreach ($count as $index => $value) { ?>
            <li><?php echo $mappings[$index];?> <span class="badge"><?php echo $value?></span></li>
        <?php } ?>
        </ul>
        <?php 
        return ob_get_clean();
    }
    
}

?>