package  
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import vn.typer.encode.VniEncoder;
	import vn.typer.mode.TelexMode;
	import vn.typer.mode.VniMode;
	import vn.typer.utils.initVNTyper;
	import vn.typer.utils.initVNTyper2;
	import vn.typer.VNTyper;
	/**
	 * Simple VNTyper Test
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 
	 */
	public class VNTyperTest extends MovieClip
	{
		public function VNTyperTest() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initVNTyper2(this);
			newTextfield(0,	0	, 'Bảng mã Unicode');
		}
		
		protected function newTextfield(px: Number = 0, py: Number = 0, txt: String = ''): TextField {
			var tf : TextField = new TextField();
			tf.border = true;
			tf.type = TextFieldType.INPUT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = 549;
			tf.height = 150;
			tf.defaultTextFormat = new TextFormat(null, 20);
			tf.name = 'textfield-' + numChildren;
			tf.x = px;
			tf.y = py;
			tf.text = txt;
			addChild(tf);
			return tf;
		}
	}

}