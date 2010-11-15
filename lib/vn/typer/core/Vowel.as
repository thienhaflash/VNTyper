package vn.typer.core 
{
	public class Vowel extends Char {
		protected var _accent	: int; /* 0..5 */
		protected var _caret	: int; /* 0,6,7 */
		
		public function Vowel(_up: Boolean, _a: int, _c: int, _ul: String) {
			super(true, _up, _ul);
			_accent = _a;
			_caret = _c;
		}
		
		
	/***********************
	 * 		GETTERS
	 **********************/
		
		/**
		 * @inheritDoc
		 */
		override public function get up():String {
			return data.charAt(accent); 
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get low():String {
			return data.charAt(accent + 6);
		}
		
		/**
		 * get the accent of this character 0 : no accent, 12345 : the 5 accents /\?~.
		 */
		public function get accent():int { return _accent; }
		
		/**
		 * get the caret of this character 0 : no caret, 67 = ^)
		 */
		public function get caret():int { return _caret; }
		
	/***********************
	 * 		GET CHARS
	 **********************/
		
		/**
		 * get the character that is the same base/caps style with this character + specified accent
		 * @param	a the accent - 0 : remove accent , 12345 : the 5 accents /\?~.
		 * @return
		 */
		public function putAccent(a: int): String {
			return data.charAt(_isUpcase ? a : a + 6);
		}
		
		/**
		 * get the character that is the same base/caps style with this character + specified caret 
		 * @param	c the caret 67 = ^) 
		 * @return if the caret can not be put (e.g. no ^ for i), it returns the character itself
		 */
		public function putCaret(c: int): String {
			var chr : String = getOrigin(data.charAt(_isUpcase ? 0 : 6));//remove the accent + caret
			var s : String = (c == 0) ? chr : caretObj[chr + c];
			return (_accent > 0) ? Char.getVowel(s).putAccent(_accent) : s;
		}
		
		/**
		 * get the _origin (without caret nor accents) of the passed by character (ch) 
		 * @param	b
		 * @return the 
		 */
		public static function getOrigin(ch: String): String {
			if (!_origin) init();
			//trace(ch, '-->', Char.getVowel(ch).origin);
			return Char.getVowel(ch).origin;
		}
		
		public function get origin(): String {//remove accent before get _origin
			if (!_origin) init();
			var chr : String = _accent > 0 ? putAccent(0) : char;
			var o: String = _origin[chr];
			return o ? o : chr;
		}

		/**
		 * get the Vowel instance for the specified character
		 * @param	s the character
		 * @return can be null if s is not a valid character or s is not a Vowel
		 */
		//public static function get(s: String): Vowel {
			//return Char.get(s) as Vowel;
		//}
		
		private static var _origin	: Object;
		private static var caretObj	: Object;
		
		private static function init(): void {
			_origin = { };
			caretObj = {}
			var base : String = 'ăâĂÂêÊôÔơƠưƯ';
			var org	 : String = 'aaAAeEoOoOuU';
			var car	 : String = '767666667777';
			
			var l : int = base.length;
			
			for (var i: int = 0; i < l; i++) {
				_origin[base.charAt(i)] = org.charAt(i);
				caretObj[org.charAt(i) + car.charAt(i)] = base.charAt(i);
			}
			
		}
	}
}