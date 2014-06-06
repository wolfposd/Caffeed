<?php




function showCreateSheet(){
?>
   
   
   <div class="col-md-10">
       <div class="row">
           <h1 class="text-center">Create a new Sheet</h1>
           <div class="col-md-5">
                 Title: <input class="form-control" type="text" name="title" placeholder="Sheet title">   
           </div>
       </div>
       <div class="row" id="sheetmain">
       </div>
   </div>
   <div class="col-md-2 table-bordered text-center">
   <h4 class="text-center">Add controls</h4>
   <p><button class="btn btn-block btn-primary" id="listmodule">Add List</button></p>
   <p><button class="btn btn-block btn-primary" id="longlistmodule">Add Long-List</button></p>
   
   <p><button class="btn btn-block btn-primary" id="textfieldmodule">Add Text-Field</button></p>
   <p><button class="btn btn-block btn-primary" id="textareamodule">Add Text-Area</button></p>
   
   <p><button class="btn btn-block btn-primary" id="checkboxmodule">Add Checkbox</button></p>
   <p><button class="btn btn-block btn-primary" id="slidermodule">Add Slider</button></p>

   <p><button class="btn btn-block btn-primary" id="starmodule">Add Star-Rating</button></p>
   <p><button class="btn btn-block btn-primary" id="datemodule">Add Date-Selection</button></p>

   <hr>
   <p><button class="btn btn-block btn-danger" id="clearbutton">Clear</button></p>
   </div>


<?php 
}


function addingJavaScript()
{
    ob_start();
    ?>
$(function() 
{

$("#listmodule").click( function(){
		$("#sheetmain").append("<ul><li>item</li><li>item</li></ul>");
	});
$("#longlistmodule").click( function(){
		$("#sheetmain").append("Adding long list");
	});
$("#textfieldmodule").click( function(){
		$("#sheetmain").append("adding textfield");
	});
$("#textareamodule").click( function(){
		$("#sheetmain").append("adding textarea");
	});
$("#checkboxmodule").click( function(){
		$("#sheetmain").append("adding checkbox");
	});
$("#slidermodule").click( function(){
		$("#sheetmain").append("adding slider");
	});
$("#starmodule").click( function(){
		$("#sheetmain").append("adding stars");
	});
$("#datemodule").click( function(){
		$("#sheetmain").append("adding date");
	});
$("#clearbutton").click( function(){
		$("#sheetmain").html("");
	});
});
<?php 
   return ob_get_clean();
}



?>