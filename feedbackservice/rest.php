<?php
include_once 'config.php';
include_once 'functions.php';
$application = new Application();
$application->handle();
class Application
{
    private $database;

    function __construct()
    {
        $this->database = getConnection();
    }

    function __destruct()
    {
        $this->database->close();
    }

    function handle()
    {
        $request = explode("/", substr(@$_SERVER['PATH_INFO'], 1));
        $rest = 'rest_' . strtolower($_SERVER['REQUEST_METHOD']) . "_" . $request[0];

        if(method_exists($this, $rest))
        {
            call_user_func(array($this, $rest), $request);
        }
    }

    /**
     * Returns the value that follows the specified key<br>
     * also does mysql_escape_string
     *
     * @param string $value
     *            needle
     * @param string-array $requestArr
     *            hackstack
     * @return string
     */
    function getRequestValue($key, &$requestArr)
    {
        if(in_array($key, $requestArr))
        {
            $index = array_search($key, $requestArr);
            if($index + 1 < count($requestArr))
            {
                return $requestArr[$index + 1];
            }
        }
        return false;
    }

    function rest_get_sheet($array)
    {
        $id = $this->getRequestValue("id", $array);
        if($id !== false)
        {
            if($id == 3)
            { // TESTING DATA
                echo '{"title":"Some Feedback for Company X","id":3,"pages":[{"title":"Page 1","elements":[{"type":"tos","id":"tos1","title":"Company X ToS","text":"By reading this you agree to the terms of service"}]},{"title":"Page 2","elements":[{"type":"list","id":"list1","text":"Pick one of the following","elements":["good","medium","bad"]},{"type":"photo","id":"photo1","text":"Please take a picture of your face"},{"type":"textfield","id":"textfield1","text":"Add any additonal comments"}]},{"title":"Page 3","elements":[{"type":"checkbox","id":"checkbox1","text":"Do you like flowers?"},{"type":"textarea","id":"textarea1","length":160,"text":"Add any additonal comments"},{"type":"slider","id":"slider1","text":"How much do you like flowers?","min":0,"max":2,"step":0.25}]},{"title":"Page 4","elements":[{"type":"star","id":"star1","text":"Please select your birthday"},{"type":"date","id":"date1","text":"Please select your birthday"},{"type":"auto-date","id":"auto-date1"},{"type":"accelerometer","id":"accelerometer1"},{"type":"gps","id":"gps1"}]}]}';
            }
            else
            {
                echo json_encode($this->database->getSheetJSON($id));
            }
        }
    }

    function rest_put_sheet($array)
    {
        $id = $this->getRequestValue("id", $array);
        if($id !== false)
        {
            $input = file_get_contents('php://input', 'r');

            $json = json_decode($input, true);

            if($id == 3)
            { // TESTING DATA
                if(isset($json["list1"]) && isset($json["photo1"]) && isset($json["textfield1"]))
                {
                    $this->displaySuccess();
                }
                else
                {
                    $this->displayUnsuccessful();
                }
            }
            else
            {
                $sheet = $this->database->getSheetJSON($id);
                if(isset($this->sheet["error"]))
                {
                    // echo error;
                    echo $this->sheet["error"];
                }
                else
                {
                    $sheet = convertDatabaseSheetToModules($sheet);
                    $resultsVerified = array();
                    foreach($sheet as $page)
                    {
                        foreach($page["elements"] as $module)
                        {
                            if(isset($json[$module->getID()]))
                            {
                                $resultsVerified[$module->getID()] = $json[$module->getID()];
                            }
                        }
                    }
                    $result = $this->database->insertResultsForSheet($id, $resultsVerified);

                    if($result)
                    {
                        $this->displaySuccess();
                    }
                    else
                    {
                        $this->displayUnsuccessful();
                    }
                }
            }
        }
    }

    function rest_get_internal_emailfree(array $array)
    {
        if(count($array) === 2)
        {
            $email = $array[1];
            $free = $this->database->isUserNameFree($email);
            echo $free === true ? "true" : "false";
        }
        else
        {
            echo "false";
        }
    }

    function rest_get_internal_module(array $array)
    {
        session_start();
        if(count($array) >= 2 && isset($_SESSION) && isset($_SESSION["login"]) && $_SESSION["login"] === true)
        {
            getModuleForType($array[1])->editorhtml();
        }
    }

    function displaySuccess()
    {
        echo "success";
    }

    function displayUnsuccessful()
    {
        echo "unsuccessful";
    }

    
    function rest_get_submitsheetforcontext(array $array)
    {
        $this->rest_put_sheetforcontext($array);
    }
    
    function rest_get_sheetforcontext(array $array)
    {
        $contextInformation = json_decode(base64_decode($array[1]) ,true);
        $beacons = $contextInformation["beacons"];
        $uuid = $beacons[0]["uuid"];

        $triggerGroupId  = $this->database->getGroupIdForBeacons($uuid);

        $triggers  = $this->database->getTriggersForGroupId($triggerGroupId);
        
        
        $sheetIds = array();
        
        include_once 'views/triggers/BeaconTrigger.php'; //TODO - include by $trigger["type"]
        
        foreach ($triggers as $trigger)
        {
            if(isset($trigger["extra"]["beacon"]))
            {
                $beacon = $this->database->getBeaconForBeaconId($trigger["extra"]["beacon"]);
                $trigger["extra"]["beacon"] = $beacon;
            }
            $bt = new BeaconTrigger($trigger["extra"]); //TODO - instantiate by $trigger["type"]
            
            $bt->putContextInformation($contextInformation);
            
            $sheetid = $bt->getSheetId();
            if($sheetid !== false)
            {
                $sheetIds[] = $this->database->getSheetJSONbyID($sheetid);
            }
        }
        
        $sheetIds = stripSheetsFromDescriptiveElementsForContext($sheetIds);
        
        echo json_encode($sheetIds);
    }
    
    function rest_put_sheetforcontext(array $array)
    {
        $participantId = $this->database->insertQueryParticipant();
        
        $sheetresults = json_decode(base64_decode($array[1]),true);
        
        foreach($sheetresults as $key => $value)
        {
            $sheetID = $this->database->getSheetIDforModuleID($key);
            
            $this->database->insertSheetResults($participantId, $sheetID, array($key => $value));
        }
        
        
        echo json_encode(array("success" => true));
    }

}
