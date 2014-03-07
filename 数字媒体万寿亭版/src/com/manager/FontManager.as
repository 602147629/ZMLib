package com.manager
{
	import flash.text.Font;
	
	import starling.text.TextField;
	
	import ui.font.FontYAHEI;
	import ui.font.FontYAHEIBOLD;

	public class FontManager
	{
//		[Embed(source="assets/font/msyh.ttf",fontFamily="微软雅黑",embedAsCFF="false",
//mimeType="application/x-font-truetype")]
//		private static var FontClass:Class;
		
//		[Embed(source="assets/font/msyhbd.ttf",fontFamily="微软雅黑",embedAsCFF="false",
//mimeType="application/x-font-truetype")]
//		private static var FontBoldClass:Class;
		
		public static function register():void{
			
//			var uk:UIKeyboard = new UIKeyboard();
//			for (var i:int = 1; i <= 26; i++) 
//			{
//				var uiLetter:UILetter = uk["btn_" + i];
//				if(uiLetter != null){
//					//					var textFormat:TextFormat = uiLetter.txtLabel.defaultTextFormat;
//					//					textFormat.font = "微软雅黑";
//					//					uiLetter.txtLabel.embedFonts = true;
//					//					uiLetter.txtLabel.defaultTextFormat = textFormat;
//					//					uiLetter.txtLabel.text = uiLetter.txtLabel.text;
//					uiLetter.txtLabel.mouseEnabled = false;
//					uiLetter.txtLabel.text = String.fromCharCode(96 + i);
//					//					uiLetter.txtLabel.antiAliasType = AntiAliasType.ADVANCED;
//				}
//			}
//			Vision.stage.addChild(uk);
			Font.registerFont(FontYAHEI);
			Font.registerFont(FontYAHEIBOLD);
//			Font.registerFont(FontClass);
//			Font.registerFont(FontBoldClass);
			TextField.registerFont("微软雅黑");
			TextField.registerBoldFont("微软雅黑 Bold");
			//			
//			uk.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//			uk.addEventListener(MouseEvent.MOUSE_UP,onMouseDown);
			
//			TextField.registerBoldFont("微软雅黑");
		}
	}
}