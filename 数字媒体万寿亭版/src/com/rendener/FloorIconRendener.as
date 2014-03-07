package com.rendener
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class FloorIconRendener extends BasicItemRenderer
	{
		public static const ICON_SELECT_HEIGHT:Number = 80;
		public static const FLOOR_WIDTH:Number = 65;
		
		override protected function initialize():void
		{
//			back = new Image(Vision.createRoundRect(ICON_SELECT_WIDTH * Vision.widthScale,
//				ICON_SELECT_WIDTH * Vision.heightScale,0x019e97));
//			addChild(back);
//			back.smoothing = TextureSmoothing.TRILINEAR;
//			back.pivotX = back.width / 2;
//			back.pivotY = back.height / 2;
//			back.x = ICON_SELECT_WIDTH * Vision.widthScale / 2;
//			back.y = ICON_SELECT_WIDTH * Vision.heightScale / 2;
//			back.scaleX = back.scaleY = .9;
		}
		
		override protected function commitData():void
		{
			if(txtBack == null){
				StarlingLoader.loadImageFile(_data.normalIcon,onTxtLoad);
			}
		}
		//assets/merch/icon/floorNormal.png
		//assets/merch/icon/floorSelect.png
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(value){
//				TweenLite.to(back,.2,{scaleX:1,scaleY:1});
//				StarlingLoader.loadFile("assets/merch/icon/floorSelect.png",onBackLoad);
				if(selectArrow != null){
					addChild(selectArrow);
				}else StarlingLoader.loadImageFile("assets/merch/icon/floorArrow.png",onArrowLoad);
			}else{
//				TweenLite.to(back,.2,{scaleX:.9,scaleY:.9});
//				StarlingLoader.loadFile("assets/merch/icon/floorNormal.png",onBackLoad);
				if(selectArrow != null && selectArrow.parent == this){
					removeChild(selectArrow);
				}
			}
			showText();
		}
		
		private function showText():void{
			if(txtBack != null){
				if(_isSelected){
					TweenLite.to(txtBack,.5,{alpha:1,scaleX:1,scaleY:1});
				}else{
					TweenLite.to(txtBack,.5,{alpha:.7,scaleX:.8,scaleY:.8});
				}
			}
		}
		
		private function onArrowLoad(t:Texture):void
		{
			if(selectArrow == null){
				selectArrow = new Image(t);
				selectArrow.scaleX = Vision.widthScale;
				selectArrow.scaleY = Vision.heightScale;
				selectArrow.x = 42 * Vision.widthScale;
				selectArrow.y = (height - selectArrow.height) / 2;
			}else{
				selectArrow.texture = t;
				selectArrow.readjustSize();
			}
			
			if(_isSelected){
				addChild(selectArrow);
			}
		}
		private var selectArrow:Image;
		
//		private var back:Image;
//		private function onBackLoad(t:Texture):void
//		{
//			if(back == null){
//				back = new Image(t);
//				addChildAt(back,0);
//			}else{
//				back.texture = t;
//				back.readjustSize();
//			}
//			back.scaleX = Vision.widthScale;
//			back.scaleY = Vision.heightScale;
//		}
//		
		private var txtBack:Image;
		private function onTxtLoad(t:Texture):void
		{
			if(txtBack == null){
				txtBack = new Image(t);
				txtBack.smoothing = TextureSmoothing.BILINEAR;
				addChild(txtBack);
			}else{
				txtBack.texture = t;
				txtBack.readjustSize();
			}
			txtBack.scaleX = Vision.widthScale;
			txtBack.scaleY = Vision.heightScale;
//			txtBack.x = (ICON_SELECT_HEIGHT * Vision.widthScale - txtBack.width) / 2;
//			txtBack.y = (ICON_SELECT_HEIGHT * Vision.heightScale - txtBack.height) / 2;
			showText();
		}
		
		public override function get height():Number{
			return ICON_SELECT_HEIGHT * Vision.heightScale;
		}
		
		
		
	}
}