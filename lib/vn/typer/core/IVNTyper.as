package vn.typer.core 
{
	/**
	 * Interface for VNTyper library
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 		
	 */ 
	public interface IVNTyper 
	{
		function enable(): IVNTyper;
		function disable(): IVNTyper;
		
		function ignore(textfieldOrFontName : * ): IVNTyper;
		function unIgnore(textfieldOrFontName : * ): IVNTyper;
		
		function autoFontEncode(fontNames: * , encNames: * ): IVNTyper;
		
		function addTypingMode(typeModeClass : Class): IVNTyper;
		function addEncoder(encoderClass : Class): IVNTyper;
		
		function getEncoder(encMethod: String): Encoder;
		function get currentEncoder(): Encoder;
		
	/*************************
	 * 		SHORT HANDS
	 ************************/	
		
		function useInputMode_VNI(): IVNTyper;
		function useInputMode_Telex(): IVNTyper;
		function useInputMode_Mix(): IVNTyper;
		
		function useEncoding_VNI(): IVNTyper;
		function useEncoding_Unicode(): IVNTyper;
		
	/*************************
	 * 		INPUT METHODS
	 ************************/
		
		function get inputMode():String;
		function set inputMode(value:String):void;
		
	/*************************
	 * 		ENCODING
	 ************************/
		
		function get encodingMethod():String;
		function set encodingMethod(value:String):void;
	}
	
}