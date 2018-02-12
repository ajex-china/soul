package soul.debug
{
	import flash.events.*;
	import flash.net.*;
	
	public class AS3Debugger extends Object
	{
		private static var conn:LocalConnection;
		public static var identity:String = "^-^无名氏^-^";
		public static var OmitTrace:Boolean = true;
		public static var callBack:Function;
		public static var history:String="调试开始";//历史记录
		
		public function AS3Debugger()
		{
			throw new Error("AS3Debugger 为静态类，不允许实例化");
		}// end function
		
		public static function Trace(param1:*, param2:String = "") : Object
		{
			trace(param1);
			if (!AS3Debugger.OmitTrace)
			{
				return null;
			}// end if
			if (param2 == "")
			{
				param2 = AS3Debugger.identity;
			}// end if
			if (conn == null)
			{
				conn = new LocalConnection();
				conn.addEventListener(StatusEvent.STATUS, onStatus);
			}// end if
			if (param1.toString() == "[object Object]")
			{
				param1 = objectToString(param1);
			}
			else if (param1 is Array)
			{
				param1 = arrayToString(param1);
			}
			else if (param1 is XML)
			{
				param1 = param1.toXMLString();
			}
			else
			{
				param1 = param1.toString();
			}// end else if
			param1 = htmlFormat(param1);
			param1 = "<font color=\'#ff0000\'>[" + getTime() + "]</font>" + "<font size=\'12\' color=\'#000000\' face=\'宋体\'>" + param1 + "</font>";
			try
			{
				conn.send("_debugConnection", "transMsg", param1, param2);
			}// end try
			catch (e:Error)
			{
			}// end catch
			history = history+ "\n" + param1;
			if(callBack!=null) callBack.call(AS3Debugger,param1);
			return param1;
		}// end function
		
		private static function htmlFormat(param1:String) : String
		{
			param1 = param1.replace(/\&/g, "&amp;");
			param1 = param1.replace(/\</g, "&lt;");
			param1 = param1.replace(/\>/g, "&gt;");
			param1 = param1.replace(/\"/g, "&quot;");
			param1 = param1.replace(/\'/g, "&apos;");
			return param1;
		}// end function
		
		private static function getTime() : String
		{
			var _loc_1:* = new Date();
			return getFormatTime(_loc_1.getHours()) + ":" + getFormatTime(_loc_1.getMinutes()) + ":" + getFormatTime(_loc_1.getSeconds()) + "." + _loc_1.getMilliseconds();
		}// end function
		
		private static function getFormatTime(param1:uint) : String
		{
			return param1 < 10 ? ("0" + param1) : ("" + param1);
		}// end function
		
		private static function onStatus(param1:StatusEvent) : void
		{
			switch(param1.level)
			{
				case "status":
				{
					break;
				}// end case
				case "error":
				{
					break;
				}// end case
				default:
				{
					break;
				}// end default
			}// end switch
			return;
		}// end function
		
		private static function objectToString(param1:Object) : String
		{
			var _loc_3:String="";
			var _loc_2:String="";
			for (_loc_3 in param1)
			{
				// label
				if (param1[_loc_3].toString() == "[object Object]")
				{
					_loc_2 = _loc_2 + (_loc_3 + ":" + objectToString(param1[_loc_3]) + ",");
					continue;
				}// end if
				if (param1[_loc_3] is Array)
				{
					_loc_2 = _loc_2 + (_loc_3 + ":" + arrayToString(param1[_loc_3]) + ",");
					continue;
				}// end if
				_loc_2 = _loc_2 + (_loc_3 + ":" + param1[_loc_3] + ",");
			}// end of for ... in
			_loc_2 = _loc_2.substr(0, _loc_2.length -1);
			_loc_2 = "{" + _loc_2 + "}";
			return _loc_2;
		}// end function
		
		private static function arrayToString(param1:Array) : String
		{
			var _loc_2:* = param1.length;
			var _loc_3:String="";
			var _loc_4:uint;
			while (_loc_4 < _loc_2)
			{
				// label
				if (param1[_loc_4].toString() == "[object Object]")
				{
					_loc_3 = _loc_3 + (objectToString(param1[_loc_4]) + ",");
					continue;
				}// end if
				if (param1[_loc_4] is Array)
				{
					_loc_3 = _loc_3 + (arrayToString(param1[_loc_4]) + ",");
					continue;
				}// end if
				_loc_3 = _loc_3 + (param1[_loc_4] + ",");
				_loc_4++;
			}// end while
			_loc_3 = _loc_3.substr(0, _loc_3.length -1);
			_loc_3 = "[" + _loc_3 + "]";
			return _loc_3;
		}// end function
		
	}
}
