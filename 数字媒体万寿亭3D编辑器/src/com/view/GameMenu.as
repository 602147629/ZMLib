package com.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.manager.FileManager;
	import com.manager.Vision;
	import com.model.GameModel;
	import com.model.MenuXMLData;
	import com.rendener.MenuRendener;
	import com.utils.StarlingLoader;
	import com.vo.MenuVo;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledColumnsLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameMenu
	{
		private static var farmMenu:GameMenu;
		public static function getInstance():GameMenu{
			if(farmMenu == null)farmMenu = new GameMenu();
			return farmMenu;
		}
		public function show():void{
			initFace();
			addListeners();
		}
		
		private function addListeners():void
		{
			menulist.addEventListener(Event.CHANGE, menuChange);
			container.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function removeListeners():void
		{
			menulist.removeEventListener(Event.CHANGE, menuChange);
		}
		private function menuChange(e:Event = null):void
		{
			if(menulist.selectedItem is MenuVo){
				var mvo:MenuVo = menulist.selectedItem as MenuVo;
				CoreMember.getInstance().showScreen(mvo.id + "");
				CoreMember.getInstance().setRemoteParams(mvo.id,mvo.label);
//				if(mvo.id == MenuXMLData.EDIT_MAP_ID){
//					Game3DView.getInstance().showFirstCamera();
//				}else{
//					Game3DView.getInstance().showHoverCamera();
//				}
			}
		}
		
		private var container:Sprite;
		private var menulist:List;
		//		private var itemLayer:Sprite;//存放所有二级菜单
		private function initFace():void
		{
			if(container == null){
				if(Vision.menuWidth == -1){
					var menuLength:int = MenuXMLData.menuLength;
					var gap:Number = Vision.MENU_GAP * Vision.widthScale;
					Vision.menuWidth = (Vision.senceWidth - (gap * menuLength - 1)) / menuLength;
				}
				container = new Sprite();
				createBack();
				createMenu();
				createHome();
			}
			Vision.addView(Vision.UI,container);
			//			container.y = 100 * Vision.heightScale;
		}
		
		private function createBack():void
		{
			var h:Number = 216 * Vision.heightScale;
			var back:Quad = new Quad(Vision.senceWidth,h,0xe5e5e5,false);
			container.addChild(back);
		}
		private function createMenu():void
		{
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
			
			menulist.y = 98 * Vision.heightScale;
			container.addChild(menulist);
			
			menulist.width = Vision.senceWidth;
			menulist.height = 118 * Vision.heightScale;
			menulist.itemRendererType = MenuRendener;
			
			menulist.touchable = false;
			menulist.alpha = .5;
		}
		private var importButton:Sprite;
		//		private var homeGap:int = 2;//主页按钮占据两格
		/**
		 * 创建主页和返回键按钮
		 */		
		private function createHome():void
		{
			importButton = createButton("assets/menu/icon10.png");
			container.addChild(importButton);
			importButton.x = (Vision.senceWidth - Vision.menuWidth) / 2;
			importButton.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null){
				if(touch.phase == TouchPhase.BEGAN){
					switch(e.currentTarget){
						case importButton:
							touchImport();
							break;
						case container:
							//						trace("点中容器");
							Game3DView.getInstance().enabled = false;
							e.stopPropagation();
							Vision.staringStage.addEventListener(TouchEvent.TOUCH,onTouch);
							break;
						case Vision.staringStage:
							Game3DView.getInstance().enabled = true;
							Vision.staringStage.removeEventListener(TouchEvent.TOUCH,onTouch);
							break;
					}
				}else if(touch.phase == TouchPhase.ENDED){
					switch(e.currentTarget){
						case Vision.staringStage:
							Game3DView.getInstance().enabled = true;
							Vision.staringStage.removeEventListener(TouchEvent.TOUCH,onTouch);
							break;
					}
				}
			}
		}
		
		private function touchImport():void
		{
			FileManager.browse(onFileLoaded,FileManager.modelFilter);
		}
		
		private function onFileLoaded(model:ObjectContainer3D,xml:XML = null):void
		{
			//			trace("加载后文件名:" + name);
			GameModel.saveAll();//先保存当前数据设置
			GameModel.addXml(xml);
			Game3DView.getInstance().loadModel(model);
			menulist.touchable = true;
			menulist.alpha = 1;
			menulist.selectedIndex = 2;
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
				StarlingLoader.loadFile(icon,loadImage,btn);
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
	}
}
