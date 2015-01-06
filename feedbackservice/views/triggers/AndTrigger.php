<?php

class AndTrigger extends AbstractTrigger
{
    private $trigger1;
    private $trigger2;
    
    private $sheetid;
    
    
    function __construct($triggerinformation)
    {
        $this->sheetid = $triggerinformation["sheetid"];
        
        $trigger1 = $this->makeTrigger($triggerinformation["trigger"][0]);
        $trigger2 = $this->makeTrigger($triggerinformation["trigger"][1]); 
    }
    
    
    
    function getSheetId()
    {
        $id1 = $this->trigger1->getSheetId();
        $id2 = $this->trigger2->getSheetId();
        
        if($id1 == $id2)
        {
            return $this->sheetid;
        }
        else
        {
            return false;
        }
    }
    
    protected function filterContext($contextinformation)
    {
        $trigger1->filterContext($contextinformation);
        $trigger2->filterContext($contextinformation);
    }
    
    
    function makeTrigger($values)
    {
        return null; //hier muss was behoben werden
    }
    
    
}