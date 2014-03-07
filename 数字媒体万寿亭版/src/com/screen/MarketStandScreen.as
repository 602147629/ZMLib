package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	import com.view.CoreMember;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MarketStandScreen extends Screen implements IMember
	{
		private var checkList:List;//食物列表
		private var titleLabel:TextField;
		private var timeLabel:TextField;//日期
		private var resultLabel:TextField;//结果
		
		override protected function initialize():void
		{
			createBack();
			StarlingLoader.loadImageFile("assets/stand/tempImage02.jpg",true,loadImage);
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
		
		private var back:Quad;
		private function createBack():void
		{
			back = new Quad(Vision.senceWidth,
				(Vision.screenHeight + Vision.MENU_ITEM_HEIGHT - 2) * Vision.heightScale,0x50b5e0);
			addChild(back)
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