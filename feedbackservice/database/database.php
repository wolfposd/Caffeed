<?php

include_once 'functions.php';

class database
{
    private $mysqli;

    function __construct($db_host, $db_username, $db_password, $db_database)
    {
        $mysql = new mysqli($db_host, $db_username, $db_password, $db_database);
        $this->mysqli = $mysql;
    }
    function __destruct()
    {
    }
    
    function close()
    {
        $this->mysqli->close();
    }
    
    
    function lastError()
    {
        return $this->mysqli->error;
    }

    function verifyUserLoginInformation($useremail, $password)
    {
        $useremail = $this->mysqli->real_escape_string($useremail);
        $password = $this->mysqli->real_escape_string($password);

        $password =  hash_SHA265($password);

        $query = "SELECT * FROM fb_feedback_user WHERE user_email = '$useremail' AND user_pwd_hashed = '$password'";

        $result =  $this->mysqli->query($query);

        if($result !== false)
        {
            $numros = $result->num_rows;
            $result->free();
            
            return $numros === 1;
        }

        return false;
    }
    
    function registerNewUser($useremail, $userpwd, $firstname, $lastname )
    {
        $useremail = $this->mysqli->real_escape_string($useremail);
        $firstname = $this->mysqli->real_escape_string($firstname);
        $lastname = $this->mysqli->real_escape_string($lastname);

        $userpwd = hash_SHA265($userpwd);
        
        
        $query = "INSERT INTO fb_feedback_user (user_email, user_pwd_hashed, user_first_name, user_last_name, registration_pending) 
                                                VALUES ('$useremail', '$userpwd', '$firstname', '$lastname', 1)";
        $result = $this->mysqli->query($query);
        
        if($result === true)
        {
            $hashidentifier = hash_SHA512($useremail.$firstname).hash_SHA512($userpwd.$lastname);
            $query2 = "INSERT INTO fb_registration_pending ( hashidentifier, email) VALUES ( '$hashidentifier', '$useremail')";
            $r = $this->mysqli->query($query2);
        }
        
        return $result === true;
    }
    
    
    function removePendingEmail($hashident)
    {
        $hashident = $this->mysqli->real_escape_string($hashident);
        $query = "SELECT email FROM fb_registration_pending WHERE hashidentifier = '$hashident' LIMIT 1";
        
        $result = $this->mysqli->query($query);
        if($result !== false)
        {
            if($result->num_rows === 0)
            {
                $result->free();
                return false;
            }
            $email = $result->fetch_row();

            $email = $email[0];
            
            $result->free();   

            
            $query = "UPDATE fb_feedback_user SET registration_pending = 0 WHERE user_email = '$email'";
            $query2 = "DELETE FROM fb_registration_pending WHERE email = '$email' AND hashidentifier = '$hashident'";
            
            $this->mysqli->query($query);
            $this->mysqli->query($query2);
            
            return true;
        }
        
        return false;
    }
    
    
    
    function isUserNameFree($email)
    {
        $email = $this->mysqli->real_escape_string($email);
        
        $query = "SELECT user_email FROM fb_feedback_user WHERE user_email = '$email' LIMIT 1";
        $result = $this->mysqli->query($query);
        
        
        if($result !== false)
        {
            $numrows = $result->num_rows;
            $result->free();
            return $numrows == 0;
        }
        
        return false;
    }
    
    
    function isLoginCorrect($user, $pwd)
    {
        $user = $this->mysqli->real_escape_string($user);
        $pwd = hash_SHA265($pwd);
        
        $query = "SELECT user_email FROM fb_feedback_user WHERE user_email = '$user' AND user_pwd_hashed = '$pwd'";
        
        $result = $this->mysqli->query($query);
        
        if($result !== false)
        {
            $numrows = $result->num_rows;
            $result->free();
            return $numrows !== 0;
        }
        return false;
    }
}