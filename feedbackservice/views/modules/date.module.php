<?php



class date extends AbstractModule
{
    
    public function javascript()
    {
        return 'var dp'.$this->id.'= $("#'.$this->id.'").datepicker({format:"dd.mm.yyyy",weekStart:1}).on("changeDate", function(ev) { dp'.$this->id.'.hide(); }).data("datepicker");';
    }

    public function html()
    {
        ?>
        <div class="text-center">
            <p></p>
    	    <p><?php echo $this->values["text"]?><p>
    	    <input type="text" class="span2 text-center" value="<?php echo date("d.m.Y");?>" name="<?php echo $this->id?>" id="<?php echo $this->id?>" readonly="true">
        </div>
        <?php 
    }
    
    public function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        echo basiceditor("Date Module","datemodule");
    }
}


?>