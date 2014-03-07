package com.rendener
{
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class FloorIconRendener extends BasicItemRenderer
	{
		public static const ICON_WIDTH:Number = 60;
		public static const ICON_HEIGHT:Number = 60;
		/*override protected function draw():void{
			if(_isSelected){
				showTabState("selectColor");
			}else{
				showTabState("defaultColor");
			}
		}*/
		override protected function commitData():void
		{
			StarlingLoader.loadFile(_data.icon,loadIcon);
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
			icon.x = (ICON_WIDTH - icon.width) / 2;
			icon.y = (ICON_HEIGHT - icon.height) / 2;
		}
		
		private function showTabState(color:uint):void{
			showImage(Vision.createRoundRect(ICON_WIDTH,ICON_HEIGHT,color));
		}
		private var back:Image;
		private function showImage(t:Texture):void
		{
			if(back == null){
				back = new Image(t);
				addChildAt(back,0);
			}else{
				back.texture = t;
				back.readjustSize();
			}
		}
		
		private function showColor():void{
			if(_isSelected){
				showTabState(0x019e97);
			}else{
				showTabState(0xaeaeae);
			}
		}
		
		public override function get height():Number{
			return ICON_HEIGHT;
		}
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			showColor();
		}
		
		
		
		
	}
}