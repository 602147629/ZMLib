package com.model
{
	import com.manager.Vision;
	import com.screen.BlankScreen;
	import com.screen.FoodScreen;
	import com.screen.FoodStandScreen;
	import com.screen.GovernStandScreen;
	import com.screen.MarketStandScreen;
	import com.screen.MerchScreen;
	import com.screen.MerchStandScreen;
	import com.screen.NormalScreen;
	import com.screen.PersonScreen;
	import com.screen.PersonStandScreen;
	import com.screen.TraceScreen;
	import com.screen.TraceStandScreen;
	import com.screen.VipScreen;
	import com.screen.WaitScreen;
	import com.vo.MenuItemVo;
	import com.vo.MenuVo;
	
	public class MenuXMLData
	{
		public static function getScreenClass(typeID:String):Class{
			switch(typeID){
				case FarmDataBase.DATA_NORMAL:
					return NormalScreen;
					break;
				case FarmDataBase.DATA_PERSON:
					return PersonScreen;
					break;
				case FarmDataBase.DATA_MERCH:
					return MerchScreen;
					break;
				case FarmDataBase.DATA_FOOD:
					return FoodScreen;
					break;
				case FarmDataBase.DATA_TRACE:
					return WaitScreen;//追溯功能更新中
					//					return TraceScreen;
					break;
				case FarmDataBase.DATA_VIP:
					return VipScreen;
					break;
				case FarmDataBase.DATA_LINK:
					return BlankScreen;
					break;
			}
			return WaitScreen;
		}
		//[1,2,3,4,5,6]
		public static function getStandClass(standID:String):Class{
			switch(standID){
				case "1":return PersonStandScreen;//工作人员
				case "2":return GovernStandScreen;
				case "3":return MarketStandScreen;
				case "4":return MerchStandScreen;
				case "5":return FoodStandScreen;
				case "6":return TraceStandScreen;
			}
			return FoodStandScreen;//默认农残检测
		}
		
		private static var _menuBarSource:Array = [
			//			{id:1,label:"首页",normalColor:0xe15757,selectColor:0xb70005,icon:"assets/menu/icon01.png"},
			{id:2,label:"政府",normalColor:0xd89c9c,selectColor:0xe05757,icon:"assets/menu/icon02.png",
				stand:GovernStandScreen,
				items:[
					{id:10,label:"领导关怀",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:11,label:"行业规范",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:12,label:"通知公告",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL}
				]},
			{id:3,label:"市场",normalColor:0x84bbce,selectColor:0x50b5e0,icon:"assets/menu/icon03.png",
				stand:MarketStandScreen,
				items:[
					{id:13,label:"市场简介",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:14,label:"市场荣誉",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:15,label:"管理制度",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:16,label:"安全承诺",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:17,label:"管理人员",view:PersonScreen,typeID:FarmDataBase.DATA_PERSON},
					{id:18,label:"消防安全",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL}
				]},
			{id:4,label:"商户",normalColor:0x4cbfb1,selectColor:0x019e97,icon:"assets/menu/icon04.png",
				stand:MerchStandScreen,
				items:[
					{id:19,label:"蔬菜",view:MerchScreen,typeID:FarmDataBase.DATA_MERCH},
					{id:20,label:"肉类",view:MerchScreen,typeID:FarmDataBase.DATA_MERCH},
					{id:21,label:"水产",view:MerchScreen,typeID:FarmDataBase.DATA_MERCH},
					{id:22,label:"粮油",view:MerchScreen,typeID:FarmDataBase.DATA_MERCH},
					{id:23,label:"干货",view:MerchScreen,typeID:FarmDataBase.DATA_MERCH}
				]},
			{id:5,label:"菜价",normalColor:0x88ba8d,selectColor:0x39b44a,icon:"assets/menu/icon05.png",
				stand:FoodStandScreen,
				items:[
					{id:24,label:"蔬菜",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
					{id:25,label:"肉类",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
					{id:26,label:"水产",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
					{id:27,label:"粮油",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
					{id:28,label:"干货",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD}
				]},
			{id:6,label:"追溯",normalColor:0xd8a97d,selectColor:0xf9a92c,icon:"assets/menu/icon06.png",
				stand:TraceStandScreen,
				items:[
					{id:29,label:"追述商户",view:TraceScreen,typeID:FarmDataBase.DATA_TRACE},
					{id:30,label:"追述源头",view:TraceScreen,typeID:FarmDataBase.DATA_TRACE}
				]},
			{id:7,label:"科普",normalColor:0x8ed3f0,selectColor:0x8ed3f0,icon:"assets/menu/icon07.png",
				items:[
					{id:31,label:"食品安全",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:32,label:"健康饮食",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:33,label:"生活窍门",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL}
				]},
			{id:8,label:"会员",normalColor:0x96ad5e,selectColor:0xd1bd09,icon:"assets/menu/icon08.png",
				items:[
					{id:34,label:"办卡细节",view:VipScreen,typeID:FarmDataBase.DATA_VIP},
					{id:35,label:"使用说明",view:VipScreen,typeID:FarmDataBase.DATA_VIP},
					{id:36,label:"会员活动",view:VipScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:37,label:"会员登录",view:VipScreen,typeID:FarmDataBase.DATA_WAIT}
				]},
			{id:9,label:"服务",normalColor:0xa6ce65,selectColor:0x8cc63f,icon:"assets/menu/icon09.png",
				items:[
					{id:38,label:"家政",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:39,label:"保姆",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:40,label:"公平秤",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:41,label:"水费",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:42,label:"电费",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:43,label:"煤费",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL},
					{id:44,label:"话费",view:NormalScreen,typeID:FarmDataBase.DATA_NORMAL}
				]}
		]
		
		public static function get menuBarSource():Array
		{
			return _menuBarSource;
		}
		public static function set menuBarSource(value:Array):void
		{
			_menuBarSource = value;
		}
		//		private static var menubarXML:XML =
		//			<root>
		//					<menu label="首页">
		//					</menu>
		//					<menu label="政府">
		//							<menuItem id="m1" label="领导关怀" />
		//							<menuItem id="m1" label="行业规范" />
		//							<menuItem id="m1" label="通知公告" />
		//					</menu>
		//					<menu label="市场">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//					<menu label="商户">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//					<menu label="追溯">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//					<menu label="菜价">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//					<menu label="科普">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//					<menu label="会员">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//					<menu label="服务">
		//							<menuItem id="m1" label="市场简介" />
		//							<menuItem id="m1" label="市场荣誉" />
		//							<menuItem id="m1" label="管理制度" />
		//							<menuItem id="m1" label="安全承诺" />
		//							<menuItem id="m1" label="管理人员" />
		//							<menuItem id="m1" label="消防安全" />
		//					</menu>
		//			</root>;
		//		private static var colorList:Vector.<Object> = new <Object>[
		//			{normalColor:0x888800,selectColor:0xaaaa00},
		//			{normalColor:0xe15757,selectColor:0xb70005},
		//			{normalColor:0x29aae1,selectColor:0x0171bb},
		//			{normalColor:0x888800,selectColor:0xaaaa00},
		//			{normalColor:0x888800,selectColor:0xaaaa00},
		//			{normalColor:0x888800,selectColor:0xaaaa00},
		//			{normalColor:0x888800,selectColor:0xaaaa00},
		//			{normalColor:0x888800,selectColor:0xaaaa00},
		//			{normalColor:0x888800,selectColor:0xaaaa00}
		//		];
		//		public static function get menuLength():uint{
		//			return menubarXML.menu.length();
		//		}
		public static function get menuLength():uint{
			return _menuBarSource.length;
		}
		private static var _homeGap:int = 2;//主页按钮占据两格
		public static function get homeGap():int
		{
			return _homeGap;
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
				mvo.normalColor = Vision.normalColor;
				mvo.selectColor = Vision.selectColor;
				mvo.stand = _menuBarSource[i].stand;
				mvo.typeID = _menuBarSource[i].typeID;
				mvo.link = _menuBarSource[i].link;
				mvo.items = createItems(mvo,_menuBarSource[i].items);
				if(i < 10)f = '0' + (i + 1);
				else var f:String = i + '';
				mvo.icon = _menuBarSource[i].icon;
				menuList.push(mvo);
			}
		}
		
		private static var tempId:int = 0;
		public static function createTempItems(mvo:MenuVo):Vector.<MenuItemVo>
		{
			var ivo:MenuItemVo = new MenuItemVo();
			ivo.id = --tempId;
			ivo.label = "";
			ivo.menuVo = mvo;
			ivo.typeID = mvo.typeID;
			ivo.view = getScreenClass(ivo.typeID);
			ivo.normalColor = Vision.normalColor;
			ivo.selectColor = mvo.selectColor;
			if(mvo.items == null){
				var itemList:Vector.<MenuItemVo> = mvo.items = new Vector.<MenuItemVo>();
			}else{
				itemList = mvo.items;
			}
			itemList.push(ivo);
			return itemList;
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
		
		public static function getItemVo(classid:int):MenuItemVo{
			for each (var mvo:MenuVo in menuList) 
			{
				for each (var ivo:MenuItemVo in mvo.items) 
				{
					if(ivo.id == classid){
						return ivo;
					}
				}
			}
			return null;
		}
		
		private static function createItems(mvo:MenuVo,iList:Array):Vector.<MenuItemVo>{
			var itemList:Vector.<MenuItemVo> = new Vector.<MenuItemVo>();
			for each (var item:Object in iList) 
			{
				var ivo:MenuItemVo = new MenuItemVo();
				ivo.id = item.id;
				ivo.label = item.label;
				ivo.menuVo = mvo;
				if(item.typeID == FarmDataBase.DATA_MERCH){//商铺类型数据 颜色自适应
					ivo.selectColor = MerchModel.getKindColor(item.attribute);
				}else{
					ivo.selectColor = mvo.selectColor;
				}
				ivo.attribute = item.attribute;
				ivo.normalColor = Vision.normalColor;
				ivo.typeID = item.typeID;
				ivo.view = getScreenClass(item.typeID);
				itemList.push(ivo);
			}
			return itemList;
		}
		
		//		private static function createMenuList():void
		//		{
		//			menuList = new Vector.<MenuVo>();
		//			var menuXmlList:XMLList = menubarXML.menu;
		//			
		//			for (var i:int = 0; i < menuXmlList.length(); i++) 
		//			{
		//				var mvo:MenuVo = new MenuVo();
		//				mvo.label = menuXmlList[i].@label;
		//				mvo.normalColor = colorList[i].normalColor;
		//				mvo.selectColor = colorList[i].selectColor;
		//				mvo.items = createItems(mvo,menuXmlList[i].menuItem);
		//				if(i < 10)f = '0' + (i+1);
		//				else var f:String = i + '';
		//				mvo.icon = "assets/menu/icon" + f + ".png";
		//				menuList.push(mvo);
		//			}
		//		}
		//		
		//		private static function createItems(mvo:MenuVo,itemXmlList:XMLList):Vector.<MenuItemVo>{
		//			var itemList:Vector.<MenuItemVo> = new Vector.<MenuItemVo>();
		//			for each (var item:XML in itemXmlList) 
		//			{
		//				var ivo:MenuItemVo = new MenuItemVo();
		//				ivo.label = item.@label;
		//				ivo.menuVo = mvo;
		//				itemList.push(ivo);
		//			}
		//			return itemList;
		//		}
		
	}
}