/* Copyright (c) 2011 by thienhaflash (thienhaflash@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package vn.typer 
{
	import flash.display.DisplayObject;
	import vn.typer.core.Encoder;
	import vn.typer.core.IVNTyper;
	import vn.typer.core.TypeMode;
	
	/**
	 * VNTyper Wrapper to be used directly by User
	 * 
	 * This static class hold a reference to the singleton VNTyperApi which provides
	 * all the functionality. The class is setup so that people using VNTyper will have
	 * clearest syntax with chainable, strong typing interface, this wrapper also offers
	 * much better file size manager for using in modules
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 		
	 */ 
	
	public class VNTyper
	{
		private static const name		: String = 'VNTyper';
		private static const version	: String = '0.5';
		private static const author		: String = 'thienhaflash@gmail.com';
		private static const updated	: String = '18 June 2011';
		
		public static var api : IVNTyper ;
		
		public static function enable(): IVNTyper {
			return api ? api.enable() : null;
		}
		
		public static function disable(): IVNTyper {
			return api ? api.disable() : null;
		}
		
		public static function ignore(textfieldOrFontName : *): IVNTyper {
			return api ? api.ignore(textfieldOrFontName) : null;
		}
		
		public static function unIgnore(textfieldOrFontName : *): IVNTyper {
			return api ? api.unIgnore(textfieldOrFontName) : null;
		}
		
		public static function autoFontEncode(fontNames: * , encNames: * ): IVNTyper {
			return api ? api.autoFontEncode(fontNames, encNames) : null;
		}
		
		public static function addTypingMode(typeModeClass : Class): IVNTyper {
			return api ? api.addTypingMode(typeModeClass) : null;
		}
		
		public static function addEncoder(encoderClass : Class): IVNTyper {
			return api ? api.addEncoder(encoderClass) : null;
		}
		
		public static function getEncoder(encMethod: String): Encoder {
			return api ? api.getEncoder(encMethod) : null;
		}
		
		public static function get currentEncoder(): Encoder { 
			return api ? api.currentEncoder : null;
		}
		
	/*************************
	 * 		SHORT HANDS
	 ************************/	
		
		public static function useInputMode_VNI(): IVNTyper {
			return api ? api.useInputMode_VNI() : null;
		}
		
		public static function useInputMode_Telex(): IVNTyper { 
			return api ? api.useInputMode_Telex() : null;
		}
		
		public static function useInputMode_Mix(): IVNTyper { 
			return api ? api.useInputMode_Mix() : null;
		}
		
		public static function useEncoding_VNI(): IVNTyper { 
			return api ? api.useEncoding_VNI() : null;
		}
		
		public static function useEncoding_Unicode(): IVNTyper {
			return api ? api.useEncoding_VNI() : null;
		}
		
	/*************************
	 * 		INPUT METHODS
	 ************************/
		
		public static function get inputMode():String {
			return api ? api.inputMode : null;
		}
		
		public static function set inputMode(value:String):void 
		{
			if (api) api.inputMode = value;
		}
		
	/*************************
	 * 		ENCODING
	 ************************/
		
		public static function get encodingMethod():String {
			return api ? api.inputMode : null;
		}
		
		public static function set encodingMethod(value:String):void {
			if (api) api.encodingMethod = value;
		}
	}
}