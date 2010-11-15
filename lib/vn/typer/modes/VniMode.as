package vn.typer.modes 
{
	import vn.typer.core.TypeMode;
	
	public class VniMode extends TypeMode
	{
		override public function getHook(s:String):int 
		{
			if (s == '8') return 7;
			if (s == '9') return TypeMode.D9;
			return '01234567'.indexOf(s);
		}
		
	}

}