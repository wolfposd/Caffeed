<?php


/**
 * Interface for modules
 */
class long_list implements IModule
{
    private $values;
    private $id;

    function __construct(array $values, $id)
    {
        $this->values = $values;
        $this->id = $id;
    }

    /**
     * Returns Javascript code
     */
    public function javascript()
    {
        return "";
    }

    /**
     * Echos the HTML code
     */
    public function html()
    {
?>
    <div class="text-center">
        <p class="text-center">Pick one of the following</p>
        <div style="overflow: scroll; height: 140px;">
        <?php $i = 0; 
            foreach($this->values["elements"] as $value) 
            {
            ?>
            <p><button type="button" class="btn-primary btn-sm" style="width:100px;" name="<?php echo $this->id.",".$i;?>" id="<?php echo $this->id.",".$i;?>"><?php echo $value?></button></p>
        <?php 
                $i++;
            }
        ?>
        </div>
    </div>
<?php 
    }
    
    function editorhtml()
    {
        include_once 'views/modules/basiceditor.php';
        
        echo basiceditor("Long List Module","longlistmodule", 
    '<p>Elements: (seperated by &lt;newline&gt;)</p><textarea rows="5" cols="40" name="module_XXXX_elements"></textarea>');
     }

}

?>