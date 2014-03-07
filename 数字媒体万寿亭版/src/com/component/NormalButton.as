package com.component
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class NormalButton extends Sprite
	{
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		public function NormalButton(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
			changeView();
		}
		private var _fontSize:int = 12;
		public function set fontSize(value:int):void
		{
			_fontSize = value;
			changeView();
		}
		private var _labelColor:uint = 0xFFFFFF;
		public function set labelColor(value:uint):void
		{
			_labelColor = value;
			changeView();
		}
//		private var _labelEnabledColor:uint = 0x9f9f9f;
		private var _labelEnabledColor:uint = 0x50b5e0;
		public function set labelEnabledColor(value:uint):void
		{
			_labelEnabledColor = value;
			changeView();
		}
		
		private var _label:String;
		public function set label(value:String):void
		{
			_label = value;
			changeView();
		}
		private var _icon:String;
		public function set icon(value:String):void
		{
			_icon = value;
			changeView();
		}
		private var _backGroundColor:uint = 0x019e97;
		public function get backGroundColor():uint
		{
			return _backGroundColor;
		}
		public function set backGroundColor(value:uint):void
		{
			_backGroundColor = value;
			changeView();
		}
		private var _backGroundImage:String;//背景图片地址
		public function set backGroundImage(value:String):void
		{
			_backGroundImage = value;
			changeView();
		}
		private var _backEnabledColor:uint = 0xcae9f6;
//		private var _backEnabledColor:uint = 0x99D6D6;
		public function get backEnabledColor():uint
		{
			return _backEnabledColor;
		}
		public function set backEnabledColor(value:uint):void
		{
			_backEnabledColor = value;
			changeView();
		}
		protected var _isSelected:Boolean;
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			changeView();
		}
		
		private function changeView():void
		{
//			TweenLite.to(this,.5,{onComplete:showView});
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
		}
		
		private var back:Image;//背景图片
		private var txtLabel:TextField;//文字文本框
		private var iconImage:Image;//显示icon图片
		private function showView(e:Event = null):void{
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			initBack();
			initLabel();
			initIcon();
		}
		
		private function initBack():void
		{
			if(_backGroundImage != null){
				StarlingLoader.loadImageFile(_backGroundImage,true,onBackLoad);
				return;//显示背景层和颜色
			}
			if(_isSelected){
				var t:Texture = Vision.createRoundRect(actualWidth,actualHeight,_backGroundColor);
			}else{
				t = Vision.createRoundRect(actualWidth,actualHeight,_backEnabledColor);
			}
			if(back == null){
				back = new Image(t);
				addChild(back);
			}else{
				back.scaleX = back.scaleY = 1;
				back.texture = t;
				back.readjustSize();
			}
		}
		
		private function onBackLoad(t:Texture):void
		{
			if(back == null){
				back = new Image(t);
				addChildAt(back,0);
			}else{
				back.texture = t;
				back.readjustSize();
			}
			back.scaleX = Vision.widthScale;
			back.scaleY = Vision.heightScale;
			if(_isSelected){
				back.color = _backGroundColor;
			}else{
				back.color = _backEnabledColor;
			}
		}
		
		private function initLabel():void
		{
			if(_label != null){
				if(txtLabel == null){
					txtLabel = new TextField(actualWidth,actualHeight,"");
					addChild(txtLabel);
					txtLabel.autoScale = false;
				}
				txtLabel.color = _isSelected ? _labelColor : _labelEnabledColor;
				txtLabel.text = _label;
				txtLabel.fontSize = _fontSize;
			}
		}
		
		private function initIcon():void
		{
			if(_icon != null){
				StarlingLoader.loadImageFile(_icon,true,onIconLoad);
			}
		}
		
		private function onIconLoad(t:Texture):void
		{
			if(iconImage == null){
				iconImage = new Image(t);
				iconImage.smoothing = TextureSmoothing.BILINEAR;
				addChild(iconImage);
				iconImage.scaleX = Vision.widthScale;
				iconImage.scaleY = Vision.heightScale;
			}else{
				iconImage.texture = t;
				iconImage.readjustSize();
			}
			iconImage.x = (actualWidth - iconImage.width) / 2;
			iconImage.y = (actualHeight - iconImage.height) / 2;
		}		
		
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
		
	}
}