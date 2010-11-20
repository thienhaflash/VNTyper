package vn.typer.encode 
{
	import flash.utils.Dictionary;
	import vn.typer.core.Encoder;
	
	public class VniEncoder extends Encoder
	{
		protected var uni2vni	: Dictionary;
		protected var vni2uni	: Dictionary;
		
		public function VniEncoder() 
		{
			_id = "VniEncoder";
			var sVni 	: Array = 'AØ,AÙ,AÂ,AÕ,EØ,EÙ,EÂ,Ì,Í,OØ,OÙ,OÂ,OÕ,UØ,UÙ,AÊ,Ñ,Ó,UÕ,Ô,aø,aù,aâ,aõ,eø,eù,eâ,ì,í,oø,où,oâ,oõ,uø,uù,aê,ñ,ó,uõ,ô,Ö,AÊ,AÏ,AÛ,AÁ,AÀ,AÅ,AÃ,AÄ,AÉ,AÈ,AÚ,AÜ,AË,EÏ,EÛ,EÕ,EÁ,EÀ,EÅ,ö,aê,aï,aû,aá,aà,aå,aã,aä,aé,aè,aú,aü,aë,eï,eû,eõ,eá,eà,eå,EÃ,EÄ,Æ,Ò,OÏ,OÛ,OÁ,OÀ,OÅ,OÃ,OÄ,ÔÙ,ÔØ,ÔÛ,ÔÕ,ÔÏ,UÏ,UÛ,ÖÙ,ÖØ,eã,eä,æ,ò,oï,oû,oá,oà,oå,oã,oä,ôù,ôø,ôû,ôõ,ôï,uï,uû,öù,öø,ÖÛ,ÖÕ,ÖÏ,YØ,Î,YÙ,YÛ,YÕ,öû,öõ,öï,yù,yø,î,yû,yõ'.split(',');
			var sUni	: Array = 'À,Á,Â,Ã,È,É,Ê,Ì,Í,Ò,Ó,Ô,Õ,Ù,Ú,Ă,Đ,Ĩ,Ũ,Ơ,à,á,â,ã,è,é,ê,ì,í,ò,ó,ô,õ,ù,ú,ă,đ,ĩ,ũ,ơ,Ư,Ă,Ạ,Ả,Ấ,Ầ,Ẩ,Ẫ,Ậ,Ắ,Ằ,Ẳ,Ẵ,Ặ,Ẹ,Ẻ,Ẽ,Ế,Ề,Ể,ư,ă,ạ,ả,ấ,ầ,ẩ,ẫ,ậ,ắ,ằ,ẳ,ẵ,ặ,ẹ,ẻ,ẽ,ế,ề,ể,Ễ,Ệ,Ỉ,Ị,Ọ,Ỏ,Ố,Ồ,Ổ,Ỗ,Ộ,Ớ,Ờ,Ở,Ỡ,Ợ,Ụ,Ủ,Ứ,Ừ,ễ,ệ,ỉ,ị,ọ,ỏ,ố,ồ,ổ,ỗ,ộ,ớ,ờ,ở,ỡ,ợ,ụ,ủ,ứ,ừ,Ử,Ữ,Ự,Ỳ,Ỵ,Ý,Ỷ,Ỹ,ử,ữ,ự,ý,ỳ,ỵ,ỷ,ỹ'.split(',');
			
			uni2vni = new Dictionary();
			vni2uni = new Dictionary();
			
			var l : int = sVni.length;
			for (var i: int = 0; i < l; i++) {
				uni2vni[sUni[i]] = sVni[i];
				vni2uni[sVni[i]] = sUni[i];
			}
		}
		
		override public function toUnicode(s:String):String 
		{
			var ns : String = '';
			var cs : String;
			var l : int = s.length;
			for (var i : int = 0; i < l; i++) {
				cs = vni2uni[s.charAt(i) + s.charAt(i + 1)];
				if (cs != null) {
					i++;
					ns += cs;
				} else {
					cs = vni2uni[s.charAt(i)];
					ns += cs != null ? cs : s.charAt(i);
				}
			}
			
			return ns;
		}
		
		override public function fromUnicode(s:String):String 
		{
			var ns : String = '';
			var cs : String;
			var l : int = s.length;
			for (var i : int = 0; i < l; i++) {
				cs = uni2vni[s.charAt(i)];
				ns += cs ? cs : s.charAt(i);
			}
			return ns;
		}
		
		public static function get id(): String {
			return "VniEncoder";
		}
	}

}