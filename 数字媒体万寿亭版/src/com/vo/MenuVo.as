package com.vo
{
	public class MenuVo
	{
		public var id:int;//父类别id
		public var label:String;
		public var normalColor:uint;
		public var selectColor:uint;
		public var typeID:String;//界面类型id
		public var items:Vector.<MenuItemVo>;//子项目选项
		public var icon:String;//图标
		public var stand:Class;//待机停留界面
		public var link:String;//链接的网址
	}
}