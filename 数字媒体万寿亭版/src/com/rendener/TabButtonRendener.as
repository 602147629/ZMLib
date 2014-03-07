package com.rendener
{
	import com.manager.Vision;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class TabButtonRendener extends BasicItemRenderer
	{
		private var back:Image;
		private var textField:TextField;
//		override protected function commitData():void
//		{
////			showTabState("selectColor");
//		}
		
		override protected function draw():void{
			if(_isSelected){
				showTabState("selectColor");
			}else{
				showTabState("defaultColor");
			}
			createText();
		}
		
		private static function getNotTag(key:String):String{
			if(key == "selectColor"){
				return "defaultColor";
			}
			return "selectColor";
		}
		
		private function showTabState(key:String):void{
			if(_data.isFirst){
				showImage(Vision.createLeftTab(_data.width,_data.height,_data[key],
					_data.lineColor));
			}else if(_data.isLast){
				showImage(Vision.createRightTab(_data.width,_data.height,_data[key],
					_data.lineColor));
			}else{
				showImage(Vision.createNormalTab(_data.width,_data.height,_data[key],
					_data.lineColor));
			}
			if(textField != null)textField.color = _data[getNotTag(key)];
		}
		
		public override function get width():Number{
			return _data != null ? _data.width - 1 * Vision.widthScale : 0;
		}
		
		override public function set isSelected(value:Boolean):void
		{
			if(value){
				showTabState("selectColor");
			}else if(_isSelected != value){
				showTabState("defaultColor");
			}
			super.isSelected = value;
		}
		
		private function createText():void
		{
			if(textField == null){
				textField = new TextField(_data.width,_data.height,_data.label);
				addChild(textField);
			}else{
				textField.text = _data.label;
			}
			textField.fontSize = _data.fontSize;
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
		
		
		
		
	}
}