/**
* Visit http://etcs.ru for documentation, updates and more free code.
*/
package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ru.etcs.utils.FontLoader;

	[SWF(width="650", height="500", frameRate="31", backgroundColor="#FFFFFF")]
	/**
	 * FontLoader demo class
	 * 
	 * @author					etc
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 */
	public class FontLoaderDemo extends Sprite {
		public function FontLoaderDemo() {
			super();
			this._field.embedFonts = true;
			this._field.autoSize = TextFieldAutoSize.LEFT;
			this._field.rotation = 45;
			this._field.x = 150;
			this._field.y = 150;
			this._field.border = true;
			this._field.antiAliasType = AntiAliasType.ADVANCED;
			super.addChild(this._field);
			this._loader.addEventListener(Event.COMPLETE, this.handler_complete);
			this._loader.load(new URLRequest('fonts.swf'));
		}
		
		/**
		 * @private
		 */
		private const _loader:FontLoader = new FontLoader();
		
		/**
		 * @private
		 */
		private const _field:TextField = new TextField();
		
		/**
		 * @private
		 */
		private function handler_complete(event:Event):void {
			var fonts:Array = this._loader.fonts;
			
			for each (var font:Font in fonts) {
				var text:String = font.fontName;
				var tf:TextFormat = new TextFormat(font.fontName, 20);
				
				switch (font.fontStyle) {
					case FontStyle.BOLD:
						tf.bold = true;
						break;
					case FontStyle.BOLD_ITALIC:
						tf.bold = true;
						tf.italic = true;
						break;
					case FontStyle.ITALIC:
						tf.italic = true;
						break;
				}
				
				this._field.appendText(text+'\n');
				this._field.setTextFormat(tf, this._field.length-text.length-1, this._field.length);
			}
		}
	}
}
