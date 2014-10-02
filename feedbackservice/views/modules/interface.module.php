<?php

/**
 * Interface for modules
 */
interface IModule
{
    /**
     * Create the module
     * 
     * @param array $values
     *            is the rest-json-array as used in rest-api
     * @param string $id
     *            used for html-id
     */
    public function __construct(array $values, $id);

    /**
     * Returns Javascript code or <b>empty-string</b>
     */
    public function javascript();

    /**
     * Echos the HTML code
     */
    public function html();

    /**
     * Echos the HTML code needed for creation of this module
     */
    public function editorhtml();
    
    /**
     * Returns this modules id;
     */
    public function getID();
    
    /**
     * Returns the text of this module
     */
    public function getText();
    
    /**
     * Returns the Elements if this Module has any, or false<br>
     * This is used for result-to-text mapping-reasons during analysis
     */
    public function getElements();
}

?>