<?php

class Beacon
{
    public $uuid;
    public $major;
    public $minor;

    function __construct($uuid, $major, $minor)
    {
        $this->uuid = $uuid;
        $this->major = $major;
        $this->minor = $minor;
    }


    static function makeBeacon($fromString)
    {
        $vals = explode("-", $fromString);

        if(count($vals) == 3)
        {
            return new Beacon($vals[0], $vals[1], $vals[2]);
        }
        return false;
    }


    /**
     * Check if an Array containing beaconinformation is equal to this beacon
     * @param array $beaconinfo
     * @return boolean
     */
    function isEqual(array $beaconinfo)
    {
        return $this->uuid == $beaconinfo["uuid"] &&
        $this->major == $beaconinfo["major"] &&
        $this->minor == $beaconinfo["minor"];
    }

    function __toString()
    {
        return "Beacon[".$this->uuid . "-" . $this->major . "-" . $this->minor ."]";
    }
}