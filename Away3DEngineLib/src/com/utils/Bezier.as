package com.utils
{
	import flash.geom.Point;

	public class Bezier
	{
		public function Bezier()
		{
		}
		//  对外变量
		private var sp:Point;// 起点
		private var cp1:Point;// 控制点
		private var cp2:Point;// 控制点
		private var ep:Point;// 终点
		private var _count:uint;// 分割份数
		public function get count():uint
		{
			return _count;
		}
		/**
		 * 二次贝塞尔
		 * @param startPoint
		 * @param endPoint
		 */		
		public function initTwice(startPoint:Point,endPoint:Point,cPoint1:Point,count:uint):void{
			this.sp = startPoint;
			this.ep = endPoint;
			this.cp1 = cPoint1;
			this.cp2 = null;//表示二次
			this._count = count;//分割的份数
		}
		/**
		 * 三次贝塞尔
		 * @param startPoint
		 * @param endPoint
		 */		
		public function initThird(startPoint:Point,endPoint:Point,cPoint1:Point,cPoint2:Point,count:uint):void{
			this.sp = startPoint;
			this.ep = endPoint;
			this.cp1 = cPoint1;
			this.cp2 = cPoint2;//表示三次
			this._count = count;//分割的份数
		}
		/**
		 * 获取到第几步
		 * @param step
		 * @return 
		 */		
		public function getStepPoint(step:int):Point{
			var t:Number = step / count;
			if(cp2 == null){
				return getTwicePoint(t,sp,cp1,ep);
			}
			return getThirdPoint(t,sp,cp1,cp2,ep);
		}
		/**
		 * 获取两点之间距离
		 * @return 
		 */		
		public function getLength():Number{
			var len:Number = 0;
			for (var i:int = 0; i < _count; i++) 
			{
				var np:Point = getStepPoint(i + 1);
				if(i == 0){
					var num:Number = getDistance(sp.x,sp.y,np.x,np.y);
				}else{
					var pp:Point = getStepPoint(i);
					num = getDistance(pp.x,pp.y,np.x,np.y);
				}
				len += num;
			}
			return len;
		}
		
		public static function getDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number{
			return Math.sqrt(Math.pow(x1 - x2,2) + Math.pow(y1 - y2,2));
		}
		
		private static function getTwicePoint(t:Number,p1:Point,p2:Point,p3:Point):Point{
			var lineX:Number = Math.pow((1-t),2)*p1.x+2*t*(1-t)*p2.x + Math.pow(t,2)*p3.x;
			var lineY:Number = Math.pow((1-t),2)*p1.y+2*t*(1-t)*p2.y + Math.pow(t,2)*p3.y;
			return new Point(lineX,lineY);
		}
		
		private static function getThirdPoint(t:Number,p1:Point,p2:Point,p3:Point,p4:Point):Point{
			var lineX:Number = Math.pow((1-t),3)*p1.x + 3*p2.x*t*(1-t)*(1-t) + 3*p3.x*t*t*(1-t) + p4.x * Math.pow(t,3);
			var lineY:Number = Math.pow((1-t),3)*p1.y + 3*p2.y*t*(1-t)*(1-t) + 3*p3.y*t*t*(1-t) + p4.y * Math.pow(t,3);
			return new Point(lineX,lineY);
		}
	}
}