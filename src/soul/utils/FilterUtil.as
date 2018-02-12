package soul.utils
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class FilterUtil
	{
		/**
		 *投影滤镜 
		 * @param distance 阴影的偏移距离
		 * @param angle 阴影的角度
		 * @param color 阴影颜色
		 * @param alpha 不透明度
		 * @param blurX 水平模糊量
		 * @param blurY 垂直模糊量
		 * @param strength 强度
		 * @param quality 阴影品质 1 低 2 中 3 高 
		 * @param inner 是否为内侧阴影
		 * @param knockout 应用挖空效果
		 * @param hideObject 表示是否隐藏对象
		 * @return 投影滤镜对象
		 * 
		 */		
		public static function createDropShadowFilter(distance:Number = 4.0, angle:Number = 45, color:uint = 0, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout,hideObject);
		}
		
		/**
		 *斜角滤镜 
		 * @param distance 斜角的偏移距离
		 * @param angle 斜角的角度
		 * @param highlightColor 斜角的加亮颜色
		 * @param highlightAlpha 加亮颜色的 Alpha 透明度值
		 * @param shadowColor 斜角的阴影颜色
		 * @param shadowAlpha 阴影颜色的 Alpha 透明度值
		 * @param blurX 水平模糊量
		 * @param blurY 垂直模糊量
		 * @param strength 强度
		 * @param quality 斜角品质 1 低 2 中 3 高 
		 * @param type 斜角类型  full 整个区域 inner 内侧区域 outer 外侧区域
		 * @param knockout  应用挖空效果
		 * @return 斜角滤镜对象
		 * 
		 */		
		public static function createBevelFilter(distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false):BevelFilter
		{
			return new BevelFilter(distance,angle,highlightColor,highlightAlpha,shadowColor,shadowAlpha,blurX,blurY,strength,quality,type,knockout);
		}
		
		/**
		 * 模糊滤镜
		 * @param blurX 水平模糊量
		 * @param blurY 垂直模糊量
		 * @param quality 模糊品质 1 低 2 中 3 高 
		 * @return 模糊滤镜对象
		 * 
		 */		
		public static function createBlurFilter(blurX:Number = 4.0, blurY:Number = 4.0, quality:int = 1):BlurFilter
		{
			return new BlurFilter(blurX,blurY,quality);
		}
		
		/**
		 * 发光滤镜
		 * @param color 光晕颜色
		 * @param alpha 颜色的 Alpha 透明度值
		 * @param blurX 水平模糊量
		 * @param blurY 垂直模糊量
		 * @param strength 强度
		 * @param quality 发光品质 1 低 2 中 3 高 
		 * @param inner 指定发光是否为内侧发光 
		 * @param knockout 指定对象是否具有挖空效果
		 * @return 发光滤镜对象
		 * 
		 */		
		public static function createGlowFilter(color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false):GlowFilter
		{
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
		}
		
		/**
		 * 色彩饱和度
		 * 
		 * @param n (N取值为0到255)
		 * @return 
		 * 
		 */
		public static function createSaturationFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter([0.3086*(1-n)+ n,	0.6094*(1-n),	0.0820*(1-n),	0,	0,
				0.3086*(1-n),	0.6094*(1-n) + n,	0.0820*(1-n),	0,	0,
				0.3086*(1-n),	0.6094*(1-n)    ,	0.0820*(1-n) + n,	0,	0,
				0,	0,	0,	1,	0]);
		}
		
		/**
		 * 对比度
		 * 
		 * @param n (N取值为0到10)
		 * @return 
		 * 
		 */
		public static function createContrastFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter([n,	0,	0,	0,	128*(1-n),
				0,	n,	0,	0,	128*(1-n),
				0,	0,	n,	0,	128*(1-n),
				0,	0,	0,	1,	0]);
		}
		
		/**
		 * 亮度(N取值为-255到255)
		 * 
		 * @param n
		 * @return 
		 * 
		 */
		public static function createBrightnessFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter([1,	0,	0,	0,	n,
				0,	1,	0,	0,	n,
				0,	0,	1,	0,	n,
				0,	0,	0,	1,	0]);
		}
		
		/**
		 * 颜色反相
		 * 
		 * @return 
		 * 
		 */
		public static function createInversionFilter():ColorMatrixFilter
		{
			return new ColorMatrixFilter([-1,	0,	0,	0,	255,
				0,	-1,	0,	0,	255,
				0,	0,	-1,	0,	255,
				0,	0,	0,	1,	0]);
		}
		
		/**
		 * 色相偏移 
		 * @return 
		 * 
		 */
		public static function createHueFilter(n:Number):ColorMatrixFilter
		{
			const p1:Number = Math.cos(n * Math.PI / 180);
			const p2:Number = Math.sin(n * Math.PI / 180);
			const p4:Number = 0.213;
			const p5:Number = 0.715;
			const p6:Number = 0.072;
			return new ColorMatrixFilter([p4 + p1 * (1 - p4) + p2 * (0 - p4), p5 + p1 * (0 - p5) + p2 * (0 - p5), p6 + p1 * (0 - p6) + p2 * (1 - p6), 0, 0, 
				p4 + p1 * (0 - p4) + p2 * 0.143, p5 + p1 * (1 - p5) + p2 * 0.14, p6 + p1 * (0 - p6) + p2 * -0.283, 0, 0, 
				p4 + p1 * (0 - p4) + p2 * (0 - (1 - p4)), p5 + p1 * (0 - p5) + p2 * p5, p6 + p1 * (1 - p6) + p2 * p6, 0, 0,
				0, 0, 0, 1, 0]);
		}
		
		/**
		 * 阈值
		 * 
		 * @param n(N取值为-255到255)
		 * @return 
		 * 
		 */
		public static function createThresholdFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter([0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
				0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
				0.3086*256,	0.6094*256,	0.0820*256,	0,	-256*n,
				0, 0, 0, 1, 0]);
		}
		
		/**
		 * 高斯模糊滤镜
		 *  
		 * @return 
		 * 
		 */
		public static function createGaussFilter():ConvolutionFilter
		{
			var matrix:Array = [1, 2, 1, 
				2, 4, 2, 
				1, 2, 1];
			return new ConvolutionFilter(3,3,matrix,16);
		}
		
		/**
		 * 锐化滤镜
		 * 
		 * @return 
		 * 
		 */
		public static function createSharpeFilter():ConvolutionFilter
		{
			var matrix:Array = [-1, -1, -1, 
				-1, 9, -1, 
				-1, -1, -1];
			return new ConvolutionFilter(3,3,matrix);
		}
		
		/**
		 * 查找边缘滤镜
		 * 
		 * @return 
		 * 
		 */
		public static function createEdgeFilter():ConvolutionFilter
		{
			var matrix:Array = [-2, -4, -4, -4, -2, 
				-4, 0, 8, 0, -4, 
				-4, 8, 24, 8, -4, 
				-4, 0, 8, 0, -4, 
				-2, -4, -4, -4, -2];
			return new ConvolutionFilter(5, 5, matrix);
		}
		
		/**
		 * 以红绿通道生成渐进变化的色圆。
		 * 
		 * @return 
		 * 
		 */
		public static function createBubbleMask(radius:Number = 128):BitmapData
		{
			var data:BitmapData = new BitmapData(radius*2,radius*2,false);
			for (var x:int = -radius; x<radius; x++)
			{
				for (var y:int = -radius; y<radius; y++) 
				{
					var i:Number = x/radius*128;//数据规整到256方便运算
					var j:Number = y/radius*128;
					var l:Number = new Point(i,j).length;
					var color:uint;
					if (l<=128)
					{
						if (l>100)//在圆外圈
						{
							color = int(i*Math.sqrt(128*128-l*l)/80+128)<<16;
							color += int(j*Math.sqrt(128*128-l*l)/80+128)<<8;
							color += int(Math.sqrt(128*128-l*l)*0.7*Math.sqrt(128*128-l*l)/80);
							color += 128;
						}
						else //原的内部
							color = ((i+128)<<16)+((j+128)<<8)+int(Math.sqrt(128*128-l*l)*0.7)+128;
					}
					else
						color = 0x808080;//中性灰
					
					data.setPixel(x+radius,y+radius,color);
				}
			}
			return data;
		}
		
		/**
		 * 生成水波遮罩
		 * 
		 * @param radius	半径
		 * @param cycle		周期数
		 * @param shapeType	0.圆形，1.水平矩形，2.垂直矩形
		 * @return 
		 * 
		 */
		public static function createWaveMask(radius:Number = 128,cycle:int = 5, shapeType:int = 0):BitmapData
		{
			var shape:Shape = new Shape();
			var colors:Array = [];
			var alphas:Array = [];
			var ratios:Array = [];
			
			for (var i:int = 0;i< cycle;i++)
			{
				colors.push(0x0,0xFFFFFF);
				alphas.push(1.0,1.0);
				var step:Number = 255/cycle * i;
				ratios.push(step,step + 255/cycle/2);
			}
			colors.push(0x808080);
			alphas.push(1.0);
			ratios.push(255);
			
			var m:Matrix = new Matrix();
			m.createGradientBox(radius + radius,radius + radius);
			if (shapeType == 0)
			{
				shape.graphics.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawCircle(radius,radius,radius);
			}
			else if (shapeType == 1)
			{
				shape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawRect(0,0,radius + radius,radius + radius); 
			}
			else if (shapeType == 2)
			{
				m.rotate(90);
				shape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
				shape.graphics.drawRect(0,0,radius + radius,radius + radius); 
			}
			var data:BitmapData = new BitmapData(radius + radius,radius + radius,false,0x808080);
			data.draw(shape);
			return data;
		}
		
		/**
		 * 放大镜（水泡）效果
		 * 
		 * @param bitmapData	水泡遮罩，需由createBubbleMask方法生成
		 * @param pos	水泡中心坐标
		 * @param deep	凹进的幅度（负值为凸出）
		 * @return 
		 * 
		 */		
		public static function createBubbleFilter(bitmapData:BitmapData, pos:Point=null,deep:Number = -128):DisplacementMapFilter
		{
			if (!pos)
				pos = new Point()
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
		
		/**
		 * 同心水波效果
		 * 
		 * @param bitmapData	水波遮罩，需由createWaveMask方法生成
		 * @param pos	水波中心坐标
		 * @param deep	波幅
		 * @return 
		 * 
		 */		
		public static function createWaveFilter(bitmapData:BitmapData, pos:Point=null,deep:Number = 9):DisplacementMapFilter
		{
			if (!pos)
				pos = new Point()
			return new DisplacementMapFilter(bitmapData,pos,BitmapDataChannel.RED,BitmapDataChannel.GREEN,deep,deep)
		}
		
		public static function createHMask(width:Number,height:Number):BitmapData
		{
			var w:Number = Math.ceil(width);
			var h:Number = Math.ceil(height);
			var data:BitmapData = new BitmapData(w * 2,h * 2,false);
			var hw:Number = w/2;
			var hh:Number = h/2;
			var dc:Number = 0x80 / hw / hh;
			for (var i:int = 0;i < w * 2;i++)
			{
				for (var j:int = 0;j < h * 2;j++)
				{
					var g:int = MathUtil.limitIn(0x80 - (hw - (i - hw)) * (hh - (j - hh)) * dc, 0, 0xFF);
					var r:int = MathUtil.limitIn(0xFF * (i - hw) / w, 0, 0xFF);
					data.setPixel(i,j,r << 16 | g << 8);
				}
			}
			
			return data;
		}
		
		public static function createVMask(width:Number,height:Number):BitmapData
		{
			var w:Number = Math.ceil(width);
			var h:Number = Math.ceil(height);
			var data:BitmapData = new BitmapData(w * 2,h * 2,false);
			var hw:Number = w/2;
			var hh:Number = h/2;
			var dc:Number = 0x80 / hw / hh;
			for (var i:int = 0;i < w * 2;i++)
			{
				for (var j:int = 0;j < h * 2;j++)
				{
					var g:int = MathUtil.limitIn(0x80 - (hw - (i - hw)) * (hh - (j - hh)) * dc, 0, 0xFF);
					var r:int = MathUtil.limitIn(0xFF * (j - hh) / h, 0, 0xFF);
					data.setPixel(i,j,r << 16 | g << 8);
				}
			}
			
			return data;
		}
		
		/**
		 * 弯曲滤镜
		 * @param bitmapData
		 * @param rotation
		 * @return 
		 * 
		 */		
		public static function createHFilter(bitmapData:BitmapData, rotation:Number):DisplacementMapFilter
		{
			var dx:Number = Math.min(2500,Math.abs(bitmapData.width * Math.tan(rotation / 180 * Math.PI)));
			var dy:Number = bitmapData.height * Math.sin(rotation / 180 * Math.PI);
			var p:Point = new Point(-bitmapData.width/4,-bitmapData.height/4);
			return new DisplacementMapFilter(bitmapData,p,BitmapDataChannel.RED,BitmapDataChannel.GREEN,dx,dy,DisplacementMapFilterMode.COLOR)
		}
		
		/**
		 * 弯曲滤镜
		 * @param bitmapData
		 * @param rotation
		 * @return 
		 * 
		 */		
		public static function createVFilter(bitmapData:BitmapData, rotation:Number):DisplacementMapFilter
		{
			var dx:Number = bitmapData.width * Math.sin(rotation / 180 * Math.PI);
			var dy:Number = Math.min(2500,Math.abs(bitmapData.height * Math.tan(rotation / 180 * Math.PI)));
			var p:Point = new Point(-bitmapData.width/4,-bitmapData.height/4);
			return new DisplacementMapFilter(bitmapData,p,BitmapDataChannel.GREEN,BitmapDataChannel.RED,dx,dy,DisplacementMapFilterMode.COLOR)
		}
		
		public static function setBrightness(obj:DisplayObject,value:Number):void
		{    
			var colorTransformer:ColorTransform = obj.transform.colorTransform    
			var backup_filters:* = obj.filters;
			if (value >= 0) {        
				colorTransformer.blueMultiplier = 1-value        
				colorTransformer.redMultiplier = 1-value        
				colorTransformer.greenMultiplier = 1-value        
				colorTransformer.redOffset = 255*value       
				colorTransformer.greenOffset = 255*value        
				colorTransformer.blueOffset = 255*value    
			}
			else
			{       
				value=Math.abs(value)        
				colorTransformer.blueMultiplier = 1-value        
				colorTransformer.redMultiplier = 1-value        
				colorTransformer.greenMultiplier = 1-value        
				colorTransformer.redOffset = 0        
				colorTransformer.greenOffset = 0        
				colorTransformer.blueOffset = 0 
			}　　
			obj.transform.colorTransform = colorTransformer　　
			obj.filters = backup_filters
		}
	}
}