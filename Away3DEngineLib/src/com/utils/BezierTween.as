package com.utils
{
	import flash.geom.Point;

	public class BezierTween
	{
		private var bt:Bezier;
		private var _fps:int;
		public function get fps():int
		{
			return _fps;
		}

		private var value:Number;
		/**
		 * 初始化缓动数据
		 * @param value 需要缓动的值
		 * @param fps 需要多少帧走完
		 */		
		public function BezierTween(value:Number,fps:int)
		{
			this._fps = fps;
			this.value = value;
			
			bt = new Bezier();
			
			initBezier();
		}
		
		private function initBezier():void
		{
			var startPoint:Point = new Point(0,0);
			
			var endPoint:Point = new Point(_fps,value);
			
//			var controlPoint1:Point = new Point(_fps * 2 / 3, .05 * value);
			var controlPoint1:Point = new Point(_fps * 1 / 3, .1 * value);
			var controlPoint2:Point = new Point(0, value);
//			var controlPoint2:Point = new Point(_fps * 1 / 3, value);
			
			bt.initThird(startPoint,endPoint,controlPoint1,controlPoint2,_fps * 3);
			//采样点宁愿多一点
		}
		
		private var valueYList:Vector.<Number>;
		/**
		 * 通过每一帧获取对应的数据
		 * @param step 每一步的fps:从1开始
		 * @return
		 */		
		public function getValueYByStep(step:int):Number{
			initYList();
			return valueYList[step - 1];
		}
		
		private function initYList():void{
			if(valueYList == null || valueYList == null){
				valueYList = new Vector.<Number>();
				rateYList = new Vector.<Number>();
				var preY:Number;
				for (var i:int = 0; i < _fps; i++) 
				{
					var x:Number = i + 1;
					var y:Number = bt.getValueByX(x);
					if(i == 0){
						var interY:Number = y;
					}else{
						interY = y - preY;
					}
					valueYList.push(y);
					rateYList.push(interY.toFixed(1));
					preY = y;//记录前一个位置的y坐标
				}
			}
		}
		
		private var rateYList:Vector.<Number>;
		/**
		 * 通过每一帧获取对应数据的间隔比值
		 * @param step 每一步的fps:从1开始
		 * @return 
		 */		
		public function getRateYByStep(step:int):Number{
			initYList();
			return rateYList[step - 1];
		}
		
		
	}
}