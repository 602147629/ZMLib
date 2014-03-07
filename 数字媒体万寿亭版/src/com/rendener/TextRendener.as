package com.rendener
{
	import com.manager.Vision;
	
	import feathers.display.BasicItemRenderer;
	
	import flash.utils.setTimeout;
	
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class TextRendener extends BasicItemRenderer
	{
		private var infoText:TextField;
		override protected function initialize():void
		{
			infoText = new TextField(200,50,'');
			infoText.hAlign = HAlign.LEFT;
			infoText.vAlign = VAlign.TOP;
			infoText.autoSize = true;
			infoText.autoScale = false;
			addChild(infoText);
		}
		
		override protected function commitData():void
		{
			infoText.fontSize = _data.fontSize;//显示的字号
			infoText.text = _text;//(_index + 1) + "." + _data.label;//显示数据
//			setTimeout(aa,500);
		}
		
//		private function aa():void{
//			trace(_index,"宽度:" + infoText.width);
//		}
		
		private var _text:String;
		public override function get width():Number{
			_text = (_index + 1) + "." + _data.label;
			var w:Number = TextField.getTextWidth(_text);
//			trace(_index,"宽度:" + w);
			return w;
		}
		
	}
}