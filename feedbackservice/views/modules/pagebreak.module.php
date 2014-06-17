<?php



class pagebreak implements IModule
{
    private $values;
    private $id;
    
    function __construct(array $values, $id)
    {    
        $this->values = $values;
        $this->id = $id;
    }

    public function javascript()
    {
        return false;
    }

    public function html()
    {
        ?>
        <div class="text-center">
	        <p/>
		    <p><?php echo $this->values["text"]?> <input type="checkbox" name="<?php echo $this->id?>"><p>
	    </div>
        <?php 
    }
    
    function editorhtml()
    {
        ?>
            <div class="row" id="div_module_XXXX">
                <h4>
                    <font color="red">--------------------------- Pagebreak ---------------------------</font>
                    <button type="button" class="btn btn-danger" onclick="$('#div_module_XXXX').remove(); return false;">X</button>
                </h4>
                <input type="hidden" name="module_XXXX_type" value="pagebreak">
            </div>
        <?php 
    }
}


?>