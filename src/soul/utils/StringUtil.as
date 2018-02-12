package soul.utils
{
	import flash.utils.ByteArray;

	public class StringUtil
	{
		public function StringUtil()
		{
		}
		/**
		 *检查字符串是否存在 
		 * @param str 被查找的字符串
		 * @param checkStr 查找的内容
		 * @return 是否存在
		 * 
		 */		
		public static function checkString(str:String,checkStr:String):Boolean
		{
			var boo:Boolean = false;
			for(var i:int = 0;i < str.length;i++)
			{
				if(str.charAt(i) == checkStr)
				{
					boo = true;
					return boo;
				}
			}
			return boo;
		}
		
		/**
		 *字符串替换 
		 * @param string 被替换的字符串
		 * @param oldString 查找的内容
		 * @param replaceString 替换的内容
		 * @return 被替换的字符串
		 * 
		 */		
		public static function stringReplace(string:String,oldString:String,replaceString:String):String
		{
			var ch:RegExp  = new RegExp(oldString,"g");
			var str:String = string.replace(ch,replaceString);
			return str;
		}
		public static var GB2312:String="gb2312";
		public static var BIG5:String="big5";
		public static var GBK:String="gbk";
		public static var UTF8:String="UTF-8";
		
		/**
		 * unicode 转换
		 * @param str 需要转换的字符串
		 * @param reqString 转换后的类型
		 * @return 被转换后的字符串
		 * 
		 */		
		public static function urlencodeGB2312(str:String,reqString:String):String{
			var result:String ="";
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,reqString);
			for(var i:int;i<byte.length;i++){
				result += escape(String.fromCharCode(byte[i]));
			}
			return result;
		}
	}
}