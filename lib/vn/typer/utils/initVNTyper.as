package vn.typer.utils 
{
	import flash.display.DisplayObject;
	import vn.typer.core.IVNTyper;
	import vn.typer.core.VNTyperApi;
	import vn.typer.encode.VniEncoder;
	import vn.typer.mode.TelexMode;
	import vn.typer.mode.VniMode;
	import vn.typer.VNTyper;
	/**
	 * Inits VNTyperApi singleton, allow VNTyper to work
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 
	 */
	public function initVNTyper(initTarget: DisplayObject = null) : IVNTyper
	{
		if (initTarget && !VNTyper.api) VNTyper.api = new VNTyperApi(initTarget);
		return VNTyper.api;
	}
}