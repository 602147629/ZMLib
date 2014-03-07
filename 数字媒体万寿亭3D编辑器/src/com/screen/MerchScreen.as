package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.GameModel;
	import com.rendener.FloorIconRendener;
	import com.view.Game3DView;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MerchScreen extends Screen implements IMember
	{
		public static const MERCH_ITEM_WIDTH:Number = 995;
		private var container:Sprite;
		override protected function initialize():void
		{
			container = new Sprite();
			addChild(container);
			container.x = 20;
			container.y = 50;
			container.addEventListener(TouchEvent.TOUCH,onTouch);
			
			createEquip();
			var back:Quad = new Quad(FloorIconRendener.ICON_WIDTH + 20,equipList.height + 20);
			container.addChildAt(back,0);
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				switch(e.currentTarget){
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
			}
		}
		
		private static const FLOOR_DATA:Array = [{icon:"assets/merch/icon/icon2F.png",floor:2},
			{icon:"assets/merch/icon/icon1F.png",floor:1}];
		
//		private function createFloor():void
//		{
//			floorList = new List();
//			floorList.itemRendererType = FloorIconRendener;
//			var layout:VerticalLayout = new VerticalLayout();//布局
//			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
//			var gap:Number = 5;
//			layout.gap = gap * Vision.heightScale;
//			floorList.layout = layout;
//			floorList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//			floorList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//			//纵向滑动
//			addChild(floorList);
//			floorList.x = 42 * Vision.widthScale;
//			floorList.y = 43 * Vision.heightScale;
//			floorList.width = FloorIconRendener.ICON_WIDTH * Vision.widthScale;
//			floorList.height = (FloorIconRendener.ICON_HEIGHT + gap) * 
//				FLOOR_DATA.length * Vision.heightScale;
//			floorList.addEventListener(Event.CHANGE,onFloorChange);
//			floorList.dataProvider = new ListCollection(FLOOR_DATA);
//		}
		private var equipList:List;
		private function createEquip():void
		{
			equipList = new List();
			equipList.itemRendererType = FloorIconRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 2;
			layout.gap = gap;
			equipList.layout = layout;
			equipList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			equipList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//纵向滑动
			container.addChild(equipList);
			equipList.x = 10;
			equipList.y = 10;
			equipList.width = FloorIconRendener.ICON_WIDTH;
			equipList.height = (FloorIconRendener.ICON_HEIGHT + gap) * 
				GameModel.EQUIP_DATA.length;
			equipList.dataProvider = new ListCollection(GameModel.EQUIP_DATA);
			equipList.addEventListener(Event.CHANGE,onEquipChange);
		}
		
		private function onEquipChange(e:Event):void
		{
			if(equipList.selectedItem != null){
				Game3DView.getInstance().showEquipNode(equipList.selectedItem.id);
			}
		}
		
		private function onRemove(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			Game3DView.getInstance().hideNodePlane();
		}		
		
		public function setRemoteParams(id:int,typeID:String):void
		{
//			floorList.selectedIndex = FLOOR_DATA.length - 1;
			equipList.selectedIndex = 0;
			Game3DView.getInstance().showNodePlane();
			addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
		public function set memberData(obj:Object):void{
		}
	}
}