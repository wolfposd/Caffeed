<?php


function getConnection()
{
	$db_host = "localhost";
	$db_database = "beecon";
	$db_username ="root";
	$db_password ="jkddd5";
	return new mysqli($db_host, $db_username, $db_password, $db_database);
}

?>