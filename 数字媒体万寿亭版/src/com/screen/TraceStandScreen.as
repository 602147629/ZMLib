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
	
	public class TraceStandScreen extends Screen implements IMember
	{
		override protected function initialize():void
		{
			createBack();
			StarlingLoader.loadImageFile("assets/stand/tempImage05.jpg",true,loadImage);
		}
		
		private var back:Quad;
		private function createBack():void
		{
			back = new Quad(Vision.senceWidth,
				(Vision.screenHeight + Vision.MENU_ITEM_HEIGHT - 2) * Vision.heightScale,0xf9a92c);
			addChild(back);
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