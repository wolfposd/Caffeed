<?php


abstract class AbstractTrigger
{

    protected $filteredContext;

    function putContextInformation(array $contextinformation)
    {
        $this->filteredContext = $this->filterContext($contextinformation);
    }


    /**
     * Returns the sheet id if context information match this trigger or false if no match
     */
    abstract function getSheetId();

    protected abstract function filterContext($contextinformation);
}

?>