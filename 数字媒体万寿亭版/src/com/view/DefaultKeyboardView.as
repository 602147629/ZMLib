package com.view
{
	import com.core.IUIKeyboard;
	import com.event.KeyEvent;
	import com.greensock.TweenLite;
	import com.manager.KeyBoardManager;
	import com.manager.Vision;
	import com.text.ChineseInputWindow;
	
	import feathers.events.ItemEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import starling.events.TouchEvent;
	
	import ui.ria.UIKeyboard;
	import ui.ria.UILetter;
	
	public class DefaultKeyboardView extends UIKeyboard implements IUIKeyboard
	{
		public function DefaultKeyboardView()
		{
			initView();
			createInfoContainer();
			reset();
			this.scaleX = Vision.widthScale;
			this.scaleY = Vision.heightScale;
		}
		private var infoContainer:Sprite;
		private var infoWidth:Number = 898.95;
		private var infoHeight:Number = 67.55;
		private var textWidth:Number = 643.35;
		private var textHeight:Number = 46.9;
		private var textBack:Shape;
		private var textInput:TextField;
		private function createInfoContainer():void
		{
			infoContainer = new Sprite();
			addChild(infoContainer);
			infoContainer.addChild(btnSound);
			infoContainer.addChild(btnExpress);
			textBack = new Shape();
			infoContainer.addChild(textBack);
			textBack.x = (infoWidth - textWidth) / 2;
			initLabel();
			drawContainerBack(infoWidth,infoHeight);
			drawTextBack(textWidth,textHeight);
		}
		
		private function initLabel():void
		{
			textInput = new TextField();
			textInput.type = TextFieldType.INPUT;//输入文本类型
			textInput.width = textWidth;
			textInput.autoSize = TextFieldAutoSize.LEFT;
			textInput.wordWrap = true;
			infoContainer.addChild(textInput);
			textInput.embedFonts = true;
			var textFormat:TextFormat = textInput.defaultTextFormat;
			textFormat.font = "微软雅黑";
			textInput.defaultTextFormat = textFormat;
			textInput.x = textBack.x;
		}
		
		private function drawTextBack(w:Number, h:Number):void
		{
			textBack.graphics.clear();
			textBack.graphics.lineStyle(1.5);
			textBack.graphics.beginFill(0xFFFFFF);
			textBack.graphics.drawRoundRectComplex(0,0,w,h,10,10,10,10);
			textBack.graphics.endFill();
			measure();
		}
		/**
		 * 对齐坐标
		 */		
		private function measure():void
		{
			textInput.y = textBack.y = (infoHeight - textHeight) / 2;
		}
		
		private function drawContainerBack(w:Number, h:Number):void
		{
			infoContainer.graphics.clear();
			infoContainer.graphics.beginFill(0x878787);
			infoContainer.graphics.drawRoundRectComplex(0,0,w,h,10,10,0,0);
			infoContainer.graphics.endFill();
		}
		
		private function initView():void
		{
			for (var i:int = 1; i <= 26; i++) 
			{
				var uiLetter:UILetter = this["btn_" + i];
				if(uiLetter != null){
					uiLetter.mouseChildren = false;
//					uiLetter.txtLabel.mouseEnabled = false;
					uiLetter.txtLabel.text = String.fromCharCode(96 + i);
					//					uiLetter.txtLabel.antiAliasType = AntiAliasType.ADVANCED;
				}
			}
		}
		
		public function addKeyEvent(handler:Function):void
		{
			addEventListener(KeyEvent.KEY_ENTER,handler);
			addEventListener(MouseEvent.CLICK,clickButton);
		}
		
		public function removeKeyEvent(handler:Function):void
		{
			removeEventListener(KeyEvent.KEY_ENTER,handler);
			removeEventListener(MouseEvent.CLICK,clickButton);
		}
		private var isEnglish:Boolean;//是否是英文输入方式
		private var isNumber:Boolean;//是否是数字标点输入方式
		private var isLarge:Boolean;//是否是大写方式输入
		private var infoStr:String = '';
		private function clickButton(e:MouseEvent):void
		{
			var dpo:DisplayObject = e.target as DisplayObject;
			if(dpo is UILetter){
				if(!isNumber && !isEnglish){//输入中文
					infoStr += (dpo as UILetter).txtLabel.text.toLowerCase();
					chineseWindow.title = infoStr;
					sendEvent(infoStr);
				}else sendEvent((dpo as UILetter).txtLabel.text);//输入英文或标点直接输入
			}else if(dpo == mcShift){
				isLarge = !isLarge;
				mcShift.gotoAndStop(isLarge ? 2:1);
				sendEvent(KeyBoardManager.KEY_SHIFT);
			}else if(dpo == mcNumber){
				isNumber = !isNumber;
				mcNumber.gotoAndStop(isNumber ? 2:1);
				sendEvent(KeyBoardManager.KEY_NUMBER);
				if(isNumber){//输入标点
					clearLetter();
				}else{
					if(!isEnglish){
						showChinese();
					}
				}
			}else if(dpo == mcLang){
				isEnglish = !isEnglish;
				mcLang.gotoAndStop(isEnglish ? 2:1);
				sendEvent(KeyBoardManager.KEY_LANG);
				if(isEnglish){
					clearLetter();
				}else{
					showChinese();
				}
			}else if(dpo == btnBack){
				sendEvent(KeyBoardManager.KEY_BACK);
			}else if(dpo == btnSpace){
				sendEvent(KeyBoardManager.KEY_SPACE);
			}
			Vision.stage.focus = textInput;//显示焦点文本
		}
		
		private function showChinese():void
		{
			initChinese();
			tweenShow();
		}
		//缓动显示
		private function tweenShow():void
		{
			chineseWindow.addEventListener(ItemEvent.ITEM_CLICK,onItemClick);
			chineseWindow.x = this.x;
			chineseWindow.y = this.y - chineseWindow.height - 2 * Vision.heightScale;//上移到上方
		}
		
		private function onItemClick(e:ItemEvent):void
		{
			if(e.selectedItem != null){
				addText(KeyBoardManager.sortString(e.selectedItem.label));
				resetLetter();//重新设置
			}
		}
		
		private function resetLetter():void
		{
			infoStr = chineseWindow.title = '';
			chineseWindow.dataProvider = null;
		}
		
		private function tweenHide():void
		{
			if(chineseWindow != null){
				chineseWindow.removeEventListener(ItemEvent.ITEM_CLICK,onItemClick);
				Vision.removeView(Vision.TIPS,chineseWindow);
			}
		}
		
		private var chineseWindow:ChineseInputWindow;
		private function initChinese():void
		{
			if(chineseWindow == null){
				var h:Number = 50 * Vision.heightScale;
				var w:Number = infoWidth * Vision.widthScale;
				chineseWindow = new ChineseInputWindow(w,h);
				chineseWindow.gap = 15 * Vision.widthScale;
				chineseWindow.fontSize = 20 * Vision.normalScale;
			}
			Vision.addView(Vision.TIPS,chineseWindow);
		}
		/**
		 * 清除中文显示
		 */		
		private function clearLetter():void
		{
			if(chineseWindow != null){
				resetLetter();
				tweenHide();//隐藏中文数据
			}else{
				infoStr = '';
			}
		}
		
		private function sendEvent(value:String):void{
			var ke:KeyEvent = new KeyEvent(KeyEvent.KEY_ENTER);
			ke.keyCode = value;
			ke.isEnglish = isEnglish;
			ke.isLarge = isLarge;
			ke.isNumber = isNumber;
			dispatchEvent(ke);
		}
		
		private var _dataProvider:Object;
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			for (var i:int = 0; i < value.length; i++) 
			{
				var uiLetter:UILetter = this["btn_" + (i + 1)];
				if(uiLetter != null){
					uiLetter.txtLabel.text = value[i];
				}
			}
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		//重置
		public function reset():void
		{
			isEnglish = isNumber = isLarge = false;//默认中文输入
			mcShift.gotoAndStop(isLarge ? 2:1);
			mcNumber.gotoAndStop(isNumber ? 2:1);
			mcLang.gotoAndStop(isEnglish ? 2:1);
			clearLetter();
		}
		
		public function addText(char:String):void
		{
			var str:String = textInput.text;
			var caretIndex:int = textInput.caretIndex;//插入点位置
			var nowStr:String = str.slice(0,caretIndex) + char +  str.slice(caretIndex);
			textInput.text = nowStr;
			textInput.setSelection(caretIndex + char.length,caretIndex + char.length);
//			textInput.appendText(char);//添加信息
			Vision.stage.focus = textInput;
		}
		//回退一格
		public function backText():void
		{
			if(!isEnglish && !isNumber && infoStr != ""){
				infoStr = infoStr.substr(0,infoStr.length - 1);
				chineseWindow.title = infoStr;
				if(infoStr == ""){
					chineseWindow.dataProvider = null;
				}else{
					sendEvent(infoStr);//重新查找字符
				}
			}else{
				var str:String = textInput.text;
				var caretIndex:int = textInput.caretIndex;//插入点位置
				//从插入点回退一格
				if(caretIndex != 0){//无需退格
					var nowStr:String = str.slice(0,caretIndex - 1) + str.slice(caretIndex);
					textInput.text = nowStr;//减少信息
//					textInput.caretIndex = caretIndex - 1;//重新设置插入点
					textInput.setSelection(caretIndex - 1,caretIndex - 1);
					Vision.stage.focus = textInput;
				}
			}
		}
		public function getText():String
		{
			return textInput.text;
		}
		//添加词组
		public function addPhraseList(value:Array):void{
			for (var i:int = value.length - 1; i >= 0; i--) 
			{
				value[i] = {label:value[i]};
			}
			chineseWindow.dataProvider = value;
		}
		
		public function show(y:Number = 0):void{
			TweenLite.to(this,.5,{y:y,onComplete:checkChinese});
			Vision.stage.addChild(this);
			shield();
		}
		
		private function shield():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onStop);
			addEventListener(MouseEvent.MOUSE_UP,onStop);
			if(chineseWindow != null)
			chineseWindow.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function unShield():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,onStop);
			removeEventListener(MouseEvent.MOUSE_UP,onStop);
			if(chineseWindow != null)
				chineseWindow.removeEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onStop(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		private function checkChinese():void{
			if(!isNumber && !isEnglish){
				showChinese();
			}
		}
		
		public function hide():void{
			if(this.parent != null)
			TweenLite.to(this,.5,{y:Vision.senceHeight,onComplete:hideComplete});
		}
		
		private function hideComplete():void{
			if(this.parent != null)
				this.parent.removeChild(this);
			unShield();
		}
		
		
		
	}
}