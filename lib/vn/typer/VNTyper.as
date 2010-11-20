package vn.typer
{
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import vn.typer.core.Encoder;
	import vn.typer.core.TypeMode;
	import vn.typer.core.VNTyperCore;
	import vn.typer.modes.TelexVniMode;
	
	public class VNTyper
	{	
		private var _core		: VNTyperCore;
		private var _target		: InteractiveObject;	/** Focus listening target **/
		
		private var _ignore		: Dictionary;	/** Automatically disable VNTyper for registered Textfields or Fonts **/
		
		private var _encoders	: Object;		/* encoderId to Encoders */
		private var _fonts		: Dictionary;	/* font to fontId, and fontId to font */
		
		private var _fn2Font	: Object;		/* fontName to font */
		private var _fn2Enc		: Object;		/* fontName to encoder */
		
		public function VNTyper() {
			_core		= new VNTyperCore().setMode(new TelexVniMode());
			_ignore		= new Dictionary(true);
			_fonts		= new Dictionary();
			
			_fn2Font = { };
			_fn2Enc	= { };
			_encoders	= { };
		}
		
		/**
		 * Add or remove font or textfield from ignore group (as if using english mode). Remember that once disable, the font, or textfield registed can not be enabled again, so be careful
		 * @param	fontOrTextfield
		 */
		public function disableTyperFor(fontIdOrTextfield: * ): VNTyper {
			//TODO : check for fontName and acts differently
			_ignore[fontIdOrTextfield] = 1;
			return this;
		}
		
		/**
		 * add a new encoder so it can be used by VNTyper
		 * @param	encoder
		 * @return
		 */
		public function addEncoder(encoder: Encoder): VNTyper {
			if (_encoders[encoder.id] != null) {
				trace(this, " Warning :: ", encoder.id, " already registered");
			} else {
				_encoders[encoder.id] = encoder;
			}
			return this;
		}
		
		/**
		 * register a font with its correct encoder so the Typer will automatically swith to the correct encoder based on the font of the current position in the textfield
		 * @param	fontName
		 * @param	encoderId
		 * @return
		 */
		public function addFont(fontId: String, fontClass : Font, encoderOrEncoderId: * = null): VNTyper {
			var enc			: Encoder;
			var fontName	: String = fontClass.fontName;
			
			//TODO : check if encoderOrEncoderId == null && get the only encoder if there's only one
			if (encoderOrEncoderId is Encoder) {
				enc = encoderOrEncoderId as Encoder;
			} else {
				enc = _encoders[encoderOrEncoderId];
			}
			
			if (!enc) {//exit on no encoder found
				trace(this, "fail to register fontId ", fontId, " to a null encoder or encoderId");
				return this;
			}
			
			if (_fonts[fontClass] != null) {//exit on fontClass registered
				trace(this, fontName, " already registered");
				return this;
			}
			
			if (_fonts[fontId] != null) {//exit on fontId registered
				trace(this, fontId, "already registered with ", fontName);
				return this;
			}
			
			_fonts[fontId] = fontClass;
			_fonts[fontClass] = fontId;
			
			_fn2Font[fontName] = fontClass;
			_fn2Enc[fontName] = enc;
			return this;
		}
		
		/**
		 * set typing mode, can be VniMode, TelexMode, TelexVniMode. The default mode is TelexVniMode
		 * @param	mode
		 * @return
		 */
		public function setMode(mode: TypeMode): VNTyper {
			if (mode != null) _core.setMode(mode);
			return this;
		}
		
		/**
		 * use to restrict the listening of Focus events, use stage to enable VNTyper for the whole aplication
		 * @param	target
		 * @return
		 */
		public function initialize(target: DisplayObject): VNTyper {
			//TODO : check if it's already initialized
			_target = target as InteractiveObject;
			_target.addEventListener(FocusEvent.FOCUS_IN, onFocusChanged);
			return this;
		}
		
		private function onFocusChanged(e:FocusEvent):void 
		{
			var tf : TextField = e.target as TextField;
			_core.startMonitor(tf);
			if (tf != null) {
				//TODO	: check font at keyboard position and switch encoder
				//TODO	: check ignore textfield, ignore fonts
				var tformat : TextFormat = tf.getTextFormat();
				_core.setEncoder(_fn2Enc[tformat.font]);
			}
		}
		
		public function applyFont(tf: TextField, fontIdOrFontClass: * ): void {
			var newFont		: Font = (fontIdOrFontClass is Font ? fontIdOrFontClass : _fonts[fontIdOrFontClass]) as Font;
			var fontName	: String = newFont.fontName; 
			var tformat		: TextFormat = tf.getTextFormat();
			var enc			: Encoder = _fn2Enc[tformat.font];
			var uniString	: String = enc ? enc.toUnicode(tf.text) : tf.text;
			var newEnc		: Encoder = _fn2Enc[fontName];
			
			tformat.font = fontName;
			//do auto conversion only if there is changed in encoder type
			if (enc != newEnc) tf.text =  newEnc ? newEnc.fromUnicode(uniString) : uniString;
			tf.defaultTextFormat = tformat;
			tf.setTextFormat(tformat);
		}
		
	/***************************
	 * 		STATIC
	 **************************/
		
		protected static var _instance : VNTyper;
		
		public static function initialize(target: DisplayObject = null, mode: TypeMode = null): VNTyper {
			if (!_instance) {
				_instance = new VNTyper();
				_instance.setMode(mode);
				_instance.initialize(target);
			}
			return _instance;
		}
		
		/**
		 * make sure you call initialize() before get instance
		 */
		public static function get instance(): VNTyper {
			//TODO : warn if not yet initialized
			return _instance;
		}
		
		public static function get info(): String {
			//TODO : warn if not yet initialized
			return "VNTyper version 0.4.0 by thienhaflash@gmail.com";
		}
	}

}