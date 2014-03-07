package com.view
{
	import com.component.VerticalAutoList;
	import com.control.FreeCameraControl;
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.model.MerchModel;
	import com.rendener.EquipIconRendener;
	import com.rendener.FloorIconRendener;
	import com.screen.MerchScreen;
	import com.utils.StarlingLoader;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class MerchStateUI
	{
		private static var merchStateUI:MerchStateUI;
		public static function getInstance():MerchStateUI{
			if(merchStateUI == null)merchStateUI = new MerchStateUI();
			return merchStateUI;
		}
		public function show():void{
			initFace();
			tweenShow();
		}
		public function hide():void{
			tweenHide();
		}
		
		private function tweenHide():void
		{
			if(container != null){
				TweenLite.to(container,.3,{alpha:0,onComplete:tweenHideOver});
			}
		}
		
		private function tweenHideOver():void{
			Vision.removeView(Vision.UI,container);
		}
		
		private function tweenShow():void
		{
			TweenLite.to(container,.3,{alpha:1});
		}
		private var container:Sprite;
//		private var floorList:VerticalAutoList;
		private var titleImage:Image;
		private function initFace():void
		{
			if(container == null){
				container = new Sprite();
				container.y = (Vision.admanageHeight + Vision.farmMenuHeight) * Vision.heightScale;
				
//				createFloor();
				createEquip();
				createScaleButton();
//				floorList.selectedIndex = MerchModel.FLOOR_DATA.length - 1;
			}
			Vision.addView(Vision.MAIN,container);
			startFloor(MerchModel.FIRST_FLOOR);
		}
		
		private var enlargeButton:Button;
		private var narrowButton:Button;
		/**
		 * 创建放大缩小按钮
		 */		
		private function createScaleButton():void
		{
			StarlingLoader.loadImageFile("assets/other/enlargeIcon.png",true,loadImage,"enlargeButton")
			StarlingLoader.loadImageFile("assets/other/narrowIcon.png",true,loadImage,"narrowButton")
		}
		
		private function loadImage(t:Texture,nameKey:String):void
		{
			var upSkin:Image = new Image(t);
			var downSkin:Image = new Image(t);
			upSkin.scaleX = downSkin.scaleX = Vision.widthScale;
			upSkin.scaleY = downSkin.scaleY = Vision.widthScale;
			downSkin.color = 0x8d8d8d;
			var button:Button = this[nameKey] = new Button();
			button.upSkin = button.hoverSkin = upSkin;
			button.downSkin = downSkin;
			container.addChild(button);
			button.addEventListener(TouchEvent.TOUCH,onTouch);
			var bottom:Number = EquipIconRendener.ICON_HEIGHT * Vision.heightScale + upSkin.height;
			//底部需要保留的距离
			button.y = MerchScreen.MERCH_TOP_LINE * Vision.heightScale - bottom;
//			if(nameKey == "enlargeButton"){
//				button.x = Vision.senceWidth - upSkin.width * 3;
//			}else{
//				button.x = Vision.senceWidth - upSkin.width * 2;
//			}
			checkButton();
		}
		
		private function checkButton():void
		{
			if(enlargeButton != null && narrowButton != null){
				narrowButton.x = Vision.senceWidth - narrowButton.upSkin.width * 2;
				enlargeButton.x = narrowButton.x - enlargeButton.upSkin.width;
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				switch(e.currentTarget){
					case enlargeButton:
						FreeCameraControl.getInstance().zoomCamera(true);
						break;
					case narrowButton:
						FreeCameraControl.getInstance().zoomCamera();
						break;
				}
			}
		}
		
//		private function createFloor():void
//		{
//			floorList = new VerticalAutoList();
//			//纵向滑动
//			container.addChild(floorList);
//			floorList.x = 42 * Vision.widthScale;
//			floorList.y = 200 * Vision.heightScale;
//			floorList.dataProvider = MerchModel.FLOOR_DATA;
//			floorList.iconFiled = "normalIcon";
//			floorList.selectIcon = "assets/merch/icon/floorArrow.png";//显示箭头
//			floorList.itemWidth = 65 * Vision.widthScale;
//			floorList.itemHeight = 45 * Vision.heightScale;
//			floorList.addEventListener(ItemEvent.ITEM_CLICK,onFloorChange);
//		}
		private var equipList:List;
		private function createEquip():void
		{
			equipList = new List();
			equipList.itemRendererType = EquipIconRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 2;
			layout.gap = gap * Vision.heightScale;
			equipList.layout = layout;
			equipList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			equipList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//纵向滑动
			container.addChild(equipList);
			equipList.x = 42 * Vision.widthScale;
			equipList.y = 410 * Vision.heightScale;
			equipList.width = EquipIconRendener.ICON_WIDTH * Vision.widthScale;
//			equipList.height = (EquipIconRendener.ICON_HEIGHT + gap) * 
//				MerchModel.EQUIP_DATA.length * Vision.heightScale;
			
			equipList.addEventListener(Event.CHANGE,onEquipChange);
		}
		private function onEquipChange(e:Event):void
		{
			if(equipList.selectedItem != null){
				Merch3DView.getInstance().showEquipNode(equipList.selectedItem.id);
			}
		}
		private function onFloorChange(e:ItemEvent):void
		{
			if(e.selectedItem != null){
				var floor:int = e.selectedItem.floor;
				startFloor(floor);
			}
		}
		
		private function startFloor(floor:int):void{
			Merch3DView.getInstance().showFloor(floor);
			showTitle(floor);
		}
		
		private function showTitle(floor:int):void
		{
			var list:Array = MerchModel.getFloorEquipList(floor);
			equipList.selectedIndex = -1;
			equipList.dataProvider = new ListCollection(list);
			equipList.selectedIndex = 0;
			var gap:Number = (equipList.layout as VerticalLayout).gap;
			var bottom:Number = ((list != null ? list.length : 0) + 1) * 
				(EquipIconRendener.ICON_HEIGHT * Vision.heightScale + gap);
			//底部需要保留的距离
			equipList.y = MerchScreen.MERCH_TOP_LINE * Vision.heightScale - bottom;
			//显示楼层的标题Logo
			StarlingLoader.loadImageFile("assets/merch/icon/titleL" + floor + ".png",true,onImageLoad);
		}
		
		public function checkSelectFloor(floor:int):void{
//			if(floorList.selectedItem != null){
//				var sf:int = floorList.selectedItem.floor;
//				if(floor != sf){
//					floorList.removeEventListener(ItemEvent.ITEM_CLICK,onFloorChange);
//					floorList.selectedItem = MerchModel.getFloorData(floor);
//					showTitle(floor);
//					floorList.addEventListener(ItemEvent.ITEM_CLICK,onFloorChange);
//				}
//			}
		}
		
		private function onImageLoad(t:Texture):void
		{
			if(titleImage == null){
				titleImage = new Image(t);
				container.addChild(titleImage);
				titleImage.scaleX = Vision.widthScale;
				titleImage.scaleY = Vision.heightScale;
				titleImage.x = 41 * Vision.widthScale;
				titleImage.y = 30 * Vision.heightScale;
			}else{
				titleImage.texture = t;
				titleImage.readjustSize();
			}
		}
		
	}
}