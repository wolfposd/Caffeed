<?php

/**
 * This is the basic Template for controller-classes
 */
class Rest
{
	private $database;
	
	
	private $modules = array();

	function __construct(database $database)
	{
		$this->database = $database;
	}
	function __destruct()
	{
	}

	function display()
	{
        include_once 'views/modules/interface.module.php';
        foreach (glob("views/modules/*.php") as $filename)
        {
            include_once $filename;
        }
	    
	    
	    $this->modules["list"] = new listmodule(array("text"=>"Pick one of the following", "elements"=>array("good","medium","bad")), "list1");
	    $this->modules["long_list"] = new long_list(array("text"=>"Pick one of the following", "elements"=>array("best", "better", "good", "medium", "bad", "worse","worst")), "long_list1");
	    $this->modules["slider"] = new slider(array("text"=>"How much do you like flowers?", "min"=>0, "max"=>2, "step"=>0.25), "slider5");
	    $this->modules["star"] = new star(array("text"=>"How much do you like flowers?"), "star4");
	    $this->modules["textfield"] = new textfield(array("text"=>"Add any additonal comments","length"=>160), "textfield1");
	    $this->modules["textarea"] = new textarea(array("text"=>"Add any additonal comments","length"=>160), "textarea1");
	    $this->modules["date"] = new date(array("text"=>"Please select your birthday"), "date1");
	    $this->modules["checkbox"] = new checkbox(array("text"=>"Do you like flowers"), "checkbox1");
	    $this->modules["photo"] = new photo(array("text"=>"Please select a photo"), "photo1");
	    
		echo $this->show();
	}
	
