package com.utils
{
	import flash.geom.Point;

	/**
	 * 标准直线
	 * Ax + By + C = 0;直线方程
	 * (y2 - y1)X + (x1 - x2)Y + (x2y1 - x1y2) = 0;
	 * @author Administrator
	 */	
	public class MathLine
	{
		public function MathLine(sp:Point = null,ep:Point = null)
		{
			_startPoint = sp;
			_endPoint = ep;
			if(sp != null && ep != null){
				_valueA = ep.y - sp.y;
				_valueB = sp.x - ep.x;
				_valueC = ep.x * sp.y - sp.x * ep.y;
			}
		}
		
		private var _valueA:Number;
		public function get valueA():Number
		{
			return _valueA;
		}
		private var _valueB:Number;
		public function get valueB():Number
		{
			return _valueB;
		}
		private var _valueC:Number;
		public function get valueC():Number
		{
			return _valueC;
		}
		
		private var _startPoint:Point;
		public function get startPoint():Point
		{
			return _startPoint;
		}
		private var _endPoint:Point;
		public function get endPoint():Point
		{
			return _endPoint;
		}
		/**
		 * 把某个坐标带入直线方程的计算结果 主要还是用来判断某点是处于该直线的同侧异测
		 * @return 
		 */		
		public function getPointResult(x:Number,y:Number):Number{
			return _valueA * x + _valueB * y + _valueC;
		}
		
		/**
		 * 检测两个点是否位于该直线的同侧
		 * @param p1
		 * @param p2
		 * @return 
		 */		
		public function isSameSide(p1:Point,p2:Point):Boolean{
			var r1:Number = getPointResult(p1.x,p1.y);
			var r2:Number = getPointResult(p2.x,p2.y);
			return r1 * r2 >= 0;//异测的符号不相等 积<0
		}
		
		/**
		 * 和另外一条直线的交叉点
		 * @param ml
		 * @return 
		 */		
		public function getLineCrossPoint(ml:MathLine):Point{
			var y:Number = (_valueA * ml.valueC  - ml.valueA * _valueC) / 
				(ml.valueA * _valueB - _valueA * ml.valueB);
			var x:Number = (_valueB * ml.valueC - ml.valueB * _valueC) / 
				(ml.valueB * _valueA - _valueB * ml.valueA);
			return new Point(x,y);
		}
		/**
		 * 根据两个点创建向量
		 * @param sp
		 * @param ep
		 * @return 
		 */		
		public static function createByPoint(sp:Point,ep:Point):MathLine{
			var ml:MathLine = new MathLine(sp,ep);
			return ml;
		}
	}
}