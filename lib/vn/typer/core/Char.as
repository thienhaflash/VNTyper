package vn.typer.core 
{
	public class Char {
		protected static var dict	: Object; /* dictionary of all characters, points from the character (a)--> Char instance of (a) */
		
		protected var _isVowel	: Boolean;
		protected var _isUpcase	: Boolean;
		protected var data		: String; /* data that this character based on by format Bb for consonant, AÁÀẢÃẠaáàảãạ for vowel */
		
		
		/** NOTES
			.: Consonants : Bb,Cc,Dd,Đđ,Gg,Hh,Kk,Ll,Mm,Nn,Pp,Qq,Rr,Ss,Tt,Vv,Xx
			.: Vowels	  : AÁÀẢÃẠaáàảãạ,ÂẤẦẨẪẬâấầẩẫậ,ĂẮẰẲẴẶăắằẳẵặ,EÉÈẼẸẺeéèẻẽẹ,ÊẾỀỂỄỆêếềểễệ,IÍÌỈĨỊiíìỉĩị,OÓÒỎÕỌoóòỏõọ,ÔỐỒỔỖỘôốồổỗộ,ƠỚỜỞỠỢơớờởỡợ,UÚÙỦŨỤuúùủũụ,ƯỨỪỬỮỰưứừửữự,YÝỲỶỸỴyýỳỷỹỵ
			.: Base		  : B,C,D,Đ,G,H,K,L,M,N,P,Q,R,S,T,V,X	A,Ă,Â,E,Ê,O,Ô,Ơ,I,U,Ư,Y
			.: ORIGIN	  : AEOIUY
		 */
		
		public function Char(v: Boolean, u: Boolean, d: String) {
			_isVowel = v;
			_isUpcase = u;
			data = d;
		}
		
		/**
		 * get the character itself
		 */
		public function get char(): String {
			return (isUpcase) ? up : low;
		}
		
		/**
		 * get the base which is the capitalized, non-accent char of this char
		 */
		public function get base(): String {
			return data.charAt(0);
		}
		
		/**
		 * get the uppercase character of this char
		 */
		public function get up(): String {
			return null;
		}
		
		/**
		 * get the lowercase character of this char
		 */
		public function get low(): String {
			return null;
		}
		
		/**
		 * whether this character is uppercase (true) or lowercase (false)
		 */
		public function get isUpcase():Boolean { return _isUpcase; }
		
		/**
		 * whether is character is vowel (true) or consonant (false)
		 */
		public function get isVowel():Boolean { return _isVowel; }
		
		
	/************************
	 * 	STATIC UTILS
	 ***********************/
		
		public static function init(): void {
			var cons	: Array = 'Bb,Cc,Dd,Đđ,Gg,Hh,Kk,Ll,Mm,Nn,Pp,Qq,Rr,Ss,Tt,Vv,Xx'.split(',');
			var carets  : Array = [0, 6, 7, 0, 6, 0, 0, 6, 7, 0, 7, 0];
			var vows	: Array = 'AÁÀẢÃẠaáàảãạ,ÂẤẦẨẪẬâấầẩẫậ,ĂẮẰẲẴẶăắằẳẵặ,EÉÈẼẸẺeéèẻẽẹ,ÊẾỀỂỄỆêếềểễệ,IÍÌỈĨỊiíìỉĩị,OÓÒỎÕỌoóòỏõọ,ÔỐỒỔỖỘôốồổỗộ,ƠỚỜỞỠỢơớờởỡợ,UÚÙỦŨỤuúùủũụ,ƯỨỪỬỮỰưứừửữự,YÝỲỶỸỴyýỳỷỹỵ'.split(',');
			
			var i : int;
			var j : int;
			var l : int = cons.length;
			var d : String;
			
			dict = { };
			
			for (i = 0; i < l; i++) {
				d = cons[i];
				dict[d.charAt(0)] = new Consonant(true, d);
				dict[d.charAt(1)] = new Consonant(false, d);
			}
			
			l = vows.length;
			
			for (i = 0; i < l; i++) {
				d = vows[i];
				for (j = 0; j < 12; j++) {
					dict[d.charAt(j)] = new Vowel(j < 6, j % 6, carets[i], d);
				}
			}
		}
		
		/**
		 * get the Char instance of the passed by character (ch) - can be null if ch is not a valid character
		 */
		public static function get (ch: String): Char {
			if (!dict) init();
			return dict[ch];
		}
		
		/**
		 * get the Vowel instance of the passed by character (ch) - can be null if ch is not a valid vowel
		 */
		public static function getVowel (ch: String): Vowel {
			if (!dict) init();
			return dict[ch];
		}
		
		
		/**
		 * get the origin for a character if it's a vowel, the base if it's a consonant
		 * @param	s the source string
		 * @param	i the index
		 * @return
		 */
		public static function origin(s: String): String {
			var ch: Char = Char.get(s);
			if (ch && ch.isVowel) ch = Char.get(Vowel.getOrigin(ch.base));
			return ch ? ch.base : ' '; 
		}
		
		
	}

}