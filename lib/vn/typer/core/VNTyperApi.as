package vn.typer.core
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import vn.typer.core.Encoder;
	import vn.typer.core.IVNTyper;
	import vn.typer.core.TypeMode;
	import vn.typer.core.VNTyperCore;
	import vn.typer.mode.MixMode;
	import vn.typer.VNTyper;
	
	/**
	 * VNTyper library main class with all components and data
	 * 
	 * This singleton class hold user reference like fonts, encoders, typing modes
	 * and allow user to switch bettween them, support enable, disable and various utilities
	 * passing only 1 encoder, 1 typing mode, 1 textfield to VNTyperCore to do the process
	 * 
	 * Though can be fully functional, this class is not intended to be used directly, refer
	 * to the wrapper VNTyper for better use.
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.5.0
	 * @updated	18 June 2011
	 * 		
	 */ 
	
	public class VNTyperApi implements IVNTyper
	{	
		private var _core		: VNTyperCore;
		private var _modes		: Object;
		private var _encs		: Object;
		
		private var _ignores		: Dictionary;
		private var _font2Enc		: Object;
		
		public function VNTyperApi(target: DisplayObject) {
			_core	=	new VNTyperCore();
			
			_modes	=	{ };
			_encs	=	{ 'unicode'	: null };
			_ignores	= new Dictionary(true);
			_font2Enc	= { };
			
			addTypingMode(MixMode);
			useInputMode_Mix();
			
			_target = target as InteractiveObject;
			_target.addEventListener(FocusEvent.FOCUS_IN, onFocusChanged);
		}
		
	/*************************
	 * 		APIs
	 ************************/
	
		protected var _target	: DisplayObject;
		
		public function enable(): IVNTyper {
			var tf	: TextField = _target.stage.focus as TextField;
			if (!tf) return this;
			
			var isIgnored	: Boolean = _ignores[tf] ? true : _ignores[tf.getTextFormat().font];
			
			if (!isIgnored) {
				_core.startMonitor(tf);
				_core.setEncoder(_font2Enc[tf.getTextFormat().font] || currentEncoder); // use the registered encoder name
			}
			
			_target.addEventListener(FocusEvent.FOCUS_IN, onFocusChanged);
			return this;
		}
		
		public function disable(): IVNTyper {
			_core.stopMonitor();
			_target.removeEventListener(FocusEvent.FOCUS_IN, onFocusChanged);
			return this;
		}
		
		public function ignore(textfieldOrFontName : *): IVNTyper {
			_ignores[textfieldOrFontName] = true;
			return this;
		}
		
		public function unIgnore(textfieldOrFontName : *): IVNTyper {
			delete _ignores[textfieldOrFontName];
			return this;
		}
		
		public function autoFontEncode(fontNames: * , encNames: * ): IVNTyper {
			var fns : Array = fontNames is Array ? fontNames : [fontNames];
			var ens : Array = encNames is Array ? encNames : [encNames];
			var fnsl: int = fns.length;
			var ensl: int = ens.length;
			
			var l: int = Math.max(fnsl, fnsl);
			for (var i: int = 0 ; i < l ; i++) {
				_font2Enc[fns[i % fnsl]] = ens[i % ensl];
			}
			return this;
		}
		
		protected function onFocusChanged(e:FocusEvent):void { enable(); }
		
	/*************************
	 * 		ADD-ONS
	 ************************/	
		
		public function addTypingMode(typeModeClass : Class): IVNTyper {
			_modes[typeModeClass.id] = typeModeClass.instance;
			return this;
		}
		
		public function addEncoder(encoderClass : Class): IVNTyper {
			_encs[encoderClass.id] = encoderClass.instance;
			return this;
		}
		
	/*************************
	 * 		UTILS
	 ************************/	
		
		public function getEncoder(encMethod: String): Encoder { trace(encMethod, _encs[encMethod]); return _encs[encMethod]; }
		public function get currentEncoder(): Encoder { return _encs[_encodingMethod]; }
		
	/*************************
	 * 		SHORT HANDS
	 ************************/	
		
		public function useInputMode_VNI(): IVNTyper { inputMode = 'vni'; return this; };
		public function useInputMode_Telex(): IVNTyper { inputMode = 'telex'; return this; };
		public function useInputMode_Mix(): IVNTyper { inputMode = 'mix'; return this; };
		
		public function useEncoding_VNI(): IVNTyper { encodingMethod = 'vni'; return this;};
		public function useEncoding_Unicode(): IVNTyper { encodingMethod = 'unicode'; return this;};
		
	/*************************
	 * 		INPUT METHODS
	 ************************/
		
		protected var _inputMode	: String;
		
		public function get inputMode():String { return _inputMode; }
		public function set inputMode(value:String):void 
		{
			_inputMode = value;
			_core.setMode(_modes[value] || _modes['mix']);
		}
		
	/*************************
	 * 		ENCODING
	 ************************/
		
		protected var _encodingMethod	: String;
		
		public function get encodingMethod():String { return _encodingMethod; }
		public function set encodingMethod(value:String):void {
			_encodingMethod = _encs[value];
			_core.setEncoder(_encs[value]);
		}
	}
}