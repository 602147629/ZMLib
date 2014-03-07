package com.model
{
	import com.screen.InfoScreen;
	import com.screen.MapScreen;
	import com.screen.MerchScreen;
	import com.vo.MenuVo;

	public class MenuXMLData
	{
//		public static function getScreenClass(typeID:String):Class{
//			switch(typeID){
//				case FarmDataBase.DATA_NORMAL:
//					return NormalScreen;
//					break;
//				case FarmDataBase.DATA_PERSON:
//					return PersonScreen;
//					break;
//				case FarmDataBase.DATA_MERCH:
//					return MerchScreen;
//					break;
//				case FarmDataBase.DATA_FOOD:
//					return FoodScreen;
//					break;
//				case FarmDataBase.DATA_TRACE:
//					return TraceScreen;
//					break;
//				case FarmDataBase.DATA_VIP:
//					return VipScreen;
//					break;
//			}
//			return NormalScreen;
//		}
		public static const EDIT_MAP_ID:int = 1;
		
		private static var _menuBarSource:Array = [
			{id:EDIT_MAP_ID,label:"地图编辑",view:MapScreen,normalColor:0x5f9b2a,selectColor:0x3e720d,icon:"assets/menu/icon04.png"},
			{id:2,label:"公共设施编辑",view:MerchScreen,normalColor:0xe15757,selectColor:0xb70005,icon:"assets/menu/icon02.png"},
			{id:3,label:"商户信息编辑",view:InfoScreen,normalColor:0x50b5e1,selectColor:0x0892b7,icon:"assets/menu/icon03.png"}
		];
		public static function get menuBarSource():Array
		{
			return _menuBarSource;
		}
		public static function set menuBarSource(value:Array):void
		{
			_menuBarSource = value;
		}
		public static function get menuLength():uint{
			return _menuBarSource.length;
		}
		private static var menuList:Vector.<MenuVo>;
		/**
		 * 获取菜单栏数组
		 * @return 
		 */		
		public static function getMenuList():Vector.<MenuVo>{
			if(menuList == null){
				createMenuList();
			}
			return menuList;
		}
		private static function createMenuList():void
		{
			menuList = new Vector.<MenuVo>();
			for (var i:int = 0; i < _menuBarSource.length; i++) 
			{
				var mvo:MenuVo = new MenuVo();
				mvo.id = _menuBarSource[i].id;
				mvo.label = _menuBarSource[i].label;
				mvo.normalColor = _menuBarSource[i].normalColor;
				mvo.selectColor = _menuBarSource[i].selectColor;
				mvo.icon = _menuBarSource[i].icon;
				mvo.view = _menuBarSource[i].view;
				menuList.push(mvo);
			}
		}
		
		public static function getMenuVo(id:int):MenuVo{
			var mList:Vector.<MenuVo> = getMenuList();
			for each (var mvo:MenuVo in mList) 
			{
				if(mvo.id == id){
					return mvo;
				}
			}
			return null;
		}
		
	}
}