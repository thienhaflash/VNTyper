package vn.typer.core 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import vn.typer.data.Word;
	
	/**
	 * VNTyper library core
	 * 
	 * Process user input on a textfield using 1 encoder and 1 input method
	 * This class use one instance of Word to add/remove caret, accents
	 * and update the textfield when needed
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 		
	 */ 
	
	public class VNTyperCore 
	{
		public function VNTyperCore() 
		{
			word = new Word();
		}
		
	/******************
	 * 		APIs
	 *****************/
		
		protected var typeMode	: TypeMode;
		protected var encoder	: Encoder;
		protected var textfield	: TextField;
		
		public function setMode(mode: TypeMode): VNTyperCore { typeMode = mode; return this; }
		public function setEncoder(pencoder: Encoder): VNTyperCore { encoder = pencoder; return this; }
		public function toUnicode(s: String): String { return encoder ? encoder.toUnicode(s) : s; }
		public function fromUnicode(s: String): String { return encoder ? encoder.fromUnicode(s) : s; }
		
		public function startMonitor(tf: TextField): VNTyperCore {
			stopMonitor(); //stop monitor old textfield
			textfield = tf;
			if (tf != null) {
				tf.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				tf.addEventListener(Event.CHANGE, 			onInput);
			}
			return this;
		}
		
		public function stopMonitor(): VNTyperCore {
			if (textfield != null) {
				textfield.removeEventListener(KeyboardEvent.KEY_DOWN,	onKeyDown);
				textfield.removeEventListener(Event.CHANGE,				onInput);
			}
			textfield = null;
			return this;
		}
		
	/***********************
	 * 	WORD MANIPULATIONS
	 **********************/
		
		protected var word		: Word; /* current processing word */
		protected var sIndex	: int; /* start index of the current word in the textfield */
		protected var eIndex	: int; /* end index of the current word in the textfield */
		protected var seps		: String = '`~!@#$%^&*()-_=+{}|\][:;"\',./<>? '; /* word separators - use to determine word boundary */
		
		/**
		 * find the word at caret position, word boundary detects using seps (word separators)
		 */
		protected function getWord(tf: TextField): String {
			var first	: int = tf.getFirstCharInParagraph(tf.caretIndex);
			var txt		: String = tf.text.substr(first, tf.getParagraphLength(tf.caretIndex));
			var pr		: int = 1; /* number of character prev to caret that is valid */
			var nx		: int = 0; /* number of character next to caret that is valid */
			var caret	: int = tf.caretIndex;
			var c		: String;
			var s		: String = '';
			
			while (caret - pr >= 0) {
				c = txt.charAt(caret -first - pr);
				if (seps.indexOf(c) != -1) break;
				pr++;
				s = c + s;
			}
			
			while (caret + nx <= txt.length) {
				c = txt.charAt(caret -first +nx);
				if (seps.indexOf(c) != -1) break;
				nx++;
				s = s + c;
			}
			
			sIndex = caret - pr;
			eIndex = caret + nx;
			
			return toUnicode(s);
		}
		
		protected function resetWord(): void {
			if (!textfield) return;
			if (sIndex < textfield.caretIndex && textfield.caretIndex <= eIndex) return;
			word.setSource(getWord(textfield), textfield.caretIndex - 1 - sIndex);
			//trace('reset word :[' + word.toString + ']');
		}
		
	/**************************
	 * 	INTERACTION HANDLERS
	 *************************/
		
		protected var hooked	: Boolean; /* is the suspected accent/caret key pressed is really effective */
		protected var caret		: int; /* we need to restore caret position when accent/caret keys is effective */
		protected var delta		: int;
		
		protected function onKeyDown(e: KeyboardEvent): void {
			resetWord();//(keycode > 32 && keycode < 41) || (keycode == 46) || (keycode == 48);
			hooked = false;
			
			if (sIndex < textfield.caretIndex - 1) {//can be hooked only if the first char is before the caret
				var cWord : String = fromUnicode(word.toString);
				
				var key		: String = String.fromCharCode(e.charCode);
				var hkey	: int = typeMode.getHook(key);				
				if (hkey != -1) hooked = word.putKey(hkey, textfield.caretIndex-1-sIndex);
				if (hooked) {
					caret = textfield.caretIndex;
					delta = fromUnicode(word.toString).length - cWord.length;
					eIndex = cWord.length + sIndex + 1;
				}
			}
		}
		
		protected function onInput(e:Event):void 
		{
			var idx : int;
			
			if (!hooked) {
				idx = textfield.caretIndex;
				var cWord : String = fromUnicode(word.toString);
				
				//word.source = getWord(textfield);
				word.setSource(getWord(textfield), idx - 1 - sIndex);
				delta = fromUnicode(word.toString).length - cWord.length - 1;/* ignore the last key */
				//trace(cWord,'===>', fromUnicode(word.toString));
				textfield.setSelection(sIndex + 1, eIndex);
			} else {
				textfield.setSelection(sIndex + 1, eIndex + 1);//include the last typed character
				eIndex = sIndex + 1 + fromUnicode(word.toString).length;//start index is always +1
				idx = caret;
			}
			
			if (delta < 0) delta = 0;
			textfield.replaceSelectedText(fromUnicode(word.toString));
			textfield.setSelection(delta + idx, delta + idx);
		}
	}
}