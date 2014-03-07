package com.vo
{
	public class FloorInfoVo
	{
		public var id:String;//楼层的标记名称
		public var postion:PointVo;//楼层的寻路坐标点
		
		public function addFloorPos(x:Number,z:Number,area:int):void{
			if(postion == null)postion = new PointVo(0,0,area);
			postion.x = x;
			postion.z = z;
			postion.area = area;
		}
	}
}