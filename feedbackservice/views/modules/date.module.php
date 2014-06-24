<?php



class date extends AbstractModule
{
    
    public function javascript()
    {
        return '$("#'.$this->id.'").datepicker({format:"dd.mm.yyyy"});';
    }

    public function html()
    {
        ?>
        <div class="text-center">
            <p></p>
    	    <p><?php echo $this->values["text"]?><p>
    	    <input type="text" class="span2 text-center" value="<?php echo date("d.m.Y");?>" name="<?php echo $this->id?>" id="<?php echo $this->id?>">
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