	function additionalJavascript()
	{
	    
	    $result = "";
	    foreach($this->modules as $module)
	    {
	        $result.=$module->javascript()."\n";
	    }
	    
	    return $result.'$(function(){window.prettyPrint&&prettyPrint();$("#dp1").datepicker({format:"dd.mm.yyyy"})});';
	}





function show()
{
?>
<div id="page">
<div class="row">
	<div class="col-md-3">
		<img src="img/rest-area.png" width="256" height="256">
	</div>
	<div class="col-md-6">
		<h1 class="page-header">Guide to using the REST-API</h1>
		<p>Here you can find all necessary information for accessing the provided functions of this service via a REST-API.</p>
		<p>The base URL for every REST-Request is "<b>http://beeqn.informatik.uni-hamburg.de/feedback/rest.php/</b>" .</p>
	</div>
	<div class="col-md-2 well">
	    <div class="bs-docs-sidebar hidden-print" >
            <ul class="nav bs-docs-sidenav">
		        <li class="active"><a href="#1">1. Getting a question-sheet</a>
		            <ul class="nav bs-docs-sidenav">
    		        <li class="active"><a href="#1.1">1.1 Response content</a></li>
    		        <li class="active"><a href="#1.2">1.2 Sheet-Modules</a></li>
    		        <li>
    		            <ul class="nav bs-docs-sidenav">
        		            <li class="active"><a href="#1.2.1">1.2.1 Visible Modules</a></li>
        		            <li class="active"><a href="#1.2.2">1.2.2 Invisible Modules</a></li>
    		            </ul>
		            </li>
		            </ul>
		        </li>
	        </ul>
        </div>
	</div>
</div>
<div class="row">
	<div class="col-md-offset-3 col-md-6"> <!-- begin rest info -->
		<h2 id="1">1. Getting a question-sheet</h2>
		<p>To get the necessary data for displaying a question-sheet you will need to issue a <b>GET</b>-Request with the following parameters:</p>
		<ol>
		<li>sheet</li>
		<li>id</li>
		<li>&lt;id&gt;</li>
		</ol>
		<p>Like so: http://beeqn.informatik.uni-hamburg.de/feedback/rest.php/sheet/id/3</p>
		<h3>1.1 Response content</h3>
		<p>The Server will answer with the following JSON object</p>
		
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicJSONCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li>The <b>title</b> of this question-sheet. Should be displayed on every page.</li>
    			        <li>The <b>id</b> of this question-sheet. This is the same id you used when fetching this sheet.</li>
    			        <li><b>submitbuttononpage</b> tells you on which page the submit-button should be located</li>
    			        <li>The <b>pages</b>-array tells you how many pages this sheet has.
    			            <ul>
    			                <li><b>title</b> tells you the page title</li>
    			                <li><b>elements</b> is an array of elements containing the various sheet-modules</li>
    			            </ul>
    			        </li>
    			    </ol>
    			</td>
			</tr>
		</table>
		
		<h3 id="1.2">1.2 Sheet-Modules</h3>
		<p>Every question-sheet is made up of different modules. Depending on the type of module different keys and values will be set in the servers response.</p>
		<p>The modules are all similarly structured. They each begin with <b>type</b> and <b>id</b>. The <b>type</b> tells you what kind of module is supposed to be displayed and the <b>id</b> tells you the id to use when submitting the filled out sheet.</p>
		<p>The modules can be divided into two categories: <b>visible</b> and <b>invisible</b> modules. Visible modules will need to be operated by the user, whereas invisible modules will collect additional meta-data.</p>
		
		<h3 id="1.2.1">1.2.1 Visible Modules</h3>
		<h4>List-Module</h4>
		<p>The List-Module is used to display a list of items, where a single element is supposed to be selected by the user.</p>
		
		
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicListJSONCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed above the list, to give the user an idea of what selection is expected from him.</li>
    			        <li><b>elements</b> is an array of items, which should be displayed in the list for selection.</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			        <?php $this->modules["list"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		
		<h4>Long-List-Module</h4>
		<p>The long list module is similar to the normal list module, but it will hold alot more items.</p>
		
		
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicLongListJSONCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed above the list, to give the user an idea of what selection is expected from him.</li>
    			        <li><b>elements</b> is an array of items, which should be displayed in the list for selection.</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center"><!-- show long list -->
    			    <?php $this->modules["long_list"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		
		<h4>Textfield-Module</h4>
		<p>The textfield module is used to have the user input a short text. It has an optional length-limit</p>
		
		
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicTextfieldJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>length</b> describes the maximum amount of characters, which can be entered by the user.</li>
    			        <li><b>text</b> contains the text, which should be displayed above the textfield, to give the user an idea of what kind of input is expected from him.</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			        <?php $this->modules["textfield"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		
		<h4>Textarea-Module</h4>
		<p>The textarea module is used to have the user input a long text. It has an optional length-limit</p>
		
		
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicTextareaJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>length</b> describes the maximum amount of characters, which can be entered by the user.</li>
    			        <li><b>text</b> contains the text, which should be displayed above the textfield, to give the user an idea of what kind of input is expected from him.</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			        <?php $this->modules["textarea"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h4>Checkbox-Module</h4>
		<p>The checkbox module is to indicate if a user either approves or disproves of a certain property.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicSwitchJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed alongside the checkbox</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			       <?php $this->modules["checkbox"]->html(); ?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h4>Slider-Module</h4>
		<p>The slider module enables the user to select a preference via the slider between given bounds.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicSliderJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed alongside the checkbox</li>
    			        <li><b>min</b> contains the absolute minimum value the slider should be able to select</li>
    			        <li><b>max</b> contains the absolute maximum value the slider should be able to select</li>
    			        <li><b>step</b> contains the value to be increased/decreased on slider movement</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			        <?php $this->modules["slider"]->html(); ?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h4>Star Rating Module</h4>
		<p>The star rating module enables the user to select a preference based on a value from 1 to 5 stars.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicStarRatingJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed alongside the star-rating</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			        <?php $this->modules["star"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h4>Date-Module</h4>
		<p>The date module will prompt the user with a date-selection.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicDateJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed to indicate additional tasks for the date picking process</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			        <?php $this->modules["date"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h4>Photo-Module</h4>
		<p>The photo module will prompt the user to select a photo from the library or to take a photo with the camera.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicPhotoJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>text</b> contains the text, which should be displayed to indicate additional tasks for the photo</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
    			    <?php $this->modules["photo"]->html();?>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h4>Terms of Service-Module</h4>
		<p>The ToS Module will display your terms of service along with an accept or decline button.</p>
		<p>If you choose to display the ToS-Module it needs to be located on the first page without any additional modules, because a progressing in the question-sheet will only be possible by pressing "Accept"</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicTOSJsonCodeSnippet();?></pre></td>
    			<td>
    			    <ol>
    			        <li><b>title</b> contains the title displayed above the ToS</li>
    			        <li><b>text</b> contains the Terms of service</li>
    			    </ol>
    			    <p>It could look like this:</p>
    			    <div style="border: 2px solid #000;" class="text-center">
                        <p class="text-center"><b>CAF-Feed ToS</b></p>
    			        <textarea rows="5" cols="60" id="tos1" readonly="readonly">By reading this you agree to the terms of service</textarea>
    			        <span><button class="btn btn-success">Accept</button> <button class="btn btn-danger">Decline</button></span>
    			    </div>
    			</td>
			</tr>
		</table>
		
		<h3 id="1.2.2">1.2.2 Invisible Modules</h3>
		<h4>GPS-Module</h4>
		<p>The GPS module will take the users current longitude and latitude.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicGPSJsonCodeSnippet();?></pre></td>
    			<td>
    			    <p>The GPS-Module has no indicators inside the sheet</p>
    			</td>
			</tr>
		</table>
		
		<h4>Accelerometer-Module</h4>
		<p>The Accelerometer module will be "tracking" the users movement, e.g. is he standing,walking or traveling at higher speeds</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicAccelJsonCodeSnippet();?></pre></td>
    			<td>
    			    <p>The Accelerometer-Module has no indicators inside the sheet</p>
    			</td>
			</tr>
		</table>
		<h4>Automatic-Date-Module</h4>
		<p>The automatic data module will automatically select the current date of the user in UTC-0 time.</p>
		<table class="table">
			<tr>
				<th class="text-center">JSON-Response</th>
				<th class="text-center">Meaning</th>
			</tr>
    		<tr>
    			<td><pre><?php basicAutoDateJsonCodeSnippet();?></pre></td>
    			<td>
    			    <p>The Automatic-Date-Module has no indicators inside the sheet</p>
    			</td>
			</tr>
		</table>
		
		
	</div>  <!-- end rest info -->
</div>
</div>
<?php
}
}




function basicJSONCodeSnippet()
{
echo '{
  "title": "This is some feedback",
  "id": 3,
  "submitbuttononpage": 1,
  "pages": [
    {
      "title": "Page 1",
      "elements": []
    }
  ]
}';
}


function basicListJSONCodeSnippet()
{
echo '{
  "type": "list",
  "id": "list1",
  "text": "Pick one of the following",
  "elements": [
    "good",
    "medium",
    "bad"
  ]
}';
}

function basicLongListJSONCodeSnippet()
{
echo '{
  "type": "long-list",
  "id": "long-list1",
  "text": "Pick one of the following",
  "elements": [
    "best",
    "better",
    "good",
    "medium",
    "bad",
    "worse",
    "worst"
  ]
}';
}

function basicTextfieldJsonCodeSnippet()
{
echo '{
  "type": "textfield",
  "id": "textfield1",
  "length": "160",
  "text": "Add any additonal comments"
}';
}

function basicTextareaJsonCodeSnippet()
{
echo '{
  "type": "textarea",
  "id": "textarea1",
  "length": "160",
  "text": "Add any additonal comments"
}';
}

function basicSwitchJsonCodeSnippet()
{
    echo '{
  "type": "checkbox",
  "id": "checkbox1",
  "text": "Do you like flowers?"
}';
}
function basicSliderJsonCodeSnippet()
{
    echo '{
  "type": "slider",
  "id": "slider1",
  "text": "How much do you like flowers?",
  "min": "0.0",
  "max": "2.0",
  "step":"0.25"
}';
}

function basicDateJsonCodeSnippet()
{
    echo '{
  "type": "date",
  "id": "date1",
  "text": "Please select your birthday"
}';
}

function basicStarRatingJsonCodeSnippet()
{
    echo '{
  "type": "star",
  "id": "star1",
  "text": "Please select your birthday"
}';
}



function basicPhotoJsonCodeSnippet()
{
    echo '{
  "type": "photo",
  "id": "photo1",
  "text": "Take a photo of your smile"
}';
}

function basicGPSJsonCodeSnippet()
{
    echo '{
  "type": "gps",
  "id": "gps1"
}';
}
function basicAccelJsonCodeSnippet()
{
    echo '{
  "type": "accelerometer",
  "id": "accelerometer1"
}';
}
function basicAutoDateJsonCodeSnippet()
{
    echo '{
  "type": "auto-date",
  "id": "auto-date1"
}';
}
function basicTOSJsonCodeSnippet()
{
    echo '{
  "type": "tos",
  "id": "tos1",
  "title":"CAF-Feed ToS",
  "text": "By reading this you agree<br>&#09;to the terms of service",
}';
}


?>