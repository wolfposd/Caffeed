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
        
        $password = hash_SHA265($password);
        
        $query = "SELECT * FROM fb_feedback_user WHERE user_email = '$useremail' AND user_pwd_hashed = '$password'";
        
        $result = $this->mysqli->query($query);
        
        if($result !== false)
        {
            $numros = $result->num_rows;
            $result->free();
            
            return $numros === 1;
        }
        
        return false;
    }

    function registerNewUser($useremail, $userpwd, $firstname, $lastname)
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
            $hashidentifier = hash_SHA512($useremail . $firstname) . hash_SHA512($userpwd . $lastname);
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

    function addNewSheet($title, $username, $sheetmodulearray)
    {
        $title = $this->mysqli->real_escape_string($title);
        $username = $this->mysqli->real_escape_string($username);
        
        $subquery = "(SELECT user_id FROM fb_feedback_user WHERE user_email = '$username')";
        
        $querySheet = "INSERT INTO fb_question_sheet (user_id, rest_id, sheet_title) VALUES ($subquery, 'empty', '$title')";
        
        $result = $this->mysqli->query($querySheet);
        
        if($result !== false)
        {
            $sheet_id = $this->mysqli->insert_id;
            $result = false;
            $time = time();
            while ( $result === false )
            {
                $key = "" . ($time - rand(1, 500));
                $restid = base64_encode(hash_SHA265($sheet_id, $key, true));
                $restid = str_replace(array("+", "/", "="), "", $restid);
                
                $queryRestId = "UPDATE fb_question_sheet SET rest_id = '$restid' WHERE sheet_id = '$sheet_id'";
                
                $result = $this->mysqli->query($queryRestId);
            }
            
            foreach($sheetmodulearray as $module)
            {
                $values = $this->mysqli->real_escape_string(json_encode($module));
                $queryModule = "INSERT INTO fb_question_sheet_module (sheet_id, json_values) VALUES ('$sheet_id','$values')";
                $this->mysqli->query($queryModule);
            }
            
            return true;
        }
        else
        {
            return false;
        }
    }

    function getSheetJSON($sheetid)
    {
        $sheetid = $this->mysqli->real_escape_string($sheetid);
        
        $query = "SELECT sheet_title, json_values, B.id FROM fb_question_sheet as A, fb_question_sheet_module as B 
                WHERE A.sheet_id = B.sheet_id and A.rest_id = '$sheetid'";
        
        $result = $this->mysqli->query($query);
        
        if($result !== false && $result->num_rows > 0)
        {
            $returnval = array("title" => "notitle", "id" => $sheetid);
            
            // TODO react to multiple pages
            
            $pagearray = array();
            
            $page1 = new ArrayObject();
            
            $currentpage = 1;
            
            $page1["title"] = "Page $currentpage";
            $page1["elements"] = array();
            
            while ( $row = $result->fetch_row() )
            {
                $returnval["title"] = $row[0];
                $jsonarray = json_decode($row[1]);
                $jsonarray->id = $row[2];
                
                if($jsonarray->type =="pagebreak")
                {
                    $pagearray[] = $page1;
                    $currentpage++;
                    $page1 = new ArrayObject();
                    $page1["title"] = "Page $currentpage";
                    $page1["elements"] = array();
                }
                else
                {
                    $page1["elements"][] = $jsonarray;
                }
                
            }
            
            $pagearray[] = $page1;
            
            $returnval["pages"] = $pagearray;
            
            $result->free();
            return $returnval;
        }
        return array("error" => "no sheet with this id");
    }

    function getSheetCountForUser($useremail)
    {
        $useremail = $this->mysqli->real_escape_string($useremail);
        $query = "SELECT COUNT(*) FROM fb_question_sheet, fb_feedback_user 
                WHERE fb_feedback_user.user_id = fb_question_sheet.user_id AND fb_feedback_user.user_email = '$useremail'";
        
        $result = $this->mysqli->query($query);
        if($result === false)
        {
            return 0;
        }
        else
        {
            $num = $result->fetch_row();
            $num = $num[0];
            $result->free();
            return $num;
        }
    }

    function getLastCreatedSheetId($useremail)
    {
        $useremail = $this->mysqli->real_escape_string($useremail);
        $query = "SELECT rest_id FROM fb_question_sheet as fb INNER JOIN
                    (SELECT MAX(sheet_id) as result FROM fb_question_sheet as A, fb_feedback_user AS B 
                	WHERE A.user_id = B.user_id AND B.user_email = '$useremail') tmp on fb.sheet_id = tmp.result";
        
        $result = $this->mysqli->query($query);
        if($result !== false)
        {
            $row = $result->fetch_row();
            
            $result->free();
            return $row[0];
        }
        
        return false;
    }
}