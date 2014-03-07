package com.text
{
	import com.manager.Vision;
	import com.rendener.TextRendener;
	import com.utils.StarlingConvert;
	
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ChineseInputWindow extends Sprite
	{
		//		private static var chineseInputWindow:ChineseInputWindow;
		//		public static function getInstance():ChineseInputWindow{
		//			if(chineseInputWindow == null)chineseInputWindow = new ChineseInputWindow();
		//			return chineseInputWindow;
		//		}
		private var leftPadding:Number = 30;//左对齐距离
		
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		public function ChineseInputWindow(w:Number,h:Number){
			actualWidth = w;
			actualHeight = h;//交互区域大小
		}
		/**
		 * 出现的基准点坐标
		 * @param baseX
		 * @param baseY
		 */		
		//		public function show(baseX:Number,baseY:Number):void{
		//			
		//		}
		
		private var _backGroundColor:uint = 0x878787;
		public function get backGroundColor():uint
		{
			return _backGroundColor;
		}
		public function set backGroundColor(value:uint):void
		{
			_backGroundColor = value;
			changeView();
		}
		private var _fontSize:int = 20;
		public function set fontSize(value:int):void
		{
			_fontSize = value;
			changeView();
		}
		private var _labelColor:uint = 0;
		public function set labelColor(value:uint):void
		{
			_labelColor = value;
			changeView();
		}
		
		private var _gap:Number = 15;
		public function set gap(value:Number):void
		{
			_gap = value;
			changeView();
		}
		
		private var _dataProvider:Object;
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				changeView();
			}
		}
		private var _title:String;//标题
		public function set title(value:String):void
		{
			_title = value;
			changeView();
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _labelFiled:String = "label";//文字属性名
		public function get labelFiled():String
		{
			return _labelFiled;
		}
		
		public function set labelFiled(value:String):void
		{
			_labelFiled = value;
			changeView();
		}
		
		private function changeView():void
		{
			//			TweenLite.to(this,.5,{onComplete:showView});
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
		}
		private var back:Quad;//背景图片
		private var titleLabel:TextField;//文字文本框
		private var textList:ScrollContainer;//显示icon图片
		private function showView(e:Event = null):void{
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			initBack();
			initTitle();
			initScroll();
		}		
		
		private function initScroll():void
		{
			if(textList == null){
				textList = new ScrollContainer();
				textList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
				textList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
				addChild(textList);
				textList.x = leftPadding * Vision.widthScale;
//				textList.addEventListener(Event.CHANGE,onChange);
			}
			textList.width = actualWidth - (leftPadding * 2 * Vision.widthScale);
			textList.height = actualHeight * 2 / 3;
			textList.y = actualHeight * 3 / 4 - textList.height / 2;
			
			textList.stopScrolling();//停止滑动
//			for each (var obj:Object in _dataProvider) 
//			{
//				obj.fontSize = _fontSize;//添加字号显示
//			}
			showText();
			textList.horizontalScrollPosition = 0;//回到初始位置
		}
		
		private function showText():void
		{
			textList.removeChildren(0,-1,true);
			if(_dataProvider == null)return;
			var baseX:Number = 0;
			for (var i:int = 0; i < _dataProvider.length; i++) 
			{
				var text:String = (i+ 1) + "." + _dataProvider[i][_labelFiled];//显示文本
				var w:Number = TextField.getTextWidth(text,_fontSize) + _gap;
				var infoText:TextField = new TextField(w,_fontSize + 10,'');
				infoText.hAlign = HAlign.LEFT;
				infoText.vAlign = VAlign.TOP;
				infoText.autoSizeHeight = true;
				infoText.autoScale = false;
				infoText.text = text;
				infoText.x = baseX;
				infoText.name = i + "";
				infoText.fontSize = _fontSize;
				baseX += w;
				textList.addChild(infoText);
				infoText.addEventListener(TouchEvent.TOUCH,onTouch);
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
//			if(textList.isScrolling)return;//滚动中触发不算
			var infoText:TextField = e.currentTarget as TextField;
			var touch:Touch = e.getTouch(infoText);
			if(touch != null){
//				trace(touch.phase);
				if(touch.phase == TouchPhase.BEGAN){
					textList.addEventListener(TouchEvent.TOUCH,onMove);
				}else if(touch.phase == TouchPhase.ENDED){
					if(!isDrag){
						var index:int = int(infoText.name);
						sendEvent(index);
					}
				}
			}
		}
		
		private function sendEvent(index:int):void
		{
			var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
			ie.selectedIndex = index;
			ie.selectedItem = _dataProvider[index];
			dispatchEvent(ie);
		}		
		
		private var isDrag:Boolean;
		private function onMove(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null){
				if(touch.phase == TouchPhase.MOVED){
					isDrag = true;
				}else if(touch.phase == TouchPhase.ENDED){
					textList.removeEventListener(TouchEvent.TOUCH,onMove);
					isDrag = false;
				}
			}
		}
		
//		private function onChange(e:Event):void
//		{
//			if(textList.selectedItem != null){
//				var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
//				ie.selectedIndex = textList.selectedIndex;
//				ie.selectedItem = textList.selectedItem;
//				dispatchEvent(ie);
//			}
//		}
		
		private function initTitle():void
		{
			if(titleLabel == null){
				titleLabel = new TextField(120 * Vision.widthScale,actualHeight / 2,"");
				titleLabel.x = leftPadding / 2 * Vision.widthScale;
				titleLabel.hAlign = HAlign.LEFT;
				addChild(titleLabel);
			}
			titleLabel.fontSize = _fontSize - 7 * Vision.normalScale;//字体相差7号
			titleLabel.y = (actualHeight / 2 - titleLabel.height) / 2;
			titleLabel.text = _title;
		}
		
		private function initBack():void
		{
			if(back == null){
				back = new Quad(1,1);
				addChild(back);
			}
			back.width = actualWidth;
			back.height = actualHeight;
			back.color = _backGroundColor;
		}		
		
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
	}
}