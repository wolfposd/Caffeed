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
    
    function analyzehtml($results, $mappings = array())
    {
        $values = $this->countSameElements($results);

        for($i = 1; $i <= 5; $i++)
        {
            if(!isset($values[$i]))
            {
                $values[$i] = 0;
            }
        }
        ksort($values);
        
        $average = 0;
        $countresults = count($results);
        
        foreach($values as $index => $val)
        {
            $average += ($val*$index);
        }
        
        $average = round($average/$countresults, 1);
        
        return "Avarage is: " .  $average;
    }
}
?>