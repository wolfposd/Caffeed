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
    
    public function analyzehtml($results, $mappings = array())
    {
        return false;
    }

    public function getID()
    {
        return $this->id;
    }

    public function __toString()
    {
        return "module";
    }

    public function getText()
    {
        return $this->values["text"];
    }
    
    public function getElements()
    {
        return false;
    }
    
    
    protected function countSameElements($results)
    {
        $values = array();
        foreach($results as $result)
        {
            if(!isset($values[$result]))
            {
                $values[$result] = 0;
            }
            $values[$result]++;
        }
        return $values;
    }
}
