package vn.typer.core
{
	/**
	 * Base class for all typing mode in VNTyper library
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 		
	 */ 
	public class TypeMode
	{
		public static var D9 : int = 59;//need to check existance of D
		public static var A6 : int = 60;//need to check existance of A
		public static var E6 : int = 61;//need to check existance of E
		public static var O6 : int = 62;//need to check existance of O
		
		public function TypeMode() 
		{
			// 0 - 5: key
			// ăươ :  7
			// â ê ô : 60-62
		}
		
		public static function check(key: int): String {
			var s : String = '';
			
			switch (key) {
				case D9 : s = 'D'; break;
				case A6 : s = 'A'; break;
				case E6 : s = 'E'; break;
				case O6 : s = 'O'; break;
			}
			return s;
		}
		
		public static function simplifyKey(key: int): int {
			var k : int;
			switch (key) {
				case D9 : k = 9; break;
				case A6 : 
				case E6 : 
				case O6 : k = 6; break;
			}
			return k;
		}
		
		public static function isAccent(i: int): Boolean {
			return i > -1 && i < 6;
		}
		
		public static function isCaret(i: int): Boolean {
			return (i == 7 || i == 6 || i == A6 || i == E6 || i == O6);
		}
		
		
		public function getHook(s: String): int { return -1; }
	}
}