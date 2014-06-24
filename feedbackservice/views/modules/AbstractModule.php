<?php

abstract class AbstractModule implements IModule 
{
    
    protected $values;
    protected $id;
    
    public function __construct(array $values, $id)
    {
        $this->id = $id;
        $this->values = $values;
    }
    
    public function javascript()
    {
        return "";
    }
    
    public function html()
    {
        
    }
    
    public function editorhtml()
    {
        
    }
    
    public function getID()
    {
        return $this->id;
    }
}
