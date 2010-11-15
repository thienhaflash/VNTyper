package vn.typer.core 
{
	import flash.utils.Dictionary;
	
	public class Word
	{
		public var isVN		: Boolean; /* is this word VN or not */
		
		public var firstC	: String; /* first consonant */
		public var vowel	: String; /* middle vowel */
		public var caret	: int; /* 067 = ^*( */
		public var accent	: int; /* 012345 =  /\?~. */
		public var lastC	: String; /* last consonant */
		public var remain	: String; /* the rest */
		
		protected var _source	: String; /* the source of the word - the original / joint string */
		protected var _dirty	: Boolean; /* is the source syned with firstC, vowel, caret, accent, lastC, remain */
		
		public function Word() 
		{
			_source = "";
		}
		
		public function putKey(key: int): Boolean {//0-7
			if (!_source || _source == '' || key < 0 || remain != '') return false; //invalid key
			
			//what if it's currently dirty ? - there will never be this case !
			//TODO : double accent keys should be return (?)
			
			var chk : String = TypeMode.check(key);
			
			if (chk != '') {
				if (key == TypeMode.D9 && toCase(firstC) == 'D') {//the special D case
					//trace(firstC);
					firstC = (firstC == 'D') ? 'Đ' : 'đ'; _dirty = true;
					return true;
				} else if (toCase(vowel).indexOf(chk) != -1) {//check if key need existance of vowel (AA=A6, OO=O6, EE=E6)
					key = TypeMode.simplifyKey(key);
				} else {
					return false; //key is invalid : required Vowel not existed
				}
			} else {
				//trace('no vowel');
				if (!vowel || vowel == '') return false; //no vowel : can't put key
			}
			
			if (key == 0) {//delete accent first, then delete caret
				if (accent != 0) {
					accent = 0; _dirty = true;
				} else if (caret != 0) {
					caret = 0; _dirty = true;
				} else {//invalid key 0 ----> return to english ?
					return false;
				}
			} else if (key == accent || key == caret) {
				//TODO :: duplicated accent ---> return to english ?
				return false;
			} else if (key < 6) {//of course key is now different from accent, and is accent
				accent = key; _dirty = true;
			} else {//the only rest case : key is caret && != current caret
				if (vowel == 'i' || vowel == 'I' || vowel == 'y' || vowel == 'Y' || (key == 7 && (vowel == 'e' || vowel == "E"))) {// //caret not possible for i, y, and not for e7
					//bugfixed :: there is cases when caret == 7 && vowel == "e"
					return false;
				} else {
					caret = key; _dirty = true;
				}
			}
			
			return true;
		}
		
		public function get toString():String {
			if (_dirty) combine();
			return _source;
		}
		
		public function set source(value:String):void 
		{
			_source = value;
			
			var s : String = _source;
			s = getFirstC(s);
			s = getVowelCaretAccent(s);
			remain = getLastC(s);
			_dirty = true; /* most of the time, it's false but there can be cases when caret need to be move automatically, add */
			//trace('parsed :: ', _source, '--->', firstC, vowel, lastC, caret, accent); 
		}
		
	/***********************
	 * 		INTERNAL
	 **********************/
		
		private function getCharOrigin(s:String, idx: int): String {
			return Char.origin(s.charAt(idx));
		}
		
		/**
		 * get first consonant characters
		 */
		private function getFirstC(s: String): String {
			firstC = '';
			var sl 		: int = s.length;
			if (sl == 0) return '';
			
			var l		: int;
			var char0	: String = getCharOrigin(s, 0);
			var char1	: String = sl>1 ? getCharOrigin(s, 1) : ' ';
			
			switch (char0) {
				case 'B' :
				case 'D' :
				case 'Đ' :
				case 'H' :
				case 'L' :
				case 'M' :
				case 'R' :
				case 'S' :
				case 'V' :
				case 'X' : l = 1;  break;/* single consonants */	
				case 'C' : /* CH or C */
				case 'K' : /* KH or K */
				case 'P' : l = (char1 == 'H') ? 2 : 1; break; /* PH or P */
				case 'G' : 
						/*	The special case with GI
							GI = G (firstC) + I(vowel) only when s.length==2 or charAt(2) is consonant (l = 1)
							Other case GI is considered a consonant (l = 2)
						*/
							if (char1 == 'I') {
								l = 1;
								if (sl > 2) {
									var c : Char = Char.get(getCharOrigin(s, 2));
									if (c.isVowel) {//gi is now consonant
										var v 	: Vowel = Char.getVowel(s.charAt(1));//char i
										if (v.accent > 0) {//transfer existed accent to next vowel
											var tmps : String = v.putAccent(0) + Char.getVowel(s.charAt(2)).putAccent(v.accent);
											s = s.charAt(0) + tmps + s.substr(3);
										}
										l = 2;
									}
								}
							} else {
								l = (char1 == 'H') ? 2 : 1;	
							}
					break;/* GI or GH or G */
				case 'N' : l = (char1 == 'G') ? (getCharOrigin(s, 2) == 'H') ? 3 : 2 : (char1 == 'H') ? 2 : 1; break; /* NGH or NG */ /* NH or N */
				case 'T' : l = (char1 == 'H' || char1=='R') ? 2 : 1; break;/* TH TR or T */
				case 'Q' : l = (char1 == 'U') ? 2 : 1; break;
			}
			
			firstC = s.substring(0, l);
			return s.substring(l);
		}
		
		/**
		 * get the vowel, caret, accent
		 */
		private function getVowelCaretAccent(s: String): String {
			vowel = '';
			accent = 0;
			caret = 0;
				
			var sl 		: int = s.length;
			if (sl == 0) return '';
			
			var l		: int;
			var char0	: String = getCharOrigin(s, 0);
			var char1	: String = sl>1 ? getCharOrigin(s, 1) : ' ';
			var char2	: String = sl > 2 ? getCharOrigin(s, 2) : ' ';
			
			switch (char0) {
				case 'A' : l = ('IOUY'.indexOf(char1) != -1 ) ? 2 : 1; break;
				case 'E' : l = ('OU'.indexOf(char1) != -1) ? 2 : 1; break;
				case 'I' : l = (char1 == 'E') ? (char2 == 'U') ? 3 : 2 : (char1 == 'A' || char1 == 'U') ? 2 : 1; break;
				case 'O' : l = (char1 == 'A') ? (char2 == 'I') ? 3 : 2 : (char1 == 'I' || char1 == 'E') ? 2 : 1; break;
				case 'U' : l =  (char1 == 'A') ? (char2 == 'Y') ? 3 : 2 : 
								(char1 == 'Y') ? (char2 == 'E' || char2 == 'U') ? 3 : 2 : 
								(char1 == 'O') ? (char2 == 'I' || char2=='U') ? 3 : 2 :
								('EIU'.indexOf(char1) != -1) ? 2 : 1; break;
				case 'Y' : l = (char1 == 'E') ? (char2 == 'U') ? 3 : 2 : 1; break;
			}
			
			var vs : String = s.substring(0, l); /* vowel string */
			var v  : Vowel;
			s = s.substring(l, s.length);
			
			/*  There will never be a conflict in caret or accent because there will be maximum 1 caret + 1 accent for a word 
				So we just need to grasp the first caret/accent we found
			*/
			for (var i: int = 0; i < l; i++) {
				v = Char.getVowel(vs.charAt(i));
				if (caret == 0 && v.caret != 0) caret = v.caret;
				if (accent == 0 && v.accent != 0) accent = v.accent;
				
				vowel += v.origin;
			}
			return s;
		}
		
		private function getLastC(s: String): String {
			lastC = '';
			var sl 		: int = s.length;
			if (sl == 0) return '';
			
			var l		: int;
			var char0	: String = getCharOrigin(s, 0);
			var char1	: String = sl>1 ? getCharOrigin(s, 1) : ' ';
			
			switch (char0) {
				case 'M' :
				case 'P' : 
				case 'T' : l = 1; break;
				case 'C' : l = (char1 == 'H') ? 2 : 1; break;/* CH or C */
				case 'N' : l = (char1 == 'H' || char1 == 'G') ? 2 : 1; break;/* NH NG or N */
			}
			
			lastC = s.substring(0, l);
			return s.substring(l);
		}
		
		private static var accentPos : Object;
		
		private static function initAccentPos(): void {
			if (accentPos) return;
			
			var second: Array = 'IE,UE,UO,UOU,IEU,OAI,UAY,UOI,UYU,UYA,YE,YEU'.split(','); /* YE is not vowel, but it is part of YEU */
			var third : String = 'UYE';
			var depend: Array = 'OA,UA,UY'.split(',');
			
			var l: int = second.length;
			accentPos = { };
			
			for (var i: int = 0; i < l; i++) {
				accentPos[second[i]] = 1;
			}
			
			accentPos['UYE'] = 2;
			
			i = depend.length;
			for (i = 0; i < l; i++) {
				accentPos[depend[i]] = -1;
			}
		}
		
		private function combine(): void {
			if (!accentPos) initAccentPos();
			
			//trace('trying to combine :: ', firstC, vowel, lastC, remain, caret, accent);
			var mid : String = '';
			if (vowel && vowel.length > 0) {//TODO : think if this check redundant
				var up	: String = toCase(vowel);
				var p	: int = accentPos[up]; //auto convert to 0 if accentPos[v]==null
				
				/* for depend case */
				if (p == -1) p = (caret==6 || lastC != '') ? 1 : 0;//caret 6 can only put onto 2nd for UA, OA
				
				mid = vowel.substr(0, p); //temporary string
				var v : Vowel = Char.getVowel(vowel.charAt(p));
				if (caret > 0) {//has caret to put
					if (caret == 7 && up.charAt(0) == 'U' && up.charAt(1) == 'O' && (lastC != '' || up.charAt(2) == 'I' || up.charAt(2)=='U')) {/* special case :: dual caret */
						mid = up.charAt(0) == vowel.charAt(0) ? 'Ư' : 'ư';
						v = Char.getVowel(v.isUpcase ? 'Ơ' : 'ơ');
					} else {
						v = Char.getVowel(v.putCaret(caret));//put the caret in
					}
				}
				if (accent > 0) v = Char.getVowel(v.putAccent(accent));//put accent in
				mid += v.char + vowel.substr(p+1);
			}
			
			_source = firstC + mid + lastC + remain;//recombine	
			_dirty = false;
		}
		
	/***************************
	 * 		STATIC
	 **************************/
		
		/**
		 * convert a string into lower/uppercase
		 * @param	s
		 * @param	isUpper
		 * @return
		 */
		public static function toCase(s: String, isUpper: Boolean = true): String {
			var l : int = s.length;
			var tmp : String = '';
			var cs	: String;
			var ch 	: Char; 
			
			for (var i: int = 0; i < l; i++) {
				cs = s.charAt(i);
				ch = Char.get(cs);
				tmp += ch ? isUpper ? ch.up : ch.low : cs;
			}
			
			return tmp;
		}
	}
}