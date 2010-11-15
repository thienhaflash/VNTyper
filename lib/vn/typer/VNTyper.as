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
		private var _font2Enc	: Object;		/** Automatically change encoder based on registed fonts, use Unicode as default **/
		private var _encoders	: Object;		/** Saved encoderId **/
		
		public function VNTyper() {
			_core		= new VNTyperCore().setMode(new TelexVniMode());
			_ignore		= new Dictionary(true);
			_font2Enc	= { };
			_encoders	= { };
		}
		
		/**
		 * Add or remove font or textfield from ignore group (as if using english mode). Remember that once disable, the font, or textfield registed can not be enabled again, so be careful
		 * @param	fontOrTextfield
		 */
		public function disableTyperFor(fontNameOrTextfield: * ): VNTyper {
			//TODO : check for fontName and acts differently
			_ignore[fontNameOrTextfield] = 1;
			return this;
		}
		
		/**
		 * add a new encoder so it can be used by VNTyper
		 * @param	encoder
		 * @return
		 */
		public function addEncoder(encoder: Encoder): VNTyper {
			_encoders[encoder.id] = encoder;
			return this;
		}
		
		/**
		 * register a font with its correct encoder so the Typer will automatically swith to the correct encoder based on the font of the current position in the textfield
		 * @param	fontName
		 * @param	encoderId
		 * @return
		 */
		public function addFont(fontName: String, encoderId: String = null): VNTyper {
			//TODO : if there is only 1 encoder in the dict and encoderId == null, use it
			var enc : Encoder = _encoders[encoderId];
			//TODO : check existed fontName and trace warning
			_font2Enc[fontName] = enc;
			
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
			_core.startMonitor(e.target as TextField);
			if (e.target is TextField) {
				//TODO	: check font at keyboard position and switch encoder
				//TODO	: check ignore textfield, ignore fonts
			}
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