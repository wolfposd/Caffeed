<?php



class checkbox extends AbstractModule
{
    
    public function html()
    {
        ?>
        <div class="text-center">
	        <p/>
		    <p><?php echo $this->values["text"]?> 
		    <input type='hidden' value='0' name='<?php echo $this->id?>'>
		    <input type="checkbox" name="<?php echo $this->id?>">
		    <p>
	    </div>
        <?php 
    }
    
    public function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Checkbox Module","checkboxmodule");
    }
    
    
    public function getElements()
    {
        $on = "<span class='glyphicon glyphicon-ok'></span>";
        $off = "<span class='glyphicon glyphicon-remove'></span>";
        
        return array("on" => $on, "1" => $on, "off" => $off, "0" => $off);
    }
    
    public function analyzehtml($results, $mappings = array())
    {
        $values = $this->countSameElements($results);
        $realVals = array(0,0);
        $count = 0;
        foreach ($values as $key => $value)
        {
            if($key === "on" || $key === "1")
            {
                $realVals[1] += $value;
            }
            else
            {
                $realVals[0] += $value;
            }
            $count += $value;
        }
        
        
        $pNo = round($realVals[0] * 100 / $count,1);
        $pYes = round($realVals[1] * 100 / $count,1);
        
        
        ob_start();
        ?>
        <p><label>YES: <?php echo $realVals[1]?> in P: <?php echo $pYes?>%</label></p>
        <p><label>NO: <?php echo $realVals[0]?> in P: <?php echo $pNo?>%</label></p>
        <?php 
        return ob_get_clean();
    }
}


?>