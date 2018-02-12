
package soul.vo
{
	import flash.display.Loader;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;

	/**
	 * source:加载路径
	 * type：加载属性 （加载图片:type = 0,加载音乐:type = 1,加载SWF:type = 2,加载网页数据:type = 3）
	 * text：域文件
	 * isV:是否加版本号
	 */
	public class LoadVo
	{
		public var source:String;
		public var type:int;
		public var context:LoaderContext;
		public var isV:Boolean = true;
		public var loader:Loader;
		public var urlLoader:URLLoader;
		public var sound:Sound;
	}
}