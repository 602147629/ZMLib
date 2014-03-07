package com.view
{
	import com.component.MenuList;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.model.MenuXMLData;
	import com.net.NetConfig;
	import com.rendener.MenuItemRendener;
	import com.rendener.MenuRendener;
	import com.utils.StarlingLoader;
	import com.vo.MenuItemVo;
	import com.vo.MenuVo;
	
	import flash.display.StageDisplayState;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class FarmMenu
	{
		private static var farmMenu:FarmMenu;
		public static function getInstance():FarmMenu{
			if(farmMenu == null)farmMenu = new FarmMenu();
			return farmMenu;
		}
		
		public function show():void{
			initFace();
			addListeners();
		}
		
		private function addListeners():void
		{
			menulist.addEventListener(Event.CHANGE, menuChange);
			itemList.addEventListener(Event.CHANGE, itemChange);
			Vision.addActiveEvent(onActive);
		}
		
		private function onActive(e:*):void
		{
//			hideStand();
		}
		
		private function removeListeners():void
		{
			menulist.removeEventListener(Event.CHANGE, menuChange);
			itemList.removeEventListener(Event.CHANGE, itemChange);
			Vision.removeActiveEvent(onActive);
		}
		
//		private var preMenu:int = -1;//前一个主菜单项
//		private var preItem:int = -1;//前一个子菜单项
		private function itemChange(e:Event = null):void
		{
			if(itemList.selectedItem != null){//有可能没有条目
				var ivo:MenuItemVo = itemList.selectedItem as MenuItemVo;
//				if(ivo.icon != null){
//					if(ivo.label == ID_HOME){
//						StandMember.getInstance().showDefault();
//					}else if(ivo.label == ID_BACK){
//						touchBack();
//					}
//				}else{
					CoreMember.getInstance().showScreen(ivo.id + "");//显示该界面
					CoreMember.getInstance().setRemoteParams(ivo.id,ivo.typeID);
					backButton.isSelected = homeButton.isSelected = false;
//					CoreMember.getInstance().addTitle(ivo.label);
					if(ivo.typeID == FarmDataBase.DATA_LINK){
//						navigateToURL(new URLRequest("http://183.129.255.37:7001/zjnm/login.jsp"),"_blank");
//						Vision.stage.displayState = StageDisplayState.NORMAL;
//						WebView.getInstance().showUrl("http://183.129.255.37:7001/zjnm/");
//						WebView.getInstance().showUrl("http://www.hzsm.gov.cn/");
						WebView.getInstance().showUrl(ivo.menuVo.link);
						return;
					}else{
						WebView.getInstance().hide();
					}
					if(e != null){
						itemTouchList.push(new IndexVo(menulist.selectedIndex,itemList.selectedIndex));
					}
//				}
			}
		}
//		private static const ID_HOME:String = "home";
//		private static const ID_BACK:String = "back";
//		private var homeVo:MenuItemVo;
//		private var backVo:MenuItemVo;
		private function initHomeVo(mvo:MenuVo):void{
//			if(homeVo == null){
				var homeVo:MenuItemVo = new MenuItemVo();
				homeVo.icon = "assets/menu/icon01.png";
//				homeVo.label = ID_HOME;
				homeVo.itemWidth = Vision.menuWidth + .5 * Vision.widthScale;
//			}
			homeVo.menuVo = mvo;
			homeButton.data = homeVo;
//			if(backVo == null){
				var backVo:MenuItemVo = new MenuItemVo();
				backVo.icon = "assets/menu/icon10.png";
//				backVo.label = ID_BACK;
				backVo.itemWidth = Vision.menuWidth;
//			}
			backVo.menuVo = mvo;
			backButton.data = backVo;
			
			homeVo.selectColor = backVo.selectColor = mvo.selectColor;
			homeVo.normalColor = backVo.normalColor = mvo.normalColor;
			
			if(itemList.leftSkin is Image){
				var image:Image = itemList.leftSkin as Image;
				var w:Number = 28 * Vision.widthScale;
				image.texture = Vision.createGradient(mvo.normalColor,w,
					itemList.height - MenuItemRendener.TOP_LINE_HEIGHT * Vision.heightScale);
				image.readjustSize();
				image.pivotX = w;
			}
			if(itemList.rightSkin is Image){
				image = itemList.rightSkin as Image;
				image.texture = Vision.createGradient(mvo.normalColor,28 * Vision.widthScale,
					itemList.height - MenuItemRendener.TOP_LINE_HEIGHT * Vision.heightScale);
				image.readjustSize();
			}
			backButton.isSelected = homeButton.isSelected = false;
		}
		
		private var itemTouchList:Vector.<IndexVo> = new Vector.<IndexVo>();
		private function menuChange(e:Event = null):void
		{
//			trace( "选中的条目selectedIndex:", list.selectedIndex );
			//			dispatchEventWith("listSelected",false,list.selectedItem);
			var mvo:MenuVo = menulist.selectedItem as MenuVo;
			if(mvo == null)return;//为-1阶段
			var items:Vector.<MenuItemVo> = mvo.items;
//			itemList.selectedIndex = 0;
			initHomeVo(mvo);
			var maxCount:int = MenuXMLData.menuLength - MenuXMLData.homeGap;//最多显示的个数
			if(items.length > maxCount){
				var count:int = maxCount;
			}else count = items.length;
			var itemWidth:Number = (Vision.senceWidth - MenuXMLData.homeGap * Vision.menuWidth) / count;
//			trace("最多:" + maxCount + "个");
			
			var list:Array = [/*this.homeVo*/];
			for each (var ivo:MenuItemVo in items) 
			{
				ivo.itemWidth = itemWidth;
				list.push(ivo);
			}
//			list.push(backVo);
//			Vision.fadeInOut(itemLayer,"y",itemLayer.y,itemLayer.y + itemLayer.height,.2,1,transition,list);
			
			if(e != null && itemLayer.visible){
				//itemLayer.visible表示非待机状态
				TweenLite.to(itemLayer,.1,{y:-itemLayer.height,onComplete:transition,onCompleteParams:[list,mvo]});
			}else{
				transition(list,mvo);
			}
//			moveItemList(menulist.selectedIndex,items.length);
//			itemChange();
		}
		private function transition(list:Array,mvo:MenuVo):void{
			if(mvo.typeID == FarmDataBase.DATA_MERCH){
				Merch3DView.getInstance().show();
				CoreMember.getInstance().hideBack();
			}else{
				Merch3DView.getInstance().hide();
				CoreMember.getInstance().showBack();
				LicenseView.getInstance().hide();
			}
			if(StandMember.getInstance().isStand){
				StandMember.getInstance().hideScreen(true);
			}
			topLine.color = mvo.normalColor;
			
			itemList.selectedIndex = -1;
			itemList.dataProvider = list;
			itemList.selectedIndex = 0;
			TweenLite.to(itemLayer,.1,{y:0});
		}
		//计算移动距离
		private function moveItemList(selectedIndex:int, length:uint):void
		{
			var center:int = (length - 1) / 2;
			var pre:int = selectedIndex - center;
			var index:int;
			if(pre >= 0){
				index = center;
			}else{
				index = center + pre;
			}
			var last:int = selectedIndex + ((length - 1) - center) - (MenuXMLData.menuLength - 1) + MenuXMLData.homeGap;
			if(last > 0){
				index += last;
			}
			var gap:Number = Vision.MENU_GAP * Vision.widthScale;
			var line:Number = 0;
			if(selectedIndex - index > 0)line = (selectedIndex - index) * gap;
			var x:Number = selectedIndex * Vision.menuWidth - index * Vision.menuWidth + line;
			TweenLite.to(itemList,.2,{x:x,ease:Back.easeOut});
		}
		private var container:Sprite;
		private var menulist:List;
		private var itemLayer:Sprite;//存放所有二级菜单
		private var itemList:MenuList;
		private var topLine:Quad;
		private function initFace():void
		{
			if(container == null){
				if(Vision.menuWidth == -1){
					var menuLength:int = MenuXMLData.menuLength;
					var gap:Number = Vision.MENU_GAP * Vision.widthScale;
					Vision.menuWidth = (Vision.senceWidth - (gap * menuLength - 1)) / menuLength;
				}
				container = new Sprite();
				itemLayer = new Sprite();
				createBack();
				container.addChild(itemLayer);
				createMenu();
				createItem();
				createHome();
			}
			Vision.addView(Vision.UI,container);
			container.y = Vision.admanageHeight * Vision.heightScale;
			//Vision.senceHeight - Vision.farmMenuHeight * Vision.heightScale;//Vision.senceHeight - container.height;
		}
		
		private var homeButton:MenuItemRendener;
		private var backButton:MenuItemRendener;
		/**
		 * 创建主页和返回键按钮
		 */		
		private function createHome():void
		{
//			homeButton = createButton("assets/menu/icon01.png");
//			itemLayer.addChild(homeButton);
//			
//			homeButton.y = itemList.y;
//			homeButton.x = Vision.senceWidth - Vision.menuWidth;
//			
//			backButton = createButton("assets/menu/icon10.png");
//			itemLayer.addChild(backButton);
//			
//			backButton.y = itemList.y;
//			backButton.x = Vision.senceWidth - Vision.menuWidth * 2 - 
//				Vision.MENU_GAP * Vision.widthScale;
			
			homeButton = new MenuItemRendener();
			homeButton.y = itemList.y;
			itemLayer.addChild(homeButton);
			backButton = new MenuItemRendener();
			backButton.y = itemList.y;
			backButton.x = Vision.senceWidth - Vision.menuWidth;
			itemLayer.addChild(backButton);
			
			backButton.addEventListener(TouchEvent.TOUCH,onTouch);
			homeButton.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				switch(e.currentTarget){
					case backButton:
						touchBack();
						break;
					case homeButton:
						StandMember.getInstance().showDefault();
						break;
				}
			}
		}
		/**
		 * 返回上级操作
		 */		
		private function touchBack():void
		{
//			if(menulist.prevIndex != -1){
//				menulist.trunPrev();
//			}
//			if(itemList.prevIndex != -1){
//				itemList.trunPrev();
//			}
			if(WebView.getInstance().isActive){
				WebView.getInstance().historyBack();
				return;//网页返回
			}
			removeListeners();
			if(itemTouchList.length > 1){
				itemTouchList.pop();
				var ivo:IndexVo = itemTouchList[itemTouchList.length - 1];////
				if(ivo.menuIndex != menulist.selectedIndex || 
					ivo.itemIndex != itemList.selectedIndex){
					menulist.selectedIndex = ivo.menuIndex;
					menuChange();
					itemList.selectedIndex = ivo.itemIndex;
					itemChange();//手动更改 非交互措施
				}
			}
			addListeners();
		}
		
		public function checkItemId(classid:int,data:Object = null):void{
			var itemVo:MenuItemVo = MenuXMLData.getItemVo(classid);
			if(itemVo != null){
				removeListeners();
				itemList.selectedItem = itemVo;
				itemChange();//手动更改 非交互措施
				CoreMember.getInstance().memberData = data;
				addListeners();
			}
		}
		
		private function createBack():void
		{
			var h:Number = Vision.farmMenuHeight * Vision.heightScale;
			var back:Quad = new Quad(Vision.senceWidth,h,0xFFFFFF,false);
			//0xe5e5e5
			container.addChild(back);
			topLine = new Quad(Vision.senceWidth,12 * Vision.heightScale);
			Vision.addView(Vision.MAIN,topLine);
			topLine.y = Vision.farmMenuHeight * Vision.heightScale;
		}
		
		public function showStand(id:int):void{
			itemLayer.visible = false;
////			menulist.touchable = false;//点击失效
//			menulist.selectedItem = MenuXMLData.getMenuVo(id);
			menulist.selectedIndex = -1;
		}
		
		public function hideStand(resume:Boolean = false):void{
			itemLayer.visible = true;
			if(!resume){//点击stand产生的
				if(itemTouchList.length > 0){
					var ivo:IndexVo = itemTouchList[itemTouchList.length - 1];
					menulist.selectedIndex = ivo.menuIndex;
				}else{
					menulist.selectedIndex = 0;
				}
			}
////			menulist.touchable = true;//点击可以
		}
		
		private function createMenu():void
		{
			var w:Number = Vision.senceWidth;
			var h:Number = Vision.MENU_HEIGHT * Vision.heightScale;
			var back:Quad = new Quad(w,h,0x5d5d5d);
			container.addChild(back);
//			back.y = Vision.MENU_ITEM_HEIGHT * Vision.heightScale;
			
			menulist = new List();
			menulist.dataProvider = createCollection();
			var layout:HorizontalLayout = new HorizontalLayout();//布局
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			layout.gap = Vision.MENU_GAP * Vision.widthScale;
			//			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
			//				layout.paddingLeft = 15;
			menulist.layout = layout;
//			list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			menulist.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			menulist.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			menulist.y = back.y;
			container.addChild(menulist);
			
			menulist.width = w;
			menulist.height = h;//
			menulist.itemRendererType = MenuRendener;
			menulist.selectedIndex = 0;//默认选中第一个
		}
		
		private function createItem():void
		{
			var h:Number = (Vision.MENU_ITEM_HEIGHT + 1) * Vision.heightScale;
			var w:Number = Vision.senceWidth - MenuXMLData.homeGap * Vision.menuWidth;// + 1;
			itemList = new MenuList(w,h);
			var layout:HorizontalLayout = new HorizontalLayout();//布局
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			layout.gap = 0;//Vision.MENU_GAP * Vision.widthScale;
			itemList.layout = layout;
//			itemList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
//			itemList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			itemList.x = Vision.menuWidth;
			itemList.y = Vision.MENU_HEIGHT * Vision.heightScale;
			
			itemLayer.addChild(itemList);
			
			itemList.itemRendererType = MenuItemRendener;
			
			var image:Image = new Image(Vision.TEXTURE_EMPTY);
			image.scaleX = -1;
			image.y = MenuItemRendener.TOP_LINE_HEIGHT * Vision.heightScale;
//			image.scaleX = Vision.widthScale;
//			image.scaleY = Vision.heightScale;
			itemList.leftSkin = image;
			image = new Image(Vision.TEXTURE_EMPTY);
			image.y = MenuItemRendener.TOP_LINE_HEIGHT * Vision.heightScale;
//			image.scaleY = Vision.heightScale;
			itemList.rightSkin = image;
		}
		
		private function createCollection():ListCollection
		{
			var lc:ListCollection = new ListCollection(MenuXMLData.getMenuList());
			return lc;
		}		
		
		private function createButton(icon:String = null):Button{
			var upTx:Image = new Image(Vision.createItemBack(0x5d5d5d));
			var downTx:Image = new Image(Vision.createItemBack(0x5d5d5d));
			downTx.color = 0x8d8d8d;
			var btn:Button = new Button();
			btn.upSkin = btn.hoverSkin = upTx;
			btn.downSkin = downTx;
			if(icon != null){
				StarlingLoader.loadImageFile(icon,true,loadImage,btn);
			}
			return btn;
		}
		
		private function loadImage(t:Texture,sp:Sprite):void
		{
			var icon:Image = new Image(t);
			sp.addChild(icon);
			icon.scaleX = icon.scaleY = Vision.heightScale;
			icon.x = (Vision.menuWidth - icon.width) / 2;
			icon.y = (Vision.MENU_ITEM_HEIGHT * Vision.heightScale - icon.height) / 2;
			//居中对齐
		}		
		
		public function getMenuRendener(index:int):MenuRendener
		{
			return menulist.getRendenerByIndex(index) as MenuRendener;
		}
	}
}
class IndexVo{
	public function IndexVo(m:int,i:int){
		menuIndex = m;
		itemIndex = i;
	}
	public var menuIndex:int;
	public var itemIndex:int;
}


