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
            include_once 'profile.php';
            include_once 'create.php';
            include_once 'analyze.php';
            include_once 'preview.php';
            switch ($_GET["sub"])
            {
                case "profile" :
                    {
                        $this->content = new Profile($this->database);
                        break;
                    }
                case "create" :
                    {
                        $this->content = new Create($this->database);
                        break;
                    }
                case "analyze" :
                    {
                        $this->content = new Analyze($this->database);
                        break;
                    }
                case "preview" :
                    {
                        $this->content = new Preview($this->database);
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
            echo "<p>You have $count sheets</p>";
            
            if($count > 0)
            {
                echo "<p>Your sheet-ids:</p>";
                echo "<ul>";
                foreach($this->database->getSheetIdsForUser($_SESSION["user"]) as $sheetid)
                {
                    echo "<li><a href='?view=sheet&sheet=$sheetid'>$sheetid</a></li>";
                }
                echo "</ul>";
            }
            
            echo "<p>You have currently $sheetResults results for inspection</p>";
            echo "<p>...</p>";
        }
    }

    function getNavigationBarLeftContent()
    {
        return array(array($this->makeSideEntry("Overview", "overview"), $this->makeSideEntry("Profile", "profile")), 
                array($this->makeSideEntry("Create Sheet", "create"), $this->makeSideEntry("Analyze Sheet", "analyze"), 
                        $this->makeSideEntry("Preview Sheet", "preview")));
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