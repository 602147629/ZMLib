package com.rendener
{
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	import com.vo.MenuItemVo;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	
	public class MenuItemRendener extends BasicItemRenderer
	{
		public static const TOP_LINE_HEIGHT:Number = 7;
		
		private var label:TextField;
		private var iconImage:Image;
		private var back:Quad;
		private var topLine:Quad;//上面的线条
		private var leftLine:Quad;//左边细线
		private var rightLine:Quad;//右边细线
		
		private var itemWidth:Number;
		
		override protected function initialize():void
		{
			topLine = new Quad(1,TOP_LINE_HEIGHT * Vision.heightScale);
			addChild(topLine);
			//			topLine.alpha = _isSelected ? 1 : .1;
			
			back = new Quad(1,Vision.MENU_ITEM_HEIGHT * Vision.heightScale - topLine.height);
			back.y = topLine.height;
			addChild(back);
			back.alpha = .2;
			
			leftLine = new Quad(1,30 * Vision.heightScale);
			addChild(leftLine);
			rightLine = new Quad(1,30 * Vision.heightScale);
			addChild(rightLine);
			leftLine.y = rightLine.y = back.y + (back.height - leftLine.height) / 2;
			leftLine.alpha = rightLine.alpha = .5;
		}
		
		private function initLabel():void{
			label = new TextField(Vision.menuWidth,50 * Vision.heightScale,"");
			label.fontSize = 22 * Vision.normalScale;
			label.color = 0xFFFFFF;
			label.y = (back.y + back.height - label.height) / 2;
			label.hAlign = HAlign.CENTER;
			label.autoScale = true;
			addChild(label);
		}
		
		override protected function commitData():void{
			if(_data == null)return;
			itemWidth = (_data as MenuItemVo).itemWidth;
			topLine.width = back.width = itemWidth;
			leftLine.x = -leftLine.width / 2;
			rightLine.x = itemWidth - rightLine.width / 2;
			
			var color:uint = (_data as MenuItemVo).selectColor;
			topLine.color = color;
			leftLine.color = rightLine.color = back.color = (_data as MenuItemVo).normalColor;
			
			if((_data as MenuItemVo).icon != null){
				StarlingLoader.loadImageFile((_data as MenuItemVo).icon,true,iconLoaded);
				if(label != null)label.text = '';
			}else{
				if(label == null){
					initLabel();
				}
				label.text = (_data as MenuItemVo).label;
				label.x = (itemWidth - label.width) / 2;
				label.color = _isSelected ? color : (_data as MenuItemVo).normalColor;
				if(iconImage != null){
					iconImage.texture = Vision.TEXTURE_EMPTY;
				}
			}
		}
		
		private function iconLoaded(t:Texture):void
		{
			if(iconImage == null){
				iconImage = new Image(t);
				addChild(iconImage);
				iconImage.smoothing = TextureSmoothing.BILINEAR;
				iconImage.scaleX = Vision.widthScale;
				iconImage.scaleY = Vision.heightScale;
				iconImage.alpha = .7;
			}else{
				iconImage.texture = t;
				iconImage.readjustSize();
			}
			if(_data != null){
				iconImage.color = (_data as MenuItemVo).normalColor;
			}
			iconImage.x = (itemWidth - iconImage.width) / 2;
			iconImage.y = (back.y + back.height - iconImage.height) / 2;
		}
		//		
		//		override protected function draw():void{
		//			
		//		}
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(_isSelected){
				if(topLine != null)topLine.alpha = 1;
				if(label != null)label.color = (_data as MenuItemVo).selectColor;
			}else{
				if(topLine != null)topLine.alpha = .1;
				if(label != null)label.color = (_data as MenuItemVo).normalColor;
			}
		}
		
		override public function get width():Number{
			return (_data as MenuItemVo).itemWidth;
		}
		
		
	}
}