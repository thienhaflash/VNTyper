package vn.typer.modes 
{
	import vn.typer.core.TypeMode;
	
	public class TelexVniMode extends TypeMode
	{
		override public function getHook(s:String):int 
		{
			s = s.toUpperCase();
			
			var i : int = 'ZSFRXJ'.indexOf(s);
			if (i == -1) i = '01234567'.indexOf(s);
			
			if (i == -1) {
				switch (s) {
					case 'O' : i = TypeMode.O6; break; /* special keys */
					case 'E' : i = TypeMode.E6; break;
					case 'A' : i = TypeMode.A6; break;
					case 'W' : 
					case '8' : i = 7; break;
					case 'D' : 
					case '9' : i = TypeMode.D9; break;
				}
			}
			//trace('get hook of ', s, i);
			return i;
		}
		
	}

}