package vn.utils 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class FontManager 
	{
		public function FontManager() 
		{
			if (_instance) throw new Error('Can not instantiate singleton');
			_dict = new Dictionary();
		}
		
		//TODO : Resume load if error (?)
		
		protected var _dict		: Dictionary;
		protected var _loader	: FontLoader;
		protected var _queue	: Object; //url to FontVO
		
	/*********************
	 * 		METHODS
	 *********************/	
		
		/**
		 * 
		 * @param	id
		 * @param	urlOrClass
		 * @param	autoLoad
		 * @return
		 */
		public function addFont(id: String, urlOrClass: * ): FontVO {
			if (_dict['fontId::' + id] != null) return; //duplicated id registered
			
			var fvo : FontVO;
			
			if (urlOrClass is String) {//need to load
				var url : String = urlOrClass as String;
				fvo = new FontVO(id, url);
				_queue[url] = fvo;
				//todo : check queue (?)
			} else {
				var cls : Class = urlOrClass as Class;
				fvo = new FontVO(id, null, cls);
			}
			
			return fvo;
		}
		
	/*********************
	 * 		GETTERS
	 *********************/
		
		public function id2FontVO(fontId: String): FontVO {
			return _dict['fontId::'+fontId];
		}
		
		public function name2FontVO(fontName: String): FontVO {
			return _dict['fontName::'+fontName];
		}
		
		public function class2FontVO(cls: Class): FontVO {
			return _dict[cls];
		}
		
	/*********************
	 * 		STATIC
	 *********************/
		
		static private var _instance : FontManager = new FontManager();
		
		public static function get api(): FontManager {
			return _instance;
		}
		
	}

}

class FontVO {
	public var id		: String; //fontID
	public var url		: String; //external loaded (?)
	
	public var charset		: String; //Unicode, Vni, TCVN, ...
	public var fontName		: String; //validated font name
	public var fontClass	: Class;
	
	internal var pending	: Array; // Array of textfield pending apply format
	
	public function FontVO(id:String, url: String = null, cls: Class = null) {
		
	}
} 