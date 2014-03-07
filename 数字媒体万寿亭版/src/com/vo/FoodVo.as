package com.vo
{
	import com.model.FarmDataBase;

	public class FoodVo
	{
		public var id:int;//网络数据id
		public var icon:String;
		public var name:String;
		public var price:Number;//价格
		public var selectType:String = FarmDataBase.TYPE_PRICE;
	}
}