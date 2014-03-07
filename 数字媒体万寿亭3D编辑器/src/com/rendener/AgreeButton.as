package com.rendener
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class AgreeButton extends BasicItemRenderer
	{
		//{width,height,defaultColor,selectColor,fontSize,fontColor}
		private var back:Image;
		private var textField:TextField;
//		override protected function initialize():void
//		{
//			if(back == null){
//				back = new Image(Vision.createRoundRect(
//					62 * Vision.widthScale,125 * Vision.heightScale,0x50b5e1));
//				addChild(back);
//				textFiled = new TextField(back.width,back.height,"");
//				addChild(textFiled);
//				textFiled.fontSize = 25 * Vision.heightScale;
//				textFiled.autoScale = true;//自动伸缩布局
//			}
//		}
		
		override protected function draw():void{
			if(_isSelected){
				showTabState("selectColor");
			}else{
				showTabState("defaultColor");
			}
			createText();
		}
		
		private function createText():void
		{
			if(textField == null){
				textField = new TextField(_data.width,_data.height,_data.label);
				addChild(textField);
				textField.autoScale = true;
				textField.color = 0xFFFFFF;
			}else{
				textField.text = _data.label;
			}
			textField.fontSize = _data.fontSize;
		}
		
		private function showTabState(key:String):void{
			showImage(Vision.createRoundRect(_data.width,_data.height,_data[key]));
		}
		
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
		
		/*override protected function commitData():void
		{
			textFiled.text = _data["label"];
		}*/
		
		override public function set isSelected(value:Boolean):void
		{
			if(value){
				showTabState("selectColor");
			}else if(_isSelected != value){
				showTabState("defaultColor");
			}
			super.isSelected = value;
		}
		
		public override function get width():Number{
			return _data.width;
		}
		public override function get height():Number{
			return _data.height;
		}
//		public override function set index(value:int):void
//		{
//			if(this._index != value)
//			{
//				super.index = value;
//			}
////			this.alpha = 0;
////			TweenLite.to(this,.1,{delay:.1 * value,alpha:1});
//		}
		
	}
}