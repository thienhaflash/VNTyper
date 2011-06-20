package vn.typer.core 
{
	import flash.text.Font;
	import flash.utils.Dictionary;

	/**
	 * Base class for all Encoding Method used in VNTyper
	 * This class is not intented to be used separatedly
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 
	 */ 
	public class Encoder /* this one is Unicode encoder */
	{
		public function fromUnicode(s: String): String {
			return s;
		}
		
		public function toUnicode(s: String): String {
			return s;
		}
	}

}