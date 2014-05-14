<?php

include_once 'functions.php';

class database
{
    private $mysqli;

    function __construct($db_host, $db_username, $db_password, $db_database)
    {
        $this->mysqli = new mysqli($db_host, $db_username, $db_password, $db_database);
    }
    function __destruct()
    {
    }
    
    function close()
    {
        $this->mysqli->close();
    }

    function verifyUserLoginInformation($useremail, $password)
    {
        $useremail = $this->mysqli->real_escape_string($useremail);
        $password = $this->mysqli->real_escape_string($password);

        $password =  hash_SHA265($password);

        $query = "SELECT * FROM feedback_user WHERE user_email = '$useremail' AND user_pwd_hashed = '$password'";

        $result =  $this->mysqli->query($query);

        if($result !== false)
        {
            $numros = $result->num_rows;
            $result->free();
            
            return $numros === 1;
        }

        return false;
    }
    
    

}