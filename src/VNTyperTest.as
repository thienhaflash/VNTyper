package  
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import vn.typer.VNTyper;
	/**
	 * ...
	 * @author thienhaflash
	 * 
	 */
	public class VNTyperTest extends MovieClip
	{
		public function VNTyperTest() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(newTextfield());
			addChild(newTextfield(0, 100));
			
			VNTyper.initialize(stage);
			//VNTyper.initialize(getChildAt(1));
			//trace(VNTyper.info);
		}
		
		protected function newTextfield(px: Number = 0, py: Number = 0): TextField {
			var tf : TextField = new TextField();
			tf.border = true;
			tf.type = TextFieldType.INPUT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = 500;
			tf.defaultTextFormat = new TextFormat(null, 20);
			tf.name = 'textfield-' + numChildren;
			tf.x = px;
			tf.y = py;
			tf.text = '';
			return tf;
		}
	}

}