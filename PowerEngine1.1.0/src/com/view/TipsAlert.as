package com.view
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TipsAlert
	{
		public static var embedLocalFonts:Boolean = false;//默认不嵌入字体
		
		public function TipsAlert(){
			
		}
		
		private static var tipsAlert:TipsAlert;
		public static function getInstance():TipsAlert{
			if(tipsAlert == null)tipsAlert = new TipsAlert();
			return tipsAlert;
		}
		
		private static var stage:Stage;
		/**
		 * 
		 * @param text
		 * @param time 多久后消失(毫秒)
		 * @param fontName
		 */	
		public function show(p:DisplayObjectContainer,text:String = "",time:int = 1000,fontName:String = null):void{
			if(stage == null)stage = p.stage;
			initFace();
			p.addChild(container);
			showText(text,fontName);
			center(container,stage.stageWidth,stage.stageHeight);
			container.alpha = 1;
			TweenLite.to(container,.5,{delay:time / 1000,alpha:0,onComplete:hide});
		}
		
		private static function center(dpo:DisplayObject,
									  w:Number,h:Number):void{
			var rect:Rectangle = dpo.getBounds(dpo);
			dpo.x = /*dpo.parent.x + */w / 2 - rect.width / 2 - rect.x;
			dpo.y = h / 2 - rect.height / 2 - rect.y;
		}
		
		public function hide():void{
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
				tips.embedFonts = embedLocalFonts;
			}else{
				tf.font = null;
				tips.embedFonts = false;
			}
			tips.defaultTextFormat = tf;
			tips.text = text;
			
			if(tips.width > stage.stageWidth / 2){
				tips.width = stage.stageWidth / 2;
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
				
				tips.autoSize = TextFieldAutoSize.LEFT;
				tips.textColor = 0xF50000;
				var tf:TextFormat = tips.defaultTextFormat;
				tf.size = 80;
				tips.defaultTextFormat = tf;
			}
		}		
		
	}
}