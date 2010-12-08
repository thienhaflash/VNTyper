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
		private var _fid2Enc		: Object;		/* fontName to encoder */
		
		public function VNTyper() {
			_core		= new VNTyperCore().setMode(new TelexVniMode());
			_ignore		= new Dictionary(true);
			_fonts		= new Dictionary();
			
			_fn2Font = { };
			_fid2Enc	= { };
			_encoders	= { };
		}
		
		/**
		 * Add or remove font or textfield from ignore group (as if using english mode). Remember that once disable, the font, or textfield registed can not be enabled again, so be careful
		 * @param	fontOrTextfield
		 */
		public function ignore(fontIdOrTextfield: * ): VNTyper {
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
				trace(this, 'Warning :: ', encoder.id, ' already registered');
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
		public function mapToEncoder(fontId: String, encoderOrEncoderId: * = null, fontClass: Font = null): VNTyper {
			var enc			: Encoder;
			
			//TODO : check if encoderOrEncoderId == null && get the only encoder if there's only one
			if (encoderOrEncoderId is Encoder) {
				enc = encoderOrEncoderId as Encoder;
			} else {
				enc = _encoders[encoderOrEncoderId];
			}
			
			if (!enc) {//exit on no encoder found
				trace(this, 'fail to register fontId ', fontId, ' to a null encoder or encoderId');
				return this;
			}
			
			var oEnc : Encoder = _fid2Enc[fontId];
			if (!oEnc) {//oEnc associated with fontId not yet exist
				_fid2Enc[fontId] = enc;
			} else {
				trace(this, 'fontId ', fontId, ' already associated with encoder ', oEnc.id);
			}
			
			if (fontClass) mapToFont(fontId, fontClass);
			return this;
		}
		
		/**
		 * map fontId to its corresponding fontClass
		 * @param	fontId
		 * @param	fontClass
		 * @return
		 */
		public function mapToFont(fontId: String, fontClass: Font): VNTyper {
			var fontName	: String = fontClass.fontName;
			
			if (_fonts[fontClass] != null) {//exit on fontClass registered
				trace(this, fontName, 'already registered with id ', _fonts[fontClass]);
				return this;
			}
			
			if (_fonts[fontId] != null) {//exit on fontId registered
				trace(this, fontId, 'already registered with ', fontName);
				return this;
			}
			
			_fonts[fontId] = fontClass;
			_fonts[fontClass] = fontId;
			_fn2Font[fontName] = fontClass;
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
		internal function initialize(target: DisplayObject): VNTyper {
			//TODO : check if it's already initialized
			_target = target as InteractiveObject;
			_target.addEventListener(FocusEvent.FOCUS_IN, onFocusChanged);
			return this;
		}
		
		private function onFocusChanged(e:FocusEvent):void 
		{
			var tf : TextField = e.target as TextField;
			if (_ignore[tf] == 1) tf = null;//this textfield is ignored
			
			if (tf != null) {
				//TODO	: check font at keyboard position and switch encoder
				var tformat : TextFormat = tf.getTextFormat();
				var font	: Font		= _fn2Font[tformat.font];
				
				if (_ignore[_fonts[font]] != 1) {//not ignored font
					_core.startMonitor(tf);
					_core.setEncoder(font ? _fid2Enc[_fonts[font]] : null);
					return;
				}
			}
			//encoder is not important here, because we didn't monitor changes
			_core.startMonitor(null);
		}
		
		public function applyFont(tf: TextField, fontIdOrFontClass: * ): void {
			var newFontId	: String = fontIdOrFontClass is Font ? _fonts[fontIdOrFontClass] : fontIdOrFontClass ;
			var newFont		: Font = fontIdOrFontClass is Font ? fontIdOrFontClass as Font : _fonts[fontIdOrFontClass];; ;
			var fontName	: String = newFont.fontName; 
			var tformat		: TextFormat = tf.getTextFormat();
			
			var enc			: Encoder = _fid2Enc[_fonts[_fn2Font[tformat.font]]];
			var uniString	: String = enc ? enc.toUnicode(tf.text) : tf.text;
			var newEnc		: Encoder = _fid2Enc[newFontId];
			
			//trace(enc, newFontId, newFont, fontName, enc, uniString, newEnc.id);
			
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
		public static function get api(): VNTyper {
			//TODO : warn if not yet initialized
			return _instance;
		}
		
		public static function get info(): String {
			//TODO : warn if not yet initialized
			return 'VNTyper version 0.4.0001 by thienhaflash@gmail.com';
		}
	}

}