package com.rendener
{
	import com.component.NormalButton;
	import com.component.SliderCheckBox;
	import com.manager.Vision;
	import com.model.MerchModel;
	import com.utils.PowerLoader;
	import com.utils.StarlingLoader;
	import com.vo.MerchVo;
	
	import flash.display.Bitmap;
	
	import feathers.display.BasicItemRenderer;
	import feathers.events.ItemEvent;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 商户列表条目
	 */	
	public class MerchRendener extends BasicItemRenderer
	{
		private var nameLabel:TextField;
		private var merchIdLabel:TextField;//商户id
		private var floorLabel:TextField;//楼层
//		private var levelLabel:TextField;//信用等级
		private var levelContainer:Sprite;//星星容器
		private var back:Quad;
		private var iconImage:Image;//商户头像
		private var checkButton:NormalButton;//查看证照按钮
		private var talkContainer:Sprite;//评价按钮列表
		
		private var slider:SliderCheckBox;

		private static const MAX_COUNT:int = 5;
		
		override protected function initialize():void
		{
			back = new Quad(Vision.senceWidth,
				Vision.MERCH_ITEM_HEIGHT * Vision.heightScale,0xFFFFFF);
			//0xe4f2f3
			addChild(back);
			back.x = (Vision.senceWidth - back.width) / 2;
			
			var buttomLine:Quad = new Quad(1010 * Vision.widthScale,2 * Vision.heightScale,0xcff9f6);
			addChild(buttomLine);
			buttomLine.x = (Vision.senceWidth - buttomLine.width) / 2;
			buttomLine.y = height - buttomLine.height;
			
			nameLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			nameLabel.x = 180 * Vision.widthScale - nameLabel.width / 2;
			nameLabel.y = (height - nameLabel.height) / 2;
//			nameLabel.color = 0x4abfaf;
			
			merchIdLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			merchIdLabel.x = 290 * Vision.widthScale - merchIdLabel.width / 2;
			merchIdLabel.y = (height - merchIdLabel.height) / 2;
			
			floorLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale);
			floorLabel.x = 385 * Vision.widthScale - floorLabel.width / 2;
			floorLabel.y = (height - floorLabel.height) / 2;
			
			checkButton = new NormalButton(80 * Vision.widthScale,50 * Vision.heightScale);
			checkButton.label = "查看证照";
			addChild(checkButton);
			checkButton.fontSize = 15 * Vision.normalScale;
//			checkButton.labelEnabledColor = 0x019E97;
			checkButton.backGroundColor = 0x50b5e0;
//			checkButton.backEnabledColor = 0x99D6D6;
//			checkButton.isSelected = true;
			checkButton.x = 470 * Vision.widthScale - checkButton.width / 2;
			checkButton.y = (height - checkButton.height) / 2;
			checkButton.addEventListener(TouchEvent.TOUCH,onButtonTouch);
			
//			var licenseLabel:TextField = createText(150 * Vision.widthScale,50 * Vision.heightScale,
//				30 * Vision.heightScale,0x5c5c5c,"查看证件");
//			licenseLabel.x = 950 * Vision.widthScale - licenseLabel.width / 2;
//			licenseLabel.y = (height - licenseLabel.height) / 2;
			createSlider();
		}
		
		private function onButtonTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null){//点击事件
				if(touch.phase == TouchPhase.BEGAN){
					var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
					ie.item = checkButton;
					ie.selectedItem = _data;//选中的当前数据
					this.owner.dispatchEvent(ie);
					e.stopPropagation();//不选中
					_isSelected = false;
				}
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
			slider.x = 875 * Vision.widthScale - slider.width / 2;
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
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x50b5e0,
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
			if(_data is MerchVo){
				nameLabel.text = (_data as MerchVo).name;
				merchIdLabel.text = (_data as MerchVo).merchId;
				floorLabel.text = (_data as MerchVo).floor + "F";
				
				StarlingLoader.loadImageFile((_data as MerchVo).avatarIcon,false,loadImage);
				
				createStar();
			}
		}
		
		private function loadImage(bmp:Bitmap):void
		{
			bmp.scaleX = Vision.widthScale;
			bmp.scaleY = Vision.heightScale;
			if(iconImage == null){
//				iconImage = new Image(Vision.drawRoundMask(bmp,40 * Vision.normalScale,0x4cc0b3,
				iconImage = new Image(Vision.drawRectMask(bmp,60 * Vision.widthScale,
					60 * Vision.heightScale,10/*,1 * Vision.normalScale,0x4cc0b3*/));
				addChild(iconImage);
				iconImage.smoothing = TextureSmoothing.BILINEAR;
				iconImage.x = 45 * Vision.widthScale;
				iconImage.y = (height - iconImage.height) / 2;
			}else{
				iconImage.texture = Vision.drawRectMask(bmp,60 * Vision.widthScale,
					60 * Vision.heightScale,10/*,1 * Vision.normalScale,0x4cc0b3*/);
				iconImage.readjustSize();
			}
		}
		
		private function createStar():void
		{
			if(levelContainer == null){
				levelContainer = new Sprite();
				addChild(levelContainer);
			}
//			levelContainer.removeChildren(0,-1,true);
//			var r:Number = 13 * Vision.heightScale;//半径
			
			if(levelContainer.numChildren > 0){
				for (var i:int = 0; i < MAX_COUNT; i++) 
				{
					var star:Image = levelContainer.getChildAt(i) as Image;
					if(i < (_data as MerchVo).level){
						star.color = 0xF39700;
					}else{
						star.color = 0x92A124;
					}
				}
			}else{
				StarlingLoader.loadImageFile("assets/merch/levelIcon.png",true,loadStar);
			}
		}
		
		private function loadStar(t:Texture):void
		{
			for (var i:int = 0; i < MAX_COUNT; i++) 
			{
				var star:Image = new Image(t);
				star.smoothing = TextureSmoothing.BILINEAR;
//				star.pivotX = star.pivotY = r;
				levelContainer.addChild(star);
				star.x = i * (star.width + 10 * Vision.heightScale);
				if(i < (_data as MerchVo).level){
					star.color = 0xF39700;
				}else{
					star.color = 0x92A124;
				}
			}
			levelContainer.x = 608 * Vision.widthScale - levelContainer.width / 2;
			levelContainer.y = (height - star.height) / 2;
		}
		
		override public function set isSelected(value:Boolean):void
		{
			if(value){
//				back.color = 0xe4f2f3;//0xb7edf1;
				Vision.fadeInOut(back,"color",0xFFFFFF,0xe4f2f3,.05,3,false);
			}else{
				Vision.fadeClear(back);
				back.color = 0xFFFFFF;
			}
			super.isSelected = value;
//			this.invalidate(INVALIDATION_FLAG_SELECTED);
//			this.dispatchEventWith(Event.CHANGE);
//			_isSelected = value;
		}
		
		public override function get height():Number{
			return Vision.MERCH_ITEM_HEIGHT * Vision.heightScale;// + 20 *Math.random();
		}
	}
}