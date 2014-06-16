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
		 * 通过索引位置获取前后两点的距离
		 * @param index
		 * @return 
		 */		
		public function getStepDistance(index:int):Number{
			var np:Point = getStepPoint(index + 1);
			if(index == 0){
				var num:Number = getDistance(sp.x,sp.y,np.x,np.y);
			}else{
				var pp:Point = getStepPoint(index);
				num = getDistance(pp.x,pp.y,np.x,np.y);
			}
			return num;
		}
		/**
		 * 获取两点之间距离
		 * @return 
		 */		
		public function getLength():Number{
			var len:Number = 0;
			for (var i:int = 0; i < _count; i++) 
			{
				var num:Number = getStepDistance(i);
				len += num;
			}
			return len;
		}
		
		private static function getDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number{
			return Math.sqrt(Math.pow(x1 - x2,2) + Math.pow(y1 - y2,2));
		}
		
		private static function getTwicePoint(t:Number,p1:Point,p2:Point,p3:Point):Point{
//			var lineX:Number = Math.pow((1-t),2)*p1.x+2*t*(1-t)*p2.x + Math.pow(t,2)*p3.x;
//			var lineY:Number = Math.pow((1-t),2)*p1.y+2*t*(1-t)*p2.y + Math.pow(t,2)*p3.y;
			var lineX:Number = getTwiceVauleByTime(t,p1,p2,p3,"x");
			var lineY:Number = getTwiceVauleByTime(t,p1,p2,p3,"y");
			return new Point(lineX,lineY);
		}
		
		private static function getThirdPoint(t:Number,p1:Point,p2:Point,p3:Point,p4:Point):Point{
//			var lineX:Number = Math.pow((1-t),3)*p1.x + 3*p2.x*t*(1-t)*(1-t) + 3*p3.x*t*t*(1-t) + p4.x * Math.pow(t,3);
//			var lineY:Number = Math.pow((1-t),3)*p1.y + 3*p2.y*t*(1-t)*(1-t) + 3*p3.y*t*t*(1-t) + p4.y * Math.pow(t,3);
			var lineX:Number = getThirdVauleByTime(t,p1,p2,p3,p4,"x");
			var lineY:Number = getThirdVauleByTime(t,p1,p2,p3,p4,"y");
			return new Point(lineX,lineY);
		}
		
		public function getVauleByTime(t:Number,key:String = "y"):Number{
			if(cp2 == null){
				return getTwiceVauleByTime(t,sp,cp1,ep,key);
			}
			return getThirdVauleByTime(t,sp,cp1,cp2,ep,key);
		}
		
		private static function getTwiceVauleByTime(t:Number,p1:Point,p2:Point,p3:Point,
													key:String):Number{
			return Math.pow((1-t),2)*p1[key]+2*t*(1-t)*p2[key] + Math.pow(t,2)*p3[key];
		}
		private static function getThirdVauleByTime(t:Number,p1:Point,p2:Point,p3:Point,
													p4:Point,key:String):Number{
			return Math.pow((1-t),3)*p1[key] + 3*p2[key]*t*(1-t)*(1-t) + 3*p3[key]*t*t*(1-t) + p4[key] * Math.pow(t,3);
		}
		/**
		 * 通过贝塞尔方程 由已知的x坐标换算y坐标
		 * @param x
		 * @return 
		 */		
		public function getValueByX(x:Number):Number{
			var ml:MathLine = getLineEquation(x);
			if(ml != null){
				return ml.getVauleByX(x);
			}
			return 0;
		}
		
		private function getLineEquation(x:Number):MathLine{
			for(var i:int = 0 ; i < _count ; i ++)
			{
				var np:Point = getStepPoint(i + 1);
				if(i == 0){
					var pp:Point = sp;
				}else{
					pp = getStepPoint(i);
				}
				if(x > pp.x && x <= np.x){//夹在两者之间
					return MathLine.createByPoint(pp,np);
				}
			}
			return null;
		}
		
		
	}
}