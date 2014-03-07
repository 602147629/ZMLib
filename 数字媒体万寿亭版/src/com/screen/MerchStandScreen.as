package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	import com.view.CoreMember;
	
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	
	public class MerchStandScreen extends Screen implements IMember
	{
		override protected function initialize():void
		{
			createBack();
//			StarlingLoader.loadFile("assets/stand/tempImage03.jpg",loadImage);
		}
		
		private var back:Quad;
		private function createBack():void
		{
			back = new Quad(Vision.senceWidth,
				(Vision.screenHeight + Vision.MENU_ITEM_HEIGHT - 2) * Vision.heightScale,0xc7edf8);
			addChild(back);
			back.alpha = 0;
		}
		
		private function loadImage(t:Texture):void
		{
			var image:Image = new Image(t);
			addChild(image);
			image.scaleX = Vision.widthScale;
			image.scaleY = Vision.heightScale;
		}
		public function setRemoteParams(id:int, typeID:String):void
		{
		}
		
		public function set memberData(obj:Object):void
		{
		}
	}
}