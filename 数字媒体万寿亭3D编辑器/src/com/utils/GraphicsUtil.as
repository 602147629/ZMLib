package com.utils
{
	import flash.display.Graphics;
	
	/**
	 * 绘制各种矢量图形的'工具类' 可绘制环形，正三角形，正多边形，正星形
	 */	
	public class GraphicsUtil
	{
		/**
		 * 绘制环形
		 * @param g 目标笔刷
		 * @param minR 短半径
		 * @param maxR 长半径
		 * @param color 颜色
		 */		
		public static function drawConCircle(g:Graphics,
											 minR:Number,maxR:Number,color:uint = 0):void{
			g.clear();
			g.beginFill(color);
			g.drawCircle(0,0,minR);
			g.drawCircle(0,0,maxR);
			g.endFill();
		}
		/**
		 * 绘制正三角形 按照圆周公式计算三个顶点对应占用的角度值
		 * 换算成顶点坐标 然后进行画线封闭填充。。。
		 * @param g 笔刷
		 * @param r 半径
		 * @param color 颜色
		 */		
		public static function drawTriangle(g:Graphics,
											r:Number,color:uint = 0):void{
			drawRegularPolygon(g,3,r,color);
			//			var sides:int = 6;
			//			g.clear();
			//			g.lineStyle(2,0xFFFF00);
			//			g.drawCircle(0,0,r);
			//			g.endFill();
		}
		/**
		 * 绘制正多边形 判断sides是否合法 不合法抛出错误
		 * @param g
		 * @param sides
		 * @param r
		 * @param color
		 */		
		public static function drawRegularPolygon(g:Graphics,
						sides:int,r:Number,color:uint = 0):void{
			if(sides <= 2){
				throw Error('扯犊子呢，有特么' + sides + '边形吗?');
			}
			g.clear();
			g.beginFill(color);//开始填充
			for (var i:int = 0; i < sides; i++) 
			{//遍历所有顶点画线
				var angle:int = 360 / sides * i;
				//计算每个顶点分到的角度
				var x:Number = r * Math.sin(angle / 180 * Math.PI);
				var y:Number = -r * Math.cos(angle / 180 * Math.PI);
				//通过圆周公式换算成坐标
				if(i == 0){
					g.moveTo(x,y);//第一次是移动坐标
				}else{
					g.lineTo(x,y);//之后是绘制直线
				}
			}
			g.endFill();//结束填充
		}
		/**
		 * 绘制星形图形 传入内外顶点的外接圆半径 交替计算内外顶点连线
		 * 注:内外顶点偏移角度 360 / sides / 2;
		 * @param g
		 * @param sides
		 * @param minR 内顶点外接圆半径
		 * @param maxR 外顶点外接圆半径
		 * @param color
		 */		
		public static function drawRegularStar(g:Graphics,
				sides:int,minR:Number,maxR:Number,color:uint = 0):void{
			if(sides <= 2){
				throw Error('扯犊子呢，有特么' + sides + '角星形吗?');
			}
			g.clear();
			g.beginFill(color);//开始填充
			var offA:Number = 360 / sides / 2;//计算内外顶点偏移角度
			//----逻辑-----
			for (var i:int = 0; i < sides; i++) 
			{
				var angle:int = 360 / sides * i;
				//计算每个顶点分到的角度
				var x1:Number = maxR * Math.sin(angle / 180 * Math.PI);
				var y1:Number = -maxR * Math.cos(angle / 180 * Math.PI);
				//通过圆周公式换算成坐标 外顶点坐标(x1,y1)
				if(i == 0){
					g.moveTo(x1,y1);
				}else{
					g.lineTo(x1,y1);
				}
				//--------- 内外交替连线 ----------
				var x2:Number = minR * Math.sin(
					(angle + offA) / 180 * Math.PI);
				var y2:Number = -minR * Math.cos(
					(angle + offA) / 180 * Math.PI);
				//内顶点坐标(x2,y2)
				g.lineTo(x2,y2);
			}
			g.endFill();
		}
//		
//		public static function aaa():void{
//			
//		}
		
		
	}
}