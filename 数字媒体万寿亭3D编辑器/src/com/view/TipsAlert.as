package com.view
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TipsAlert
	{
		public static function show(p:DisplayObjectContainer,text:String = "",
									time:int = 1000,fontName:String = null):void{
			TipsAlert.getInstance().look(p,text,time,fontName);
		}
		private static var tipsAlert:TipsAlert;
		private static function getInstance():TipsAlert{
			if(tipsAlert == null)tipsAlert = new TipsAlert();
			return tipsAlert;
		}
		/**
		 * @param text
		 * @param time 多久后消失(毫秒)
		 * @param fontName
		 */	
		private function look(p:DisplayObjectContainer,text:String = "",time:int = 1000,fontName:String = null):void{
			initFace();
			p.addChild(container);
			showText(text,fontName);
			center(container);
			container.alpha = 1;
			TweenLite.to(container,.5,{delay:time / 1000,alpha:0,onComplete:hide});
		}
		
		private function center(dpo:DisplayObject):void{
			var w:Number = Vision.senceWidth;
			var h:Number = Vision.senceHeight;
//			var rect:Rectangle = dpo.getBounds(dpo);
//			dpo.x = /*dpo.parent.x + */w / 2 - rect.width / 2 - rect.x;
//			dpo.y = h / 2 - rect.height / 2 - rect.y;
			container.x = (w - container.width) / 2;
			container.y = (h - container.height) / 2;
			
		}
		
		private function hide():void{
			if(container.parent != null){
				container.parent.removeChild(container);
			}
		}
			
		private function showText(text:String = "",fontName:String = null):void
		{
			tips.wordWrap = false;
			var tf:TextFormat = tips.defaultTextFormat;
			if(fontName != null){
				tf.font = fontName;
				tips.embedFonts = true;
			}else{
				tf.font = null;
				tips.embedFonts = false;
			}
			tips.defaultTextFormat = tf;
			tips.text = text;
			
			if(tips.width > Vision.senceWidth / 2){
				tips.width = Vision.senceHeight / 2;
				tips.wordWrap = true;
			}
			drawBack();
		}
		
		private static const LEFT_PADDING:Number = 45;
		private static const TOP_PADDING:Number = 15;
		
		private function drawBack():void
		{
//			var textLine:Number = tips.y + (tips.height - tips.textHeight) / 2;
//			var topY:Number = textLine - TOP_PADDING;
//			var leftY:Number = tips.x - LEFT_PADDING;
			
			container.graphics.clear();
			container.graphics.lineStyle(5,0xF50000);
			container.graphics.beginFill(0xFFFFFF);
			var w:Number = LEFT_PADDING * 2 + tips.width;
			var h:Number = TOP_PADDING * 2 + tips.textHeight;
			container.graphics.drawRoundRect(0,0,w,h,20);
			container.graphics.endFill();
			
			tips.x = (w - tips.textWidth) / 2;
			tips.y = (h - tips.height) / 2;
		}
		
//		private function center():void
//		{
//			
//		}
		
		private var container:Sprite;
		private var tips:TextField;
		private function initFace():void
		{
			if(container == null){
				container = new Sprite();
				tips = new TextField();
				container.addChild(tips);
				container.scaleX = Vision.widthScale;
				container.scaleY = Vision.heightScale;
				
				tips.autoSize = TextFieldAutoSize.LEFT;
				tips.textColor = 0xF50000;
				var tf:TextFormat = tips.defaultTextFormat;
				tf.size = 80;
				tips.defaultTextFormat = tf;
			}
		}		
		
	}
}