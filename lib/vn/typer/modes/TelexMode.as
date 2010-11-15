package vn.typer.modes
{
	import vn.typer.core.TypeMode;
	
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
		
	}

}