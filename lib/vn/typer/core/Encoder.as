package vn.typer.core 
{
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	public class Encoder
	{
		protected var _id : String;
		
		public function fromUnicode(s: String): String {
			return s;
		}
		
		public function toUnicode(s: String): String {
			return s;
		}
		
		public function get id(): String {
			return _id;
		}
	}

}