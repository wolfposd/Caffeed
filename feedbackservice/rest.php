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
                    echo "success";
                }
                else
                {
                    echo "unsuccessfull";
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
        if(count($array) >= 2)
        {
            getModuleForType($array[1])->editorhtml();
        }
    }
}
