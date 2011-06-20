package vn.typer.data 
{
	/**
	 * Consonant Data structure for VNTyper
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 		
	 */
		
	public class Consonant extends Char {
	
		public function Consonant(_up: Boolean, _ul: String) { /* dat : 2 chars */
			super(false, _up, _ul);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get up():String 
		{
			return data.charAt(0);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get low():String 
		{
			return data.charAt(1);
		}
	}

}