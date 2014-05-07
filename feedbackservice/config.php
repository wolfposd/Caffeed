<?php


function getConnection()
{
	$db_host = "localhost";
	$db_database = "feedback";
	$db_username ="test";
	$db_password ="test";
	return new mysqli($db_host, $db_username, $db_password, $db_database);
}

?>