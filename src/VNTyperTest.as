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
			
			VNTyper.initialize(stage)
					.mapToEncoder("Vni-Thuphap", new VniEncoder(), new VNINetbut_FontClass());
			
			var tf : TextField;
			
			//VNTyper enabled by default
			tf	=	newTextfield(0,	0	, 'Bảng mã Unicode')
			//VNTyper auto unicode to vni conversion
			tf	=	newTextfield(0, 50	, 'Bảng mã VNI');
			VNTyper.api.applyFont(tf, "Vni-Thuphap");
			//VNTyper ignore textfield
			tf	=	newTextfield(0,100	, 'Tắt bộ gõ')
			VNTyper.api.ignore(tf);
		}
		
		protected function newTextfield(px: Number = 0, py: Number = 0, txt: String = ''): TextField {
			var tf : TextField = new TextField();
			tf.border = true;
			tf.type = TextFieldType.INPUT;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = 549;
			tf.height = 50;
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