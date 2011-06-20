package vn.typer.mode
{
	import vn.typer.core.TypeMode;
	/**
	 * Telex Typing Mode adds telex input method support for VNTyper
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 
	 */ 
	public class TelexMode extends TypeMode
	{
		override public function getHook(s:String):int 
		{
			s = s.toUpperCase();
			
			var i : int = 'ZSFRXJ'.indexOf(s);
			if (i != -1) return i;
			
			switch (s) {
				case 'O' : i = TypeMode.O6; break; /* special keys */
				case 'E' : i = TypeMode.E6; break;
				case 'A' : i = TypeMode.A6; break;
				case 'W' : i = 7; break;
				case 'D' : i = TypeMode.D9; break;
			}
			return i;
		}
		
		private static var _instance : TelexMode;
		public static function get instance() : TelexMode { return _instance ||= new TelexMode(); }
		public static function get id(): String { return 'telex' };
	}

}