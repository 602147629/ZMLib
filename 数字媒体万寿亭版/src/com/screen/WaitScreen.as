package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class WaitScreen extends Screen implements IMember
	{
		override protected function initialize():void
		{
			createBack();
			StarlingLoader.loadImageFile("assets/other/waitIcon.png",true,loadImage);
		}
		
		private function createBack():void
		{
			var quad:Quad = new Quad(this.owner.normalWidth,this.owner.normalHeight,0x88E2B7);
			addChild(quad);
		}
		private function loadImage(t:Texture):void
		{
			var image:Image = new Image(t);
			image.smoothing = TextureSmoothing.BILINEAR;
			addChild(image);
			image.scaleX = Vision.widthScale;
			image.scaleY = Vision.heightScale;
			image.x = (this.owner.normalWidth - image.width) / 2;
			image.y = (this.owner.normalHeight - image.height) / 2;
		}
		public function setRemoteParams(id:int, typeID:String):void
		{
		}
		
		public function set memberData(obj:Object):void
		{
		}
	}
}