package com.rendener
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.utils.StarlingLoader;
	import com.vo.FoodVo;
	
	import feathers.display.BasicItemRenderer;
	import feathers.events.ItemEvent;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class FoodRendener extends BasicItemRenderer
	{
		private var nameLabel:TextField;
		private var priceLabel:TextField;
		private var priceTrend:TextField;//价格趋势
		private var countTrend:TextField;//热销程度
		private var priceButton:TrendButton;
		private var countButton:TrendButton;
		private var back:Quad;
		
		override protected function removedFromStageHandler(event:Event):void
		{
			super.removedFromStageHandler(event);
			this.alpha = 0;
			this._index = -1;
		}
		
		override protected function initialize():void
		{
			back = new Quad(Vision.senceWidth,
				Vision.FOOD_ITEM_HEIGHT * Vision.heightScale,0xFFFFFF);
			addChild(back);
			back.x = (Vision.senceWidth - back.width) / 2;
			var tHeight:Number = 35 * Vision.heightScale;
			
			nameLabel = createText(350 * Vision.widthScale,tHeight,
				24 * Vision.heightScale,0x999999);
			nameLabel.hAlign = HAlign.LEFT;
			nameLabel.x = 275 * Vision.widthScale;// - nameLabel.width / 2;
			nameLabel.y = (height - nameLabel.height) / 2;
			
			priceLabel = createText(250 * Vision.widthScale,tHeight,
				24 * Vision.heightScale,0x39b44a);
//			priceLabel.bold = true;
			priceLabel.x = 545 * Vision.widthScale - priceLabel.width / 2;
			priceLabel.y = (height - priceLabel.height) / 2;
			
			priceTrend = createText(200 * Vision.widthScale,tHeight,
				24 * Vision.heightScale,0x999999,"价格趋势");
			priceTrend.x = 785 * Vision.widthScale - priceTrend.width / 2;
			priceTrend.y = (height - priceTrend.height) / 2;
			
			countTrend = createText(200 * Vision.widthScale,tHeight,
				24 * Vision.heightScale,0x999999,"热销程度");
			countTrend.x = 975 * Vision.widthScale - countTrend.width / 2;
			countTrend.y = (height - countTrend.height) / 2;
			
			priceButton = new TrendButton(45 * Vision.widthScale,
				36 * Vision.heightScale,"assets/food/icon01.png");
			addChild(priceButton);
			priceButton.x = 708 * Vision.widthScale - priceButton.width / 2;
			priceButton.y = (height - priceButton.height) / 2;
			priceButton.backTexture = Vision.createRoundLineRect(priceButton.width,priceButton.height,
				0xFFFFFF,Vision.normalScale,0x999999);
			
			countButton = new TrendButton(45 * Vision.widthScale,
				36 * Vision.heightScale,"assets/food/icon02.png");
			addChild(countButton);
			countButton.x = 900 * Vision.widthScale - countButton.width / 2;;
			countButton.y = (height - countButton.height) / 2;
			countButton.backTexture = Vision.createRoundLineRect(countButton.width,countButton.height,
				0xFFFFFF,Vision.normalScale,0x999999);
			priceButton.iconColor = countButton.iconColor = 0x999999;
			
			priceButton.addEventListener(TouchEvent.TOUCH,onTouch);
			countButton.addEventListener(TouchEvent.TOUCH,onTouch);
			
			createLine();
			
			this.alpha = 0;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				switch(e.currentTarget){
					case priceButton:
						(_data as FoodVo).selectType = FarmDataBase.TYPE_PRICE;
						break;
					case countButton:
						(_data as FoodVo).selectType = FarmDataBase.TYPE_COUNT;
						break;
				}
				changeButton();
				sendEvent();//没有第三个对象能被点中了
			}
		}
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x5c5c5c,
									label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.CENTER;
			labelText.hAlign = HAlign.CENTER;
			labelText.autoScale = false;
			addChild(labelText);
			return labelText;
		}
		
		//创建下划线
		private function createLine():void
		{
			var w:Number = 990 * Vision.widthScale;
			line = new Quad(w,Math.ceil(2 * Vision.heightScale),0xd8d8d8);
			addChild(line);
			line.x = (Vision.senceWidth - w) / 2;
//			quad.y = Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale - quad.height;
			//顶部
		}
		
		override protected function commitData():void
		{
			if(_data is FoodVo){
				nameLabel.text = (_data as FoodVo).name;
				
				priceLabel.text = "￥ " + (_data as FoodVo).price + 
					FarmDataBase.getUnitName("price");
				
				StarlingLoader.loadImageFile((_data as FoodVo).icon,true,imageComplete);
				if(this.owner != null && this.owner.isScrolling){
					this.alpha = 1;
					TweenLite.killTweensOf(this);
				}
			}
		}
		private var image:Image;//存放左侧图片

		private var line:Quad;
		private function imageComplete(t:Texture):void
		{
			if(image == null){
				image = new Image(t);
				addChild(image);
			}else{
				image.texture = t;
				image.readjustSize();
			}
			image.scaleX = Vision.widthScale;
			image.scaleY = Vision.heightScale;
			image.x = 92 * Vision.widthScale;
			image.x = line.x;
			image.y = (height - image.height) / 2;
		}
		
		//		override protected function draw():void{
		//			
		//		}
		
		public override function get height():Number{
			return Vision.FOOD_ITEM_HEIGHT * Vision.heightScale;// + 20 *Math.random();
		}
		
		public override function set index(value:int):void
		{
			if(this._index != value)
			{
				super.index = value;
				if(this.alpha != 1)TweenLite.to(this,.3,{delay:.2 + .1 * value,alpha:1});
			}
		}
		
		public override function set isSelected(value:Boolean):void
		{
			if(_isSelected != value){
				super.isSelected = value;
				if(_isSelected){
					back.color = 0xe4f2f3;
					changeButton();
					sendEvent();
				}else{
					back.color = 0xFFFFFF;
					countButton.backTexture = priceButton.backTexture = Vision.createRoundLineRect(priceButton.width,priceButton.height,
						0xFFFFFF,Vision.normalScale,0x999999);
					countButton.iconColor = priceButton.iconColor = 0x999999;
				}
			}
		}
		
		private function changeButton():void{
			if((_data as FoodVo).selectType == FarmDataBase.TYPE_PRICE){
				priceButton.backTexture = Vision.createRoundRect(priceButton.width,priceButton.height,
					0x39B44A);
				priceButton.iconColor = 0xFFFFFF;
				countButton.backTexture = Vision.createRoundLineRect(priceButton.width,priceButton.height,
					0xFFFFFF,Vision.normalScale,0x999999);
				countButton.iconColor = 0x999999;
			}else{
				countButton.backTexture = Vision.createRoundRect(priceButton.width,priceButton.height,
					0x39B44A);
				countButton.iconColor = 0xFFFFFF;
				priceButton.backTexture = Vision.createRoundLineRect(priceButton.width,priceButton.height,
					0xFFFFFF,Vision.normalScale,0x999999);
				priceButton.iconColor = 0x999999;
			}
		}
		
		private function sendEvent():void{
			var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
			ie.selectedItem = _data;
			this.owner.dispatchEvent(ie);
		}
	}
}
import com.manager.Vision;
import com.utils.StarlingLoader;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class TrendButton extends Sprite{

	private var actualHeight:Number;
	private var actualWidth:Number;
	public function TrendButton(w:Number,h:Number,iconUrl:String){
		actualWidth = w;
		actualHeight = h;
		StarlingLoader.loadImageFile(iconUrl,true,loadImage);
	}
	
	private var _icon:Image;
	private function loadImage(t:Texture):void
	{
		if(_icon == null){
			_icon = new Image(t);
			addChild(_icon);
			_icon.scaleX = Vision.widthScale;
			_icon.scaleY = Vision.heightScale;
			_icon.x = (actualWidth - _icon.width) / 2;
			_icon.y = (actualHeight - _icon.height) / 2;
		}else{
			_icon.texture = t;
			_icon.readjustSize();
		}
		_icon.color = _color;
	}
	
	private var _back:Image;
	public function set backTexture(t:Texture):void{
		if(_back == null){
			_back = new Image(t);
			addChildAt(_back,0);
		}else{
			_back.texture = t;
			_back.readjustSize();
		}
	}
	private var _color:uint;
	public function set iconColor(value:uint):void{
		_color = value;
		if(_icon != null)_icon.color = value;
	}
	
	public override function get width():Number{
		return actualWidth;
	}
	public override function get height():Number{
		return actualHeight;
	}
	
}