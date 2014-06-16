<?php

function showCreateSheet(){
?>
   
   <div class="col-md-10">
       <div class="row">
           <h1 class="text-center">Create a new sheet</h1>
           <div class="col-md-9">
                <font size="5">Title:</font> <input class="form-control" type="text" name="title" placeholder="Sheet title">   
           </div>
       </div>
       <hr>
       <div class="row" id="sheetmain"></div>
   </div>
   <div class="col-md-2 table-bordered text-center" id="floatdiv" >
   <h4 class="text-center">Add modules</h4>
   <p><button class="btn btn-block btn-primary" id="listmodule" onclick="return false;">Add List</button></p>
   <p><button class="btn btn-block btn-primary" id="longlistmodule" onclick="return false;">Add Long-List</button></p>
   
   <p><button class="btn btn-block btn-primary" id="textfieldmodule" onclick="return false;">Add Text-Field</button></p>
   <p><button class="btn btn-block btn-primary" id="textareamodule" onclick="return false;">Add Text-Area</button></p>
   
   <p><button class="btn btn-block btn-primary" id="checkboxmodule" onclick="return false;">Add Checkbox</button></p>
   <p><button class="btn btn-block btn-primary" id="slidermodule" onclick="return false;">Add Slider</button></p>

   <p><button class="btn btn-block btn-primary" id="starmodule" onclick="return false;">Add Star-Rating</button></p>
   <p><button class="btn btn-block btn-primary" id="datemodule" onclick="return false;">Add Date-Selection</button></p>

   <hr>
   <p><button class="btn btn-block btn-danger" id="clearbutton" onclick="return false;">Clear</button></p>
   </div>


<?php 
}


function addingJavaScript()
{
    ob_start();
    ?>
   
$(function() {
$("#listmodule").click(function(){addItemToBody("listmodule")});
$("#longlistmodule").click(function(){addItemToBody("longlistmodule")});
$("#textfieldmodule").click(function(){addItemToBody("textfieldmodule")});
$("#textareamodule").click(function(){addItemToBody("textareamodule")});
$("#checkboxmodule").click(function(){addItemToBody("checkboxmodule")});
$("#slidermodule").click(function(){addItemToBody("slidermodule")});
$("#starmodule").click(function(){addItemToBody("starmodule")});
$("#datemodule").click(function(){addItemToBody("datemodule")});
$("#clearbutton").click(function(){$("#sheetmain").empty();});
});
</script>
<script src="js/floating-1.12.js"></script>
<script type="text/javascript">
$(function() {$('#floatdiv').addFloating({targetTop: 80, snap: true });});  
<?php 
   return str_replace("\n","", ob_get_clean());
}


function reloadToSuccessPage($sheetid = "")
{
    //view=session/overview&sub=create
    $GET = "?view=".$_GET["view"]."&sub=".$_GET["sub"]."&create=success".$sheetid;
    ob_start();
    ?>
$(function()
{
	var url = window.location.href;

	if (url.indexOf("?")>-1)
	{
		url = url.substr(0,url.indexOf("?"));
	}	
	url += "<?php echo  $GET?>";

	setTimeout(function() {
		location.replace(url);
	}, 3000);
});
    <?php 
   return str_replace("\n","", ob_get_clean());
}


?>