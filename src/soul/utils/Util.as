package soul.utils
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import soul.FrameworkInfo;
	
	public class Util
	{
		public static function copyPixel(bitmapData:BitmapData,widthNum:uint,heightNum:uint):Array{
			var width:Number = Math.round(bitmapData.width / widthNum);
			var height:Number = Math.round(bitmapData.height / heightNum);
			var num:uint = widthNum * heightNum;
			var arr:Array = [];
			for(var i:uint = 0; i < num; i++){
				var newData:BitmapData = new BitmapData(bitmapData.width / widthNum,bitmapData.height / heightNum);
				var bitmap:Bitmap = new Bitmap();
				bitmap.bitmapData = newData;
				bitmap.bitmapData.copyPixels(bitmapData,new Rectangle(i % widthNum * width,Math.floor(i / widthNum) * height,width,height),new Point());
				/*trace("i:" + i + "rect" + i % widthNum * width + "//" + Math.floor(i / widthNum) * height + "//" + width + "//" + height);*/
				arr.push(bitmap);
			}
			
			return arr
		}
		
		public static function getDomain(type:int = 0):LoaderContext
		{
			var loaderContext:LoaderContext = new LoaderContext();
			switch(type)
			{
				case 0:
					//子域
					loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					break;
				case 1:
					//同域
					loaderContext.applicationDomain = ApplicationDomain.currentDomain;
					break;
				case 2:
					//新域
					loaderContext.applicationDomain = new ApplicationDomain(null)
					break;
				default:
					//子域
					loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					break;
			}
			return loaderContext;
		}
		
		/**
		 * 获取根目录地址
		 * @param source 地址
		 * @return 目录地址
		 * 
		 */		
		public static function getCatalogue(source:String):String
		{
			if(!source) return source;
			var str:String = source.split("?")[0];
			var index:int = str.lastIndexOf("\\"); 
			if(index == -1)
			{
				index = str.lastIndexOf("/"); 
			}
			var contents:String = str.substring(0,index);
			return contents;
		}
		/**
		 * 地址转换 加上“.../”后会对地址加上目录
		 * @param source 地址
		 * @return 转化后的地址
		 * 
		 */		
		public static function sourceTransition(source:String):String
		{
			return source.replace("...",FrameworkInfo.catalogue);
		}
		/**
		 *
		 * 深复制对象 
		 * @param value 需要复制的对象
		 * @return 复制后对象
		 * 
		 */		
		public static function cloneObject(value:Object) :* {
			var typeName:String = getQualifiedClassName(value);//获取全名
			//trace(”输出类的结构”+typeName);
			//return;
			var packageName:String = typeName.split("::")[0];//切出包名
			//trace(”类的名称”+packageName);
			var type:Class = getDefinitionByName(typeName) as Class;//获取Class
			//trace(type);
			registerClassAlias(packageName, type);//注册Class
			//复制对象
			var copier:ByteArray = new ByteArray();
			copier.writeObject(value);
			copier.position = 0;
			return copier.readObject();
		}
		/**
		 * 从一个对象中删除一个值
		 * 
		 * @param obj	对象
		 * @param data	要删除的内容
		 * 
		 */		
		public static function remove(obj:*,data:*):void
		{
			var index:int;
			if (obj is Array)
			{
				index = (obj as Array).indexOf(data);
				if (index!=-1)
					(obj as Array).splice(index, 1);
			}
			else
			{
				for (var key:* in obj)
				{
					if (obj[key]==data)
					{
						delete obj[key];
						return;
					}
				}
			}
		}
		/**
		 * 获得 真实大小(用作查询设置过scrollRect的对象的大小) 
		 * 此方法不允许获得伸缩后的容器大小，如果需要伸缩 请加入新容器后伸缩
		 * @param target 查询对象
		 * @return 返回大小
		 * 
		 */		
		public static function getRealSize(target:InteractiveObject):Rectangle
		{
			var transform:Transform = target.transform;
			var currentMatrix:Matrix = transform.matrix;
			var toGlobalMatrix:Matrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix; 
			var rect:Rectangle = transform.pixelBounds.clone(); 
			transform.matrix = currentMatrix;
			return rect; 
		}
		/**
		 * xml转对象 
		 * @param xml XML
		 * @return 对象
		 * 
		 */		
		public static function xmlToObject(xml:XML):Object
		{
			var obj:Object = new Object();
			var ls:XMLList = xml.children();
			var atts:XMLList = xml.attributes();
			
			for each (var att:XML  in atts)
			{
				obj[att.name().toString()]= att.toString();
			}
			
			if(ls.length() > 0)
			{
				for each(var node:XML in ls) 
				{
					var objsub:Object = xmlToObject(node);
					var tmp:Object = obj[node.name()];
					if(tmp==null)
					{
						obj[node.name()]=objsub;
					}
					else if(tmp is Array)
					{
						(tmp as Array).push(objsub);
					}
					else
					{
						obj[node.name()]=new Array(tmp,objsub);
					}
				}
			}
			return obj;
		}
		private static var bmpData:BitmapData = new BitmapData(1,1);
		/**
		 *强制刷新scrollRect 
		 * @param target 刷新目标
		 * 
		 */		
		public static function breakScrollRect(target:DisplayObject):void
		{
			bmpData.draw(target);
		}
		
		/**
		 *设置对象3D摄像机位置 
		 * @param dis 设置对象
		 * @param centerPoint 摄像机点(一般为对象的坐标点)
		 * @param fieldOfView Z轴度数
		 * 
		 */		
		public static function set3DVidicon(dis:DisplayObject,centerPoint:Point,fieldOfView:Number):void
		{
			var p:PerspectiveProjection=new PerspectiveProjection(); 
			p.projectionCenter = centerPoint; 
			p.fieldOfView=fieldOfView;
			dis.transform.perspectiveProjection = p;
		}
		
		/**
		 *除去对象3D属性 
		 * @param display
		 * 
		 */		
		public static function removeMatrix3D(display:DisplayObject):void
		{
			display.rotationX = 0;
			display.rotationY = 0;
			display.rotationZ = 0;
			var _matrix:Matrix=new Matrix;
			_matrix.tx=display.transform.matrix3D.position.x;
			_matrix.ty = display.transform.matrix3D.position.y;
			display.transform.matrix=_matrix;                        
			display.transform.matrix3D=null;
		}
		
		/**
		 *强制GC (一些版本gc无效时使用这个gc)
		 * 
		 */		
		public static function gc():void
		{
			try {
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch (e:*) {} 

		}
		
		
	}
}