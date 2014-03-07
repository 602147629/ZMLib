package com.rendener
{
	import com.manager.Vision;
	import com.model.MenuXMLData;
	import com.utils.StarlingLoader;
	import com.vo.MenuVo;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class MenuRendener extends BasicItemRenderer
	{
		private var label:TextField;
		private var icon:Image;
//		private var back:Quad;
//		public static var menuWidth:Number = -1;

		private var back:Quad;
		
		override protected function initialize():void
		{
			var h:Number = 118 * Vision.heightScale;
			back = new Quad(Vision.menuWidth,h,0x373f42,false);
			addChild(back);
			var shadow:Quad = new Quad(Vision.menuWidth,65 * Vision.heightScale);
			shadow.alpha = .1;
			addChild(shadow);
			
			label = new TextField(Vision.menuWidth,50 * Vision.heightScale,"");
			label.fontSize = 28 * Vision.heightScale;
			label.color = 0xFFFFFF;
			label.y = 60 * Vision.heightScale;
			label.hAlign = HAlign.CENTER;
			addChild(label);
		}
		
		private function addImage():void
		{
			StarlingLoader.loadFile((_data as MenuVo).icon,loadImage);
		}
		
		private function loadImage(t:Texture):void
		{
			icon = new Image(t);
			addChild(icon);
			icon.scaleX = icon.scaleY = Vision.heightScale;
			icon.x = (Vision.menuWidth - icon.width) / 2;
			icon.y = 60 * Vision.heightScale - icon.height;
		}
		
		override public function get width():Number{
			return Vision.menuWidth;
		}
		
		override protected function commitData():void
		{
			label.text = (_data as MenuVo).label;
			addImage();
		}
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){
				back.color = (_data as MenuVo).normalColor;
			}else{
				back.color = 0x373f42;
			}
		}
		
		
	}
}