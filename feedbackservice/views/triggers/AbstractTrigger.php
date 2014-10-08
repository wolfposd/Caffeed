<?php


abstract class AbstractTrigger
{

    private $filteredContext;
    
    function putContextInformation(array $contextinformation)
    {
       $this->filteredContext = $this->filterContext($contextinformation);
    }
    
    abstract function filterContext($contextinformation);
    
}

?>