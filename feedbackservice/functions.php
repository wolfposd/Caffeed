<?php


$encryptionKey = "4B6zQTkUc49aREg5";

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

/**
 * create an HMAC form message (optional a special key)
 * @param string $message the message to verify
 * @param string $customkey (optional) use a custom key
 * @return string Hex-Form string of SHA265 message
 */
function hash_SHA265($message, $customkey = false, $rawdata = false)
{
	if($customkey === false)
	{
		global $encryptionKey;
		$customkey = $encryptionKey;
	}
	
	return hash_hmac('SHA256', $message, $customkey, $rawdata);
}

/**
 * create an HMAC form message (optional a special key)
 * @param string $message the message to verify
 * @param string $customkey (optional) use a custom key
 * @return string Hex-Form string of SHA265 message
 */
function hash_SHA512($message, $customkey = false)
{
    if($customkey === false)
    {
        global $encryptionKey;
        $customkey = $encryptionKey;
    }

    return hash_hmac('SHA512', $message, $customkey);
}

function show_succes_or_error($success, $successTitle, $successMessage, $errorTitle,$errorMessage)
{
	if($success)
	{
		show_message_dialog_with_text($successTitle,$successMessage, $success);
	}
	else
	{
		show_message_dialog_with_text($errorTitle,$errorMessage, $success);
	}
}

function show_message_dialog_with_text($message, $text="", $successOrError = true)
{
	$type = $successOrError === true  ? "success" : "danger";

	echo "<div class='container alert alert-$type center span4' align='center'><h4>$message</h4><p>$text</p></div>";
}

/**
 * The onLoad message for reloading a Page with Javascript
 * @param number $reloadtime
 * @return string
 */
function reloadPageJavascriptTextForBody($reloadtime = 3000)
{
	return "onLoad=\"JavaScript:reloadPage($reloadtime);\"";
}

function redirectPageJavaScriptTextForBody($reloadtime=1500, $destination = "")
{
	return "onLoad=\"JavaScript:changeURL($reloadtime, '$destination');\"";
}

function getModuleForType($type, $values = array(), $moduleid = null)
{
    include_once 'views/modules/interface.module.php';
    foreach(glob("views/modules/*.php") as $filename)
    {
        include_once $filename;
    }

    $element;
    switch ($type)
    {
        case "listmodule" :
            $element = new listmodule($values, $moduleid);
            break;
        case "longlistmodule" :
            $element = new long_list($values, $moduleid);
            break;
        default :
            $classname = str_replace("module", "", $type);
            $element = call_user_func_array(array(new ReflectionClass($classname), 'newInstance'), array($values, $moduleid));
    }
    return $element;
}

/**
 * Returns javascript to reload to a page with specified get-params
 * @param array $paramArray
 * @param int $timeout timeout in milliseconds
 * @return javascript code
 */
function reloadToPageJavascriptWithParams(array $paramArray, $timeout = 3000)
{
    $params ="?";
    foreach($paramArray as $key => $value)
    {
        $params .="$key=$value&";
    }
    
    ob_start();
    ?>
$(function()
{
	var url = window.location.href;

	if (url.indexOf("?")>-1)
	{
		url = url.substr(0,url.indexOf("?"));
	}	
	url += "<?php echo  $params?>";

	setTimeout(function() {
		location.replace(url);
	}, <?php echo  $timeout?>);
});
    <?php 
   return str_replace("\n","", ob_get_clean());
}


function convertDatabaseSheetToModules($databasesheetarray)
{
    $sheetsheet = $databasesheetarray;
    
    $pages = array();
    
    foreach($sheetsheet["pages"] as $page)
    {
        $pagearray = array();
        $pagearray["title"] = $page["title"];
        $pagearray["id"] = str_replace(" ", "", $page["title"]);
    
        $elements = array();
    
        foreach($page["elements"] as $mod)
        {
            $module = getModuleForType($mod->type, (array) $mod, $mod->id);
            $elements[] = $module;
        }
        $pagearray["elements"] = $elements;
    
        $pages[] = $pagearray;
    }
    
    return $pages;
}

?>