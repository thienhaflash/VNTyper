package vn.typer.core 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class VNTyperCore 
	{
		protected var typeMode	: TypeMode;
		protected var encoder	: Encoder;
		
		protected var textfield	: TextField;		
		protected var word		: Word;
		
		protected var sIndex	: int;
		protected var eIndex	: int;
		
		public function VNTyperCore() 
		{
			word = new Word();
		}
		
		/**
		 * change typing method - TelexMode, TelexVniMode, VniMode
		 * @param by default it's using TelexVniMode
		 */
		public function setMode(mode: TypeMode): VNTyperCore {
			typeMode = mode;
			return this;
		}
		
		/**
		 * change typing method - TelexMode, TelexVniMode, VniMode
		 * @param by default it's using TelexVniMode
		 */
		public function setEncoder(pencoder: Encoder): VNTyperCore {
			encoder = pencoder;
			return this;
		}
		
		public function startMonitor(tf: TextField): VNTyperCore {
			if (textfield != null) {
				textfield.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				textfield.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				textfield.addEventListener(Event.CHANGE, onInput);
			}
			if (tf != null) {
				textfield = tf;
				tf.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				tf.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				tf.addEventListener(Event.CHANGE, onInput);
			}
			return this;
		}
		
		private function getWord(tf: TextField): String {
			var first	: int = tf.getFirstCharInParagraph(tf.caretIndex);
			var txt		: String = tf.text.substr(first, tf.getParagraphLength(tf.caretIndex));
			var pr		: int = 1; /* number of character prev to caret that is valid */
			var nx		: int = 0; /* number of character next to caret that is valid */
			var caret	: int = tf.caretIndex;
			var c		: String;
			var s		: String = '';
			
			while (caret - pr >= 0) {
				c = txt.charAt(caret -first - pr);
				if (isValidChar(c)) {
					pr++;
					s = c + s;
				} else {
					break;
				}
			}
			
			while (caret + nx <= txt.length) {
				c = txt.charAt(caret -first +nx);
				if (isValidChar(c)) {
					nx++;
					s = s + c;
				} else {
					break;
				}
			}
			
			sIndex = caret - pr;
			eIndex = caret + nx;
			
			return toUnicode(s);
		}
		
		private function isValidChar(s: String): Boolean {
			return '`~!@#$%^&*()-_=+{}|\][:;"\',./<>? '.indexOf(s) == -1;
		}
		
		private function onMouse(e:MouseEvent):void 
		{
			moved = true;
		}
		
		protected var rendered				: Boolean = true; /* check if the text is udpated or not */
		protected var hooked				: Boolean; /* is the suspected accent/caret key pressed is really effective */
		protected var moved					: Boolean; /* check if we move by mouse/arrows - refresh the word */
		protected var savedCaret			: int; /* we need to restore caret position when accent/caret keys is effective */
		protected var delta					: int;
		
		private function onKeyDown(e: KeyboardEvent): void {
		
			switch (e.keyCode) {
				case 37 : 
				case 38 : 
				case 39 : 
				case 40 : 
				case 46	: 
				case 8	: moved = true; break;
			}
			
			if (moved) {
				word.source = getWord(textfield);
				moved = false;
			}
			
			rendered = false;
			hooked = false;
			//can be hooked only if the first vowel is before the caret
			if (sIndex < textfield.caretIndex - 1) {
				/**
				 * this solves the case when we need to type a new word that start with a posibly accent 
				 * key(x,r,s) right before an existed word that can get that key as accent - 
				 * like trying to type "xa" right before a word that can get x as an accent like "lang"
				 */
				var cWord : String = fromUnicode(word.toString);
				
				var key		: String = String.fromCharCode(e.charCode);
				var hkey	: int = typeMode.getHook(key);				
				if (hkey != -1) hooked = word.putKey(hkey);
				if (hooked) {
					savedCaret = textfield.caretIndex;
					delta = fromUnicode(word.toString).length - cWord.length;
					eIndex = cWord.length + sIndex + 1;
				}
			}
		}
		
		private function toUnicode(s: String): String {
			return encoder ? encoder.toUnicode(s) : s;
		}
		
		private function fromUnicode(s: String): String {
			return encoder ? encoder.fromUnicode(s) : s;
		}
		
		private function onInput(e:Event):void 
		{
			rendered = true;
			var idx : int;
			
			if (!hooked) {
				idx = textfield.caretIndex;
				var cWord : String = fromUnicode(word.toString);
				
				word.source = getWord(textfield);
				delta = fromUnicode(word.toString).length - cWord.length - 1;/* ignore the last key */
				
				//trace(cWord,'===>', fromUnicode(word.toString));
				textfield.setSelection(sIndex + 1, eIndex);
			} else {
				textfield.setSelection(sIndex + 1, eIndex + 1);//include the last typed character
				eIndex = sIndex + 1 + fromUnicode(word.toString).length;//start index is always +1
				idx = savedCaret;
			}
			
			if (delta < 0) delta = 0;
			textfield.replaceSelectedText(fromUnicode(word.toString));
			textfield.setSelection(delta + idx, delta + idx);
			//trace(hooked, delta, textfield.caretIndex);
		}
	}
}