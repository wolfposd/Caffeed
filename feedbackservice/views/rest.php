<?php

/**
 * This is the basic Template for controller-classes
 */
class Rest
{
	private $mysqli;

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;
	}
	function __destruct()
	{
	}

	function display()
	{
		echo show();
	}


}


function show()
{
	?>
<div class="row">
	<div class="col-md-3">
		<img src="img/rest-area.png" width="256" height="256">
	</div>
	<div class="col-md-6">
		<h1 class="page-header">Guide to using the REST-API</h1>
		<p>In the future you will be able to find information here about accessing the provided functions of this service via a REST-API.</p>
		<p>The base URL for every REST-Request is "<b>http://beeqn.informatik.uni-hamburg.de/feedback/rest.php/</b>" .</p>
	</div>
</div>
<div class="row">
	<div class="col-md-offset-3 col-md-6">
		<h2>1. Getting a question-sheet</h2>
		<p>To get the necessary data for displaying a question-sheet you will need to issue a <b>GET</b>-Request with the following parameters:</p>
		<ol>
		<li>sheet</li>
		<li>id</li>
		<li>&lt;id&gt;</li>
		</ol>
		<p>Like so: http://beeqn.informatik.uni-hamburg.de/feedback/rest.php/sheet/id/3</p>
		<h3>1.1 Answer content</h3>
	</div>
</div>
<?php
}

?>