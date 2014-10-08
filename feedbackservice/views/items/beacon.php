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
}