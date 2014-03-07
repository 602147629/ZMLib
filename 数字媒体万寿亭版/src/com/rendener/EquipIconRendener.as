package com.rendener
{
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class EquipIconRendener extends BasicItemRenderer
	{
		public static const ICON_WIDTH:Number = 38;//59;
		public static const ICON_HEIGHT:Number = 38;
		/*override protected function draw():void{
			if(_isSelected){
				showTabState("selectColor");
			}else{
				showTabState("defaultColor");
			}
		}*/
		override protected function commitData():void
		{
			StarlingLoader.loadImageFile(_data.icon,true,loadIcon);
		}
		
		private var icon:Image;
		private function loadIcon(t:Texture):void
		{
			if(icon == null){
				icon = new Image(t);
				addChild(icon);
			}else{
				icon.texture = t;
				icon.readjustSize();
			}
			icon.scaleX = Vision.widthScale;
			icon.scaleY = Vision.heightScale;
			icon.x = (ICON_WIDTH * Vision.widthScale - icon.width) / 2;
			icon.y = (ICON_HEIGHT * Vision.heightScale - icon.height) / 2;
		}
		
//		private function showTabState(color:uint):void{
//			showImage(Vision.createRoundLineRect(ICON_WIDTH * Vision.widthScale,
//				ICON_HEIGHT * Vision.heightScale,0xffffff,Vision.normalScale * 2,color));
//		}
//		private var back:Image;
//		private function showImage(t:Texture):void
//		{
//			if(back == null){
//				back = new Image(t);
//				addChildAt(back,0);
//			}else{
//				back.texture = t;
//				back.readjustSize();
//			}
//		}
		
//		private function showColor():void{
//			if(_isSelected){
//				showTabState(0x019E97);
//			}else{
//				showTabState(0xaeaeae);
//			}
//		}
		
		public override function get height():Number{
			return ICON_HEIGHT * Vision.heightScale;
		}
		//assets/merch/icon/equipNormal.png
		//assets/merch/icon/equipSelect.png
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){
				StarlingLoader.loadImageFile("assets/merch/icon/equipSelect.png",true,onBackLoad);
			}else{
				StarlingLoader.loadImageFile("assets/merch/icon/equipNormal.png",true,onBackLoad);
			}
		}
		private var back:Image;
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
		}
		
		
		
	}
}