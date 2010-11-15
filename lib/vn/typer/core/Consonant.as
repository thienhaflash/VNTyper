package vn.typer.core 
{
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