<?php

require_once 'views/items/beacon.php';
require_once "views/triggers/AbstractTrigger.php";

class BeaconTrigger extends AbstractTrigger
{
    private $beacon;
    private $beaconDetectAmount;
    private $minTimeBetween;
    private $sheetid;

    function __construct($triggerinformation)
    {
        $this->beacon = $triggerinformation["beacon"];
        $this->beaconDetectAmount = $triggerinformation["detectamount"];
        $this->minTimeBetween = $triggerinformation["mintimebetween"];
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


    function getSheetId()
    {
        $beaconDetected = count($this->filteredContext);
        $time = 0;

        $arraycopy = $this->filteredContext;
        array_sort_by_column($arraycopy, "seen");
        

        for($i = 0 ; $i < count($arraycopy) - 1; $i++)
        {
            $val1 = $arraycopy[$i];
            $val2 = $arraycopy[$i+1];
            
            if($val1["type"] == "enter" && $val2["type"] == "exit")
            {
                $enterTime = strtotime($val1["seen"]);
                $exitTime = strtotime($val2["seen"]);
                
                $time += round(abs($exitTime - $enterTime) / 60,2);
                $i++;
            }
            else if( $val2["type"] == "enter")
            {
                unset($arraycopy[$i+1]);
                $arraycopy = array_values($arraycopy);
                $i--;
            }
        }
        
        //echo "amount:".$beaconDetected."<br>time:".$time."<br>";

        if($this->minTimeBetween < $time && $this->beaconDetectAmount < $beaconDetected)
        {
            return $this->sheetid;            
        }
        else
        {
            return false;
        }
    }



} // END CLASS

function array_sort_by_column(&$arr, $col, $dir = SORT_ASC) {
    $sort_col = array();
    foreach ($arr as $key=> $row) {
        $sort_col[$key] = $row[$col];
    }

    array_multisort($sort_col, $dir, $arr);
}


?>