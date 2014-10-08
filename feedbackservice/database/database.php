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
        
        $password = hash_SHA256($password);
        
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
        
        $userpwd = hash_SHA256($userpwd);
        
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
        $pwd = hash_SHA256($pwd);
        
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

    function addNewSheet($title, $username, $sheetmodulearray, $isfullsheet)
    {
        $title = $this->mysqli->real_escape_string($title);
        $username = $this->mysqli->real_escape_string($username);
        $isfullsheet = $this->mysqli->real_escape_string($isfullsheet);
        
        $subquery = "(SELECT user_id FROM fb_feedback_user WHERE user_email = '$username')";
        
        $querySheet = "INSERT INTO fb_question_sheet (user_id, rest_id, sheet_title, isfullsheet) VALUES ($subquery, 'empty', '$title', '$isfullsheet')";
        
        $result = $this->mysqli->query($querySheet);
        
        if($result !== false)
        {
            $sheet_id = $this->mysqli->insert_id;
            $result = false;
            $time = time();
            while ( $result === false )
            {
                $key = "" . ($time - rand(1, 500));
                $restid = base64_encode(hash_SHA256($sheet_id, $key, true));
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

    /**
     * Returns the sheet
     *
     * @param string $rest_id
     *            the rest_id
     * @return multitype:string multitype:multitype: Ambigous <multitype:, mixed> unknown |multitype:string
     */
    function getSheetJSON($rest_id)
    {
        $rest_id = $this->mysqli->real_escape_string($rest_id);
        
        $query = "SELECT sheet_title, json_values, B.id FROM fb_question_sheet as A, fb_question_sheet_module as B 
                WHERE A.sheet_id = B.sheet_id and A.rest_id = '$rest_id'";
        
        $result = $this->mysqli->query($query);
        
        if($result !== false && $result->num_rows > 0)
        {
            $returnval = array("title" => "notitle", "id" => $rest_id);
            
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
                
                if($jsonarray->type == "pagebreak")
                {
                    $pagearray[] = $page1;
                    $currentpage ++;
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

    function getSheetIdsForUser($useremail)
    {
        $useremail = $this->mysqli->real_escape_string($useremail);
        $query = "SELECT rest_id FROM fb_question_sheet, fb_feedback_user
        WHERE fb_feedback_user.user_id = fb_question_sheet.user_id AND fb_feedback_user.user_email = '$useremail' AND isfullsheet = 1";
        
        $result = $this->mysqli->query($query);
        if($result === false)
        {
            return array();
        }
        else
        {
            $arr = array();
            while ( $row = $result->fetch_row() )
            {
                $arr[] = $row[0];
            }
            $result->free();
            return $arr;
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

    function insertResultsForSheet($sheetid, array $sheetresults)
    {
        $sheetid = $this->mysqli->real_escape_string($sheetid);
        $sheetidquery = "SELECT sheet_id from fb_question_sheet WHERE rest_id = '$sheetid' LIMIT 1";
        $result = $this->mysqli->query($sheetidquery);
        if($result !== false)
        {
            $sid = $result->fetch_row();
            $sid = $sid[0];
            $result->free();
            
            $queryParticipant = "INSERT INTO fb_question_sheet_participation (sheet_id) VALUES ($sid)";
            
            $this->mysqli->query($queryParticipant);
            
            $participantid = $this->mysqli->insert_id;
            
            $query = "INSERT INTO fb_question_sheet_results (sheet_id, module_id, participant_id, result) VALUES ";
            
            $queryinserts = array();
            
            foreach($sheetresults as $moduleid => $result)
            {
                $moduleid = $this->mysqli->real_escape_string($moduleid);
                $result = $this->mysqli->real_escape_string($result);
                
                $queryinserts[] = "($sid, $moduleid, $participantid, '$result')";
            }
            
            $result = $this->mysqli->query($query . implode(",", $queryinserts));
            
            return $result;
        }
        
        return false;
    }

    function getNumberOfResults($user)
    {
        $user = $this->mysqli->real_escape_string($user);
        $query = "SELECT COUNT(aa.sheet_id) 
            FROM fb_question_sheet_participation AS aa, fb_question_sheet AS bb, fb_feedback_user AS cc
            WHERE cc.user_email = '$user' AND aa.sheet_id = bb.sheet_id AND bb.user_id = cc.user_id";
        
        $result = $this->mysqli->query($query);
        
        if($result !== false)
        {
            $row = $result->fetch_row();
            $row = $row[0];
            
            $result->free();
            return $row;
        }
        
        return 0;
    }
    
    function getSheetInfosForUser($username)
    {
        
        $username = $this->escape($username);
        
        $query = "SELECT sheet.rest_id, sheet.sheet_title, sheet.creation_date FROM fb_question_sheet as sheet, fb_feedback_user as user
        WHERE sheet.user_id = user.user_id AND user.user_email = '$username' AND isfullsheet = 1";
        
        $result = $this->mysqli->query($query);
        
        if($result !== false)
        {
            $resularr = array();
            while($row = $result->fetch_row())
            {
                $resularr[] = $row;
            }
            
            return $resularr;
        }

        return false;
    }

    function getResultsForSheet($restid)
    {
        $restid = $this->escape($restid);
        
        $query = "SELECT CC.module_id, CC.result FROM  fb_question_sheet_results AS CC, fb_question_sheet AS AA
                WHERE AA.rest_id = '$restid' AND CC.sheet_id = AA.sheet_id";
        
        $queryresult = $this->mysqli->query($query);
        if($queryresult !== false)
        {
            $resultarr = array();
            
            while ( $row = $queryresult->fetch_row() )
            {
                $resultarr[$row[0]][] = $row[1];
            }
            
            $queryresult->free();
            return $resultarr;
        }
        
        return false;
    }

    function escape($string)
    {
        return $this->mysqli->real_escape_string($string);
    }
}