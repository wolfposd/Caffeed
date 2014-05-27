<?php

/**
 * This is the basic Template for controller-classes
 */
class Overview
{
    private $database;

    private $content = false;

    function __construct($database)
    {
        $this->database = $database;
    }
    function __destruct()
    {
    }


    function setup()
    {
        if(isset($_GET["sub"]))
        {
            include_once 'profile.php';
            include_once 'create.php';
            include_once 'analyze.php';
            switch($_GET["sub"])
            {
                case "profile":
                    {
                        $this->content = new Profile($this->database);
                        break;
                    }
                case "create":
                    {
                        $this->content = new Create($this->database);
                        break;
                    }
                case "analyze":
                    {
                        $this->content = new Analyze($this->database);
                        break;
                    }
            }
            if($this->content)
            {
                $this->content->setup();
            }
        }
    }


    function display()
    {
        if($this->content)
        {
            $this->content->display();
        }
        else
        {
            echo "<p>Welcome back, ".$_SESSION["user"]."!</p>";
            echo "<p>You have 10 sheets</p>";
            echo "<p>You have 500 new results</p>";
            echo "<p>...</p>";
        }
    }


    function getNavigationBarLeftContent()
    {
        return array(
                array
                (
                        array("name"=>"Overview", "link"=>$this->makeLink("overview")), array("name"=>"Profile", "link"=>$this->makeLink("profile"))
                ), // separation
                array
                (
                        array("name"=>"Create Sheet", "link"=>$this->makeLink("create")), array("name"=>"Analyze Sheet", "link"=>$this->makeLink("analyze"))
                )
        );
    }


    function makeLink($dest)
    {
        return "?view=session/overview&sub=".$dest;
    }

}


?>