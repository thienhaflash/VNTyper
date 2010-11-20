package  
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import vn.typer.encode.VniEncoder;
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
			var tf : TextField = newTextfield(0, 100);
			addChild(tf);
			tf.text = "đó là một buổi chiều mùa hạ";
			
			VNTyper.initialize(stage)
					.addFont("Vni-Thuphap", new VNINetbut_FontClass(), new VniEncoder());
					
			VNTyper.instance.applyFont(tf, "Vni-Thuphap");
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