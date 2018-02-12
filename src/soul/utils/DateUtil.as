package soul.utils
{
	public class DateUtil
	{
		public static function getDateString():String
		{
			var str:String;
			var date:Date = new Date();
			str = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
			return str;
		}
		public static function getDateString2():String
		{
			var date:Date = new Date();
			var hours:String = String(date.getHours());
			var minutes:String = String(date.getMinutes());
			if(hours.length < 2) hours = "0" + hours;
			if(minutes.length < 2) minutes = "0" + minutes;
			return hours + minutes;
		}
		public static function getDateString3():String
		{
			var str:String;
			var date:Date = new Date();
			str = date.getMonth() + 1 + "月" + date.getDate() + "日" + date.getHours() + "时" + date.getMinutes() + "分" + date.getSeconds() + "秒";
			return str;
		}
	}
}