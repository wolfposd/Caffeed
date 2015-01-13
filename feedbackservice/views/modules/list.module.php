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
        $numOfResults = sizeof($results);
        
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
        
        
        foreach ($values as $countValueKey => $countValue)
        {
           $index =  array_search($countValueKey, $mappings);
           if($index !== false && $index !== 0)
           {
               $count[$index] += $countValue;
           }
        }
        
        ob_start();
        ?>
        <?php foreach ($count as $index => $value) { 
            $percent = $value * 100 / $numOfResults;
            
            $percent = round($percent,1);
            ?>
            <div class="row">
                <div class="col-sm-6">
                    <div class="progress">
                      <?php if($percent > 0) { ?>
                      <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="<?php echo $percent?>" aria-valuemin="0" aria-valuemax="100" style="width: <?php echo $percent?>%;">
                        <?php echo $mappings[$index];?> (<?php echo $value?>)  - <?php echo $percent?> %
                      </div>
                      <?php } else {?>
                      <div class="progress-bar progress-bar-none" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100" style="width: 25%;">
                          <?php echo $mappings[$index];?> (<?php echo "".$value?>)  - <?php echo $percent?> %
                      </div>
                      <div class="progress-bar progress-bar-none" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 75%;">
                      </div>
                      <?php }?>
                    </div>
                </div>
            </div>
        <?php } ?>
        <?php 
        return ob_get_clean();
    }
    
}

?>