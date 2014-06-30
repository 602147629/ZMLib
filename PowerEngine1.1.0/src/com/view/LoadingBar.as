package com.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class LoadingBar
	{
		public function LoadingBar()
		{
		}
		
		private static var loadingBar:LoadingBar;
		public static function getInstance():LoadingBar{
			if(loadingBar == null)loadingBar = new LoadingBar();
			return loadingBar;
		}
		
		private var _value:Number;
		public function get value():Number
		{
			return _value;
		}
		public function set value(value:Number):void
		{
			_value = value;
			var rate:Number = _value / _maxValue;
			nodeCount++;
			if(nodeCount > MAX_COUNT)nodeCount = 0;
			
			var tips:String = "";
			for (var i:int = 0; i < nodeCount; i++) tips += ".";
			tipLabel.text = _text + tips;
			
			bar.width = barWidth * rate;
			
			rateLabel.text = (rate * 100).toFixed() + "%";//显示百分比
		}
		
		private static const MAX_COUNT:int = 3;
		
		private var _maxValue:Number;//最大值
		private var nodeCount:int;
		private var _color:uint;
		private var _text:String;
		
		private static var stage:Stage;
		
		public function show(p:DisplayObjectContainer,maxVaule:Number,text:String = "",color:uint = 0xFFFFFF):void{
			if(stage == null)stage = p.stage;
			
			nodeCount = 0;
			_color = color;//颜色值
			_text = text;
			_maxValue = maxVaule;
			initFace();
			p.addChild(container);
			
			tipLabel.text = _text;
			tipLabel.x = (barWidth - tipLabel.width) / 2;
			rateLabel.text = "0%";
			
			center(container,stage.stageWidth,stage.stageHeight);
		}
		
		private static function center(dpo:DisplayObject,
									   w:Number,h:Number):void{
			var rect:Rectangle = dpo.getBounds(dpo);
			dpo.x = /*dpo.parent.x + */w / 2 - rect.width / 2 - rect.x;
			dpo.y = h / 2 - rect.height / 2 - rect.y;
		}
		
		public function hide():void{
			if(container != null)container.parent.removeChild(container);
		}
		
		private var barWidth:Number = 500;
		private var barHeight:Number = 50;
		
		private var container:Sprite;
		private var bar:Bitmap;
		private var tipLabel:TextField;
		private var rateLabel:TextField;
		
		private function initFace():void
		{
			if(container == null){
				container = new Sprite();
				
				drawBack();
				
				bar = new Bitmap(new BitmapData(1,1,false,_color));
				container.addChild(bar);
				bar.height = barHeight;
				
				tipLabel = createText(50);
				container.addChild(tipLabel);
				
				tipLabel.y = -tipLabel.height - 30;
				
				rateLabel = createText(40);
				container.addChild(rateLabel);
				
				rateLabel.y = (barHeight - rateLabel.height) / 2;
				rateLabel.x = barWidth + 20;
			}
		}
		
		private function createText(size:int):TextField{
			var tips:TextField = new TextField();
			
			var tf:TextFormat = tips.defaultTextFormat;
			tf.size = size;
			tips.defaultTextFormat = tf;
			tips.autoSize = TextFieldAutoSize.LEFT;
			tips.textColor = _color;
			tips.text = " ";
			
			return tips;
		}
		
		private function drawBack():void
		{
			container.graphics.lineStyle(2,_color);
			container.graphics.drawRect(0,0,barWidth,barHeight);
			container.graphics.endFill();
		}		
		
		
		
		
	}
}