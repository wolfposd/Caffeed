<?php


$encryptionKey = "cB6zFTHuc49aREg5";

function encrypt($value)
{
	global $encryptionKey;
	$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
	$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
	return trim(base64_encode($iv.mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $encryptionKey, $value, MCRYPT_MODE_CBC, $iv)));
}

function decrypt($value)
{
	global $encryptionKey;
	$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
	$value = base64_decode($value);
	$iv_dec = substr($value, 0, $iv_size);
	$ciphertext_dec = substr($value, $iv_size);
	$val = trim(mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $encryptionKey, $ciphertext_dec, MCRYPT_MODE_CBC, $iv_dec));
	return $val;
}


function show_message_dialog_with_text($message, $text="", $successOrError = true ,  $shouldReload = true, $reloadMethod = "reloadPage(2000);")
{
	if($shouldReload)
	{
		echo "<body onLoad='JavaScript:$reloadMethod'>";
	}

	$type = $successOrError === true  ? "success" : "error";
	
	echo "<div class='container alert alert-$type center span4' align='center'><h4>$message</h4><p>$text</p></div>";
}

?>