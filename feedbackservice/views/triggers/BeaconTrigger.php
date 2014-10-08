<?php

require_once 'views/items/beacon.php';

class BeaconTrigger extends AbstractTrigger
{
    private $beacon;
    private $beaconDetectAmount;
    private $maxTimeBetween;
    private $sheetid;
    
    function __construct($triggerinformation)
    {
        $this->beacon = $triggerinformation["beacon"];
        $this->beaconDetectAmount = $triggerinformation["detectamount"];
        $this->maxTimeBetween = $triggerinformation["maxtimebetween"];
        $this->sheetid = $triggerinformation["sheetid"];
    }
    
    function filterContext($contextinformation)
    {
        $filteredBeacons = array();
        
        $beacons = $contextinformation["beacons"];
        
        foreach ($beacons as $beacon)
        {
            if($this->beacon->isEqual($beacon))
            {
                $filteredBeacons[] = $beacon;
            }
        }
        
        return $filteredBeacons;
    }
}


?>