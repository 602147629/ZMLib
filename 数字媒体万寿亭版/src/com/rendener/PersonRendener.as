package com.rendener
{
	import com.component.SliderCheckBox;
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.model.MerchModel;
	import com.utils.PowerLoader;
	import com.utils.StarlingLoader;
	import com.vo.PersonVo;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.display.BasicItemRenderer;
	import feathers.events.ItemEvent;
	import feathers.layout.HorizontalLayout;
	
	import flash.display.Bitmap;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PersonRendener extends BasicItemRenderer
	{
		private var offSetX:Number = 30;
		private var back:Quad;
		private var iconImage:Image;//存放左侧图片
		private var nameLabel:TextField;//名字(264,24)
		private var occupLabel:TextField;//职位(264,107)
		private var idLabel:TextField;//编号(264,131)
		private var agreeLabel:TextField;//满意度(264,160)
		private var slider:SliderCheckBox;
		
//		public static function createButton(label:String,color:uint = 0x50b5e1):Sprite{
//			var sp:Sprite = new Sprite();
//			var back:Image = new Image(Vision.createRoundRect(
//				130 * Vision.widthScale,40 * Vision.heightScale,color));
//			sp.addChild(back);
//			var textFiled:TextField = new TextField(back.width,back.height,label);
//			sp.addChild(textFiled);
//			textFiled.fontSize = 25 * Vision.heightScale;
//			return sp;
//		}
		override protected function removedFromStageHandler(event:Event):void
		{
			super.removedFromStageHandler(event);
			this.alpha = 0;
			this._index = -1;
		}
		
		override protected function initialize():void
		{
			back = new Quad(Vision.senceWidth,height,0xFFFFFF);
			addChild(back);
			var color:uint = 0xa0a0a0;
//			var baseX:Number = (offSetX + 264) * Vision.widthScale;
			
			nameLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			nameLabel.x = 170 * Vision.widthScale - nameLabel.width / 2;
			nameLabel.y = (height - nameLabel.height) / 2;
			nameLabel.color = color;
			
			occupLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			occupLabel.color = color;
			occupLabel.x = 325 * Vision.widthScale - occupLabel.width / 2;
			occupLabel.y = (height - occupLabel.height) / 2;
			
			idLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			idLabel.color = color;
			idLabel.x = 450 * Vision.widthScale - occupLabel.width / 2;
			idLabel.y = (height - idLabel.height) / 2;
			
			agreeLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			agreeLabel.color = 0xe58935;
			agreeLabel.x = 570 * Vision.widthScale - occupLabel.width / 2;
			agreeLabel.y = (height - agreeLabel.height) / 2;
			
//			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			createLine();
			createSlider();
			
			this.alpha = 0;
		}
		
		//创建下划线
		private function createLine():void
		{
			var w:Number = 1005 * Vision.widthScale;
			var quad:Quad = new Quad(w,Math.ceil(1 * Vision.heightScale),0x50b5e0);
			addChild(quad);
			quad.y = height - quad.height;
			quad.x = (Vision.senceWidth - quad.width) / 2;
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
		
		override protected function commitData():void
		{
			if(_data is PersonVo){
//				StarlingLoader.loadFile((_data as PersonVo).icon,loadImage);
				StarlingLoader.loadImageFile((_data as PersonVo).icon,false,loadImage);
				nameLabel.text = (_data as PersonVo).name;
				occupLabel.text = (_data as PersonVo).occup;
				idLabel.text = (_data as PersonVo).number;
				agreeLabel.text = ((_data as PersonVo).agree * 100).toFixed(1) + "%";
			}
		}
		private function loadImage(bmp:Bitmap/*,t:Texture*/):void
		{
			bmp.scaleX = Vision.widthScale;
			bmp.scaleY = Vision.heightScale;
			if(iconImage == null){
//				iconImage = new Image(Vision.drawRoundMask(bmp,40 * Vision.normalScale,0x50b5e0,
//					5 * Vision.normalScale));
				iconImage = new Image(Vision.drawRectMask(bmp,60 * Vision.widthScale,
					60 * Vision.heightScale,10/*,1 * Vision.normalScale,0x4cc0b3*/));
				addChild(iconImage);
				iconImage.smoothing = TextureSmoothing.BILINEAR;
				iconImage.x = 40 * Vision.widthScale;
				iconImage.y = (height - iconImage.height) / 2;
			}else{
				iconImage.texture = Vision.drawRectMask(bmp,60 * Vision.widthScale,
					60 * Vision.heightScale,10/*,1 * Vision.normalScale,0x4cc0b3*/);
				iconImage.readjustSize();
			}
		}
		private function createSlider():void
		{
			slider = new SliderCheckBox(330 * Vision.widthScale,
				50 * Vision.heightScale);
			addChild(slider);
			slider.normalIcon = "assets/merch/icon/icon_normal.png";
			slider.selectIcon = "assets/merch/icon/icon_select.png";
			slider.color = 0x50b5e0;
			slider.x = 850 * Vision.widthScale - slider.width / 2;
			slider.y = (height - slider.height) / 2;
			slider.fontSize = 15 * Vision.normalScale;
			slider.normalLabel = "向左滑动提交";
			slider.selectLabel = "您的评价已提交!";
			slider.gap = 2;
			slider.dataProvider = MerchModel.AGREE_DATA;
			slider.addEventListener(ItemEvent.ITEM_CLICK,onItemClick);
		}
		
		private function onItemClick(e:ItemEvent):void
		{
			trace("提交:" + e.selectedItem.label);
		}
		
		public override function get height():Number{
			return Vision.PERSON_ITEM_HEIGHT * Vision.heightScale;
		}
		public override function get width():Number{
			return 300;
		}
		public override function set index(value:int):void
		{
			if(this._index != value)
			{
				super.index = value;
				if(this.alpha != 1)TweenLite.to(this,.2,{delay:.1 + .1 * value,alpha:1});
			}
		}
		
		override public function set isSelected(value:Boolean):void
		{
			if(_isSelected != value){
				if(value){
					back.color = 0xe4f2f3;//0xb7edf1;
				}else{
					back.color = 0xFFFFFF;
				}
				super.isSelected = value;
			}
		}
		
	}
}