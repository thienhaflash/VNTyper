package vn.typer.mode 
{
	import vn.typer.core.TypeMode;
	/**
	 * Vni Typing Mode adds vni input method support for VNTyper
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 
	 */
	public class VniMode extends TypeMode
	{
		override public function getHook(s:String):int 
		{
			if (s == '8') return 7;
			if (s == '9') return TypeMode.D9;
			return '01234567'.indexOf(s);
		}
		
		private static var _instance : VniMode;
		public static function get instance() : VniMode { return _instance ||= new VniMode(); }
		public static function get id(): String { return 'vni' };
	}

}