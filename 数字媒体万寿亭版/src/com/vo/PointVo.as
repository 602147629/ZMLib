package com.vo
{
	public class PointVo
	{
		public function PointVo(x:Number,z:Number,area:int){
			this.x = x;
			this.z = z;
			this.area = area;
		}
		public var index:int;
		public var x:Number;//坐标
		public var z:Number;
		public var area:int;//所属区域
	}
}