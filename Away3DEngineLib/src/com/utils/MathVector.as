package com.utils
{
	import flash.geom.Point;

	/**
	 * 标准数学向量
	 * @author Administrator
	 */	
	public class MathVector
	{
		public function MathVector(sp:Point = null,ep:Point = null)
		{
			_startPoint = sp;
			_endPoint = ep;
			if(sp != null && ep != null){
				_valueX = ep.x - sp.x;
				_valueY = ep.y - sp.y;
			}
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
		private var _valueX:Number;//x方向的值
		public function get valueX():Number
		{
			return _valueX;
		}
		private var _valueY:Number;//y方向的值
		public function get valueY():Number
		{
			return _valueY;
		}
		public function get valuePoint():Point{
			return new Point(_valueX,_valueY);
		}
		/**
		 * 和目标向量计算向量积(叉积)
		 * @param m
		 * @return 
		 */		
		public function getProduct(m:MathVector):Number{
			return _valueX * m.valueY - _valueY * m.valueX;
		}
		
		public function equalsValue(m:MathVector):Boolean{
			return m.valueX == _valueX && m.valueY == _valueY;
		}
		/**
		 * 首末位置都相同
		 * @param m
		 * @return 
		 */		
		public function equalsPoint(m:MathVector):Boolean{
			return _startPoint.equals(m.startPoint) && _endPoint.equals(m.endPoint);
		}
		
		private var _mathLine:MathLine;
		/**
		 * 将向量转换成直线方程
		 * @return 
		 */		
		public function getMathLine():MathLine{
			if(_mathLine == null)_mathLine = MathLine.createByPoint(_startPoint,_endPoint);
			return _mathLine;
		}
		/**
		 * 根据两个点创建向量
		 * @param sp
		 * @param ep
		 * @return 
		 */		
		public static function createByPoint(sp:Point,ep:Point):MathVector{
			var mv:MathVector = new MathVector(sp,ep);
			return mv;
		}
		
		
		
		
	}
}