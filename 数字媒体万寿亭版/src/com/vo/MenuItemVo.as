package com.vo
{
	public class MenuItemVo
	{
		public var id:int;//连接服务器方法的id参数
//		public var parentId:int;//父节点id
		public var attribute:int;//蔬菜种类字段
		
		public var menuVo:MenuVo;//父节点的数据
		public var large:String;//大图地址
		public var label:String;
		public var view:Class;//跳转界面的类型
		public var typeID:String;//界面类型id
		public var itemWidth:Number = 0;//该节点宽度
		public var icon:String;//图标地址
		public var normalColor:uint;
		public var selectColor:uint;
	}
}