package soul.utils
{
	import flash.display.Graphics;

	public class GraphicsUtil
	{
		public static function drawDash (graphics:Graphics,x1:Number,y1:Number,x2:Number,y2:Number,color:uint = 0x000000,alpha:Number = 1,dash:Number=8,ed:Number=2):void
		{
			//计算起点终点连续的角度
			var angle:Number = Math.atan2(y2 - y1,x2 - x1);
			//步长，每次循环改变的长度
			var step:Number = dash + ed;
			//每段实线水平和竖直长度
			var dashx:Number = dash * Math.cos(angle);
			var dashy:Number = dash * Math.sin(angle);
			//每段虚线水平和竖直长度
			var edx:Number = ed * Math.cos(angle);
			var edy:Number = ed * Math.sin(angle);
			//每段实线和虚线的水平和垂直长度
			var stepx:Number = step * Math.cos(angle);
			var stepy:Number = step * Math.sin(angle);
			//起点和终点的距离
			var _length:Number = Math.sqrt(Math.pow(x2 - x1,2) + Math.pow(y2 - y1,2));
			//定义线条样式
			graphics.lineStyle (1,color,alpha);
			//使用循环，逐段绘制
			for (var i:Number=step,px:Number=x1,py:Number=y1; i<_length; i+=step) {
				graphics.moveTo (px+edx,py+edy);
				graphics.lineTo (px+dashx,py+dashy);
				//循环递归
				px+=stepx;
				py+=stepy;
			}
		}
		
		public static function drawCircleDash(graphics:Graphics,x1:Number,y1:Number,x2:Number,y2:Number,color:uint = 0x000000,alpha:Number = 1,radius:Number=2,ed:Number=2):void
		{
			var angle:Number = Math.atan2(y2 - y1,x2 - x1);
			var step:Number = radius*2 + ed;
			var dashx:Number = radius*2 * Math.cos(angle);
			var dashy:Number = radius*2 * Math.sin(angle);
			var edx:Number = ed * Math.cos(angle);
			var edy:Number = ed * Math.sin(angle);
			var stepx:Number = step * Math.cos(angle);
			var stepy:Number = step * Math.sin(angle);
			var _length:Number = Math.sqrt(Math.pow(x2 - x1,2) + Math.pow(y2 - y1,2));
			for (var i:Number=step,px:Number=x1,py:Number=y1; i<_length; i+=step) {
				graphics.beginFill(color,alpha)
				graphics.drawCircle(px+edx,py+edy,radius)
				//循环递归
				px+=stepx;
				py+=stepy;
			}
		}
	}
}