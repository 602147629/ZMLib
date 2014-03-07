package com.component
{
	import com.greensock.TweenLite;
	import com.manager.TimerManager;
	import com.manager.Vision;
	
	import feathers.events.ItemEvent;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 包含自定义滑动组件的复合选择组件
	 */	
	public class SliderCheckBox extends Sprite
	{
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		public function SliderCheckBox(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
			changeView();
		}
		private var _gap:Number = 0;
		public function set gap(value:Number):void
		{
			_gap = value;
			changeView();
		}
		private var _color:uint;//主题色
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			_color = value;
			changeView();
		}
		private var _normalIcon:String;
		public function set normalIcon(value:String):void
		{
			_normalIcon = value;
			changeView();
		}
		private var _selectIcon:String;
		public function set selectIcon(value:String):void
		{
			_selectIcon = value;
			changeView();
		}
		private var _normalLabel:String;
		public function set normalLabel(value:String):void
		{
			_normalLabel = value;
			changeView();
		}
		private var _selectLabel:String;
		public function set selectLabel(value:String):void
		{
			_selectLabel = value;
			changeView();
		}
		private var _fontSize:int = 12;
		public function set fontSize(value:int):void
		{
			_fontSize = value;
			changeView();
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
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				changeView();
			}
		}
		
		private function changeView():void
		{
//			TweenLite.to(this,.05,{onComplete:showView});
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
		}
		
		private var buttonContainer:Sprite;//背景按钮容器
		private var slider:SliderBar;//滑动组件
		private function showView(e:Event = null):void{
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			initButton();
			initSlider();
		}
		
		private function initSlider():void
		{
			if(slider == null){
				var count:int = _dataProvider.length;
				slider = new SliderBar((count - 1) / count * actualWidth,actualHeight);
				addChild(slider);
				slider.addEventListener(Event.SELECT,onSelect);
				slider.addEventListener(Event.CANCEL,onCancel);
				slider.addEventListener(TouchEvent.TOUCH,onSliderTouch);
				slider.x = actualWidth - slider.width;
				slider.alpha = 0;
			}
			slider.color = _color;
			slider.fontSize = _fontSize;
			slider.label = _normalLabel;
			slider.icon = _normalIcon;
			slider.visible = false;
		}
		
		private function onCancel(e:Event):void
		{
			//等待交互恢复
			TimerManager.setTimeOut(2000,resetUI);
		}
		
		private function onSliderTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(slider);
			if(touch != null){//点击事件
				if(touch.phase == TouchPhase.BEGAN){
					TimerManager.clearTimeOut(resetUI);
					//将计时器清除
				}else if(touch.phase == TouchPhase.ENDED){
					TimerManager.setTimeOut(2000,resetUI);
					//重新计时
				}
			}
		}
		
		private function onSelect(e:Event):void
		{
			slider.icon = _selectIcon;
			slider.label = _selectLabel;
			slider.touchable = false;//不能交互
			//等待交互恢复
			TimerManager.setTimeOut(2000,resetUI);
			
			if(selectButton != null){
				var index:int = int(selectButton.name);
				var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
				ie.selectedIndex = index;
				ie.selectedItem = _dataProvider[index];
				dispatchEvent(ie);//点击事件
			}
		}
		
		private function initButton():void
		{
			if(buttonContainer == null){
				buttonContainer = new Sprite();
				addChild(buttonContainer);
			}
			buttonContainer.removeChildren();
			var count:int = _dataProvider.length;
			var itemWidth:Number = (actualWidth - count * _gap) / count;
			for (var i:int = 0; i < count; i++) 
			{
				var btn:NormalButton = new NormalButton(itemWidth,actualHeight);
				buttonContainer.addChild(btn);
				btn.backGroundColor = _color;
				btn.label = _dataProvider[i][_labelFiled];
				btn.x = (itemWidth + _gap) * i;
				btn.fontSize = _fontSize;
				btn.name = i + "";
				btn.addEventListener(TouchEvent.TOUCH,onButtonTouch);
			}
		}		
		
		private var selectButton:NormalButton;
		private function onButtonTouch(e:TouchEvent):void
		{
			var btn:NormalButton = e.currentTarget as NormalButton
			var touch:Touch = e.getTouch(btn);
			if(touch != null){//点击事件
				if(touch.phase == TouchPhase.BEGAN){
//					trace("点中按钮:" + btn.name);
					selectButton = btn;
					btn.isSelected = true;
					hideButton(btn);
					showSlider();
					//等待交互恢复
					TimerManager.setTimeOut(2000,resetUI);
				}
			}
		}
		
		private function resetUI():void
		{
			TweenLite.to(slider,.2,{alpha:0,onComplete:resetSlider});
			var count:int = _dataProvider.length;
			var itemWidth:Number = (actualWidth - count * _gap) / count;
			buttonContainer.touchable = true;//点击按钮
			for (var i:int = 0; i < buttonContainer.numChildren; i++) 
			{
				var btn:NormalButton = buttonContainer.getChildAt(i) as NormalButton;
				TweenLite.to(btn,.2,{alpha:1,x:(itemWidth + _gap) * i});
				btn.isSelected = false;
			}
			selectButton = null;
		}
		
		private function resetSlider():void
		{
			slider.visible = false;
		}
//		
		private function hideButton(btn:NormalButton):void
		{
			buttonContainer.touchable = false;//不能点击按钮
			for (var i:int = 0; i < buttonContainer.numChildren; i++) 
			{
				var child:DisplayObject = buttonContainer.getChildAt(i);
				if(child != btn){
					TweenLite.to(child,.2,{alpha:0});
				}
//				child.removeEventListener(TouchEvent.TOUCH,onButtonTouch);
			}
			TweenLite.to(btn,.2,{x:0});//移动到最左边
		}
		
		private function showSlider():void
		{
			slider.visible = true;
			slider.touchable = true;
			slider.icon = _normalIcon;
			slider.label = _normalLabel;
			slider.reset();
			TweenLite.to(slider,.2,{alpha:1});
		}
		
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
		
	}
}