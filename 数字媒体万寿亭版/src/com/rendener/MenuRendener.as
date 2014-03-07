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
	import starling.utils.VAlign;
	
	public class MenuRendener extends BasicItemRenderer
	{
		private var label:TextField;
		private var icon:Image;
//		private var back:Quad;
//		public static var menuWidth:Number = -1;

		private var back:Quad;
		
		override protected function initialize():void
		{
			var h:Number = Vision.MENU_HEIGHT * Vision.heightScale;
			back = new Quad(Vision.menuWidth,h,0x373f42,false);
			addChild(back);
//			var shadow:Quad = new Quad(Vision.menuWidth,65 * Vision.heightScale);
			//半透明蒙版
//			shadow.alpha = .05;
//			addChild(shadow);
			
			label = new TextField(Vision.menuWidth,18 * Vision.heightScale,"");
			label.fontSize = 13 * Vision.normalScale;
			label.hAlign = HAlign.CENTER;
			label.vAlign = VAlign.TOP;
			label.color = 0xFFFFFF;
			label.y = h / 2 + (h / 2 - label.height) / 2;
			addChild(label);
		}
		
		private function addImage():void
		{
			StarlingLoader.loadImageFile((_data as MenuVo).icon,true,loadImage);
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
			hideTips();
			super.isSelected = value;
			if(value){
				back.color = (_data as MenuVo).normalColor;
			}else{
				back.color = 0x373f42;
			}
		}
		
		public function showTips():void{
			back.color = 0x373f42;
			Vision.fadeInOut(back,"color",0x373f42,(_data as MenuVo).normalColor,0.29,-1,false);
		}
		
		public function hideTips():void{
			Vision.fadeClear(back);
		}
		
		
	}
}