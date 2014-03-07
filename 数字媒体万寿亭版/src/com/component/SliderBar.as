package com.component
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class SliderBar extends Sprite
	{
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		public function SliderBar(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
			changeView();
		}
		private var _icon:String;
		public function set icon(value:String):void
		{
			_icon = value;
			if(bar != null){
				bar.icon = _icon;
			}
//			changeView();
		}
//		private var _selectIcon:String;
//		public function set selectIcon(value:String):void
//		{
//			_selectIcon = value;
//			changeView();
//		}
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
		private var _fontSize:int = 12;
		public function set fontSize(value:int):void
		{
			_fontSize = value;
			changeView();
		}
		private var _label:String;
		public function set label(value:String):void
		{
			_label = value;
			changeView();
		}
		private var _enabled:Boolean = true;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(bar != null){
				bar.touchable = value;
			}
		}
		
		private function changeView():void
		{
//			TweenLite.to(this,.05,{onComplete:showView});
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
		}
		private var back:Image;//背景图片
		private var tipsLabel:TextField;//提示文字文本框
		private var bar:NormalButton;//滑动按钮
		private function showView(e:Event = null):void{
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			initBack();
			initLabel();
			initIcon();
		}
		private function initBack():void
		{
			var t:Texture = Vision.createRoundLineRect(actualWidth,actualHeight,
				0xf2f2f2,2 * Vision.normalScale,_color);
			if(back == null){
				back = new Image(t);
				addChild(back);
			}else{
				back.texture = t;
				back.readjustSize();
			}
		}
		
		private function initLabel():void
		{
			if(tipsLabel == null){
				tipsLabel = new TextField(actualWidth,actualHeight,"");
				tipsLabel.autoScale = false;
				addChild(tipsLabel);
			}
			tipsLabel.text = _label;
			tipsLabel.color = _color;
			tipsLabel.fontSize = _fontSize;
		}
		
		private function initIcon():void
		{
			if(bar == null){
				bar = new NormalButton(actualHeight * 1.1,actualHeight);
				addChild(bar);
				bar.isSelected = true;
				bar.x = actualWidth - bar.width;
				bar.touchable = enabled;
				bar.addEventListener(TouchEvent.TOUCH,onBarTouch);
			}
			bar.backGroundColor = _color;
			if(_icon != null){
				bar.icon = _icon;
			}
		}
		
		private function onBarTouch(e:TouchEvent):void
		{
//			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			var touch:Touch = e.getTouch(stage);
			if(touch != null){//点击事件
				if(touch.phase == TouchPhase.BEGAN){
					TweenLite.killTweensOf(bar);
				}else if(touch.phase == TouchPhase.MOVED){
					var position:Point = touch.getLocation(this);
					bar.x = position.x - bar.width / 2;
//					bar.y = position.y - bar.height / 2;
					if(bar.x < 0){
						bar.x = 0;
						showEnd();
						e.stopPropagation();
					}else if(bar.x > actualWidth - bar.width){
						bar.x = actualWidth - bar.width;
					}
				}else if(touch.phase == TouchPhase.ENDED){
					if(!isEnd){
						TweenLite.to(bar,.5,{x:actualWidth - bar.width,onComplete:sliderEnd});
					}else{
						isEnd = false;
					}
				}
			}
		}
		
		private function sliderEnd():void{
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		private var isEnd:Boolean;
		/**
		 * 滑动结束了
		 */		
		private function showEnd():void
		{
			if(!isEnd){
//				trace("滑到了换皮肤");
				isEnd = true;
				dispatchEvent(new Event(Event.SELECT));
			}
//			if(_selectIcon != null){
//				bar.icon = _selectIcon;
//			}
		}	
		
		public function reset():void{
			if(bar != null)bar.x = actualWidth - bar.width;
		}
		
		public override function get width():Number{
			return actualWidth;
		}
		
		public override function get height():Number{
			return actualHeight;
		}
		
		
	}
}