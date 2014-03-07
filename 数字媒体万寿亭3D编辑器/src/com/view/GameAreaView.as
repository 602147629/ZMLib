package com.view
{
	import com.manager.Vision;
	import com.model.GameModel;
	import com.rendener.AgreeButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GameAreaView
	{
		private static var gameAreaView:GameAreaView;
		public static function getInstance():GameAreaView{
			if(gameAreaView == null)gameAreaView = new GameAreaView();
			return gameAreaView;
		}
		
		//游戏区域编辑视图
		public function show():void{
			initFace();
			addListeners();
		}
		
		private function addListeners():void
		{
			buttonList.addEventListener(starling.events.Event.CHANGE,onChange);
			container.addEventListener(TouchEvent.TOUCH,onTouch);
			inputY.addEventListener(flash.events.Event.CHANGE,onTextInput);
//			inputY.addEventListener(MouseEvent.MOUSE_DOWN,onInputDown);
		}
		
		private function onInputDown(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		public function hide():void{
			Vision.removeView(Vision.UI,container);
			if(inputY.parent == Vision.stage){
				Vision.stage.removeChild(inputY);
			}
		}
		
		private var container:Sprite;
		private function initFace():void
		{
			if(container == null){
				container = new Sprite();
				createList();
				createInput();
			}
			Vision.addView(Vision.UI,container);
			Vision.stage.addChild(inputY);
			buttonList.selectedIndex = 0;
		}
		
		private var inputY:TextField;
		private function createInput():void
		{
			inputY = new TextField();
			inputY.type = TextFieldType.INPUT;
			inputY.textColor = 0xFFFFFF;
			inputY.background = true;
			inputY.backgroundColor = 0x00FFFF;
			inputY.restrict = "0-9.";
			inputY.y = 120; 
			inputY.x = 10; 
			var df:TextFormat = inputY.defaultTextFormat;
			df.size = 25;
			df.align = TextFormatAlign.CENTER;
			inputY.defaultTextFormat = df;
			inputY.text = "0";
			inputY.height = 30;
			inputY.multiline = false;
//			inputY.width = 100;
		}
		
		private function onTextInput(e:flash.events.Event):void
		{
			var rotationY:Number = Number(inputY.text);
			if(isNaN(rotationY)){//转换失败归零
				rotationY = 0;
			}
//			trace("当前容器进行旋转:" + rotationY);
			var area:int = buttonList.selectedIndex;
			GameModel.setRotationY(area,rotationY);
			Game3DView.getInstance().changeRotationY(rotationY);
		}
		
		private var buttonList:List;//纵向选择类型列表
		private function createList():void
		{
			buttonList = new List();
			buttonList.itemRendererType = AgreeButton;
			var layout:HorizontalLayout = new HorizontalLayout();//布局
			layout.horizontalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			var gap:Number = 2;
			layout.gap = gap * Vision.widthScale;
			buttonList.layout = layout;
			buttonList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			buttonList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//纵向滑动
			container.addChild(buttonList);
			
			var itemWidth:Number = 62;
			var itemHeight:Number = 30;
			buttonList.height = itemHeight;
			buttonList.width = (itemWidth + gap) * GameModel.areaList.length;
			
			for each (var obj:Object in GameModel.areaList) 
			{
				obj.width = itemWidth;
				obj.height = itemHeight;
				obj.defaultColor = 0x373f42;
				obj.fontSize = 20;
			}
			buttonList.dataProvider = new ListCollection(GameModel.areaList);
			
			//对齐容器坐标
			buttonList.x = 10;//(Vision.senceWidth - buttonList.width) / 2;
			buttonList.y = 80;
		}
		
		private function onChange(e:starling.events.Event):void
		{
			var area:int = buttonList.selectedIndex;
			Game3DView.getInstance().changeArea(area);
			var rotationY:Number = GameModel.getRotationY(area);
			Game3DView.getInstance().changeRotationY(rotationY);
			inputY.text = rotationY + '';
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null){
				if(touch.phase == TouchPhase.BEGAN){
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
		
		public function get area():int{
			return buttonList.selectedIndex;
		}
		
		
		
		
		
		
		
		
		
	}
}