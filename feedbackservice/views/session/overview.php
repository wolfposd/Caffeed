<?php
include_once 'database/database.php';
/**
 * This is the basic Template for controller-classes
 */
class Overview
{
    private $database;
    private $content = false;

    function __construct(database $database)
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
            switch ($_GET["sub"])
            {
                case "profile" :
                    {
                        include_once 'profile.php';
                        $this->content = new Profile($this->database);
                        break;
                    }
                case "create" :
                    {
                        include_once 'create.php';
                        $this->content = new Create($this->database);
                        break;
                    }
                case "analyze" :
                    {
                        include_once 'analyze.php';
                        $this->content = new Analyze($this->database);
                        break;
                    }
                case "preview" :
                    {
                        include_once 'preview.php';
                        $this->content = new Preview($this->database);
                        break;
                    }
                case "trigger" :
                    {
                        include_once 'trigger.php';
                        $this->content = new Trigger($this->database);
                        break;
                    }
                case "beacons" :
                    {
                        include_once 'beacons.php';
                        $this->content = new Beacons($this->database);
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
            $count = $this->database->getSheetCountForUser($_SESSION["user"]);
            $sheetResults = $this->database->getNumberOfResults($_SESSION["user"]);
            
            echo "<p>Welcome back, " . $_SESSION["user"] . "!</p>";
            echo "<p>You have created $count full sheets</p>";
            
            echo "<p>You have currently $sheetResults results for inspection</p>";
        }
    }

    function getNavigationBarLeftContent()
    {
        return array(
                array(
                        $this->makeSideEntry("Overview", "overview"),
                        $this->makeSideEntry("Profile", "profile")
                ),
                array(
                        $this->makeSideEntry("Create", "create"),
                        $this->makeSideEntry("Preview", "preview"),
                        $this->makeSideEntry("Analyze", "analyze")
                ),
                array(
                        $this->makeSideEntry("Create Contextgroup", "trigger"),
                        $this->makeSideEntry("Manage Beacons", "beacons")
                )
        );
    }

    function additionalJavascript()
    {
        if(method_exists($this->content, "additionalJavascript"))
        {
            return $this->content->additionalJavascript();
        }
        else
        {
            return false;
        }
    }

    function makeSideEntry($name, $link)
    {
        return array("name" => $name, "link" => ("?view=session/overview&sub=" . $link));
    }
}

?>