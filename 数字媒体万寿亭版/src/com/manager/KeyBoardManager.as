package com.manager
{
	import com.core.IUIKeyboard;
	import com.event.KeyEvent;
	import com.model.PYLib;
	import com.view.DefaultKeyboardView;
	
	import flash.display.DisplayObject;

	public class KeyBoardManager
	{
		public static const KEY_SHIFT:String = "KEY_SHIFT";
		public static const KEY_NUMBER:String = "KEY_NUMBER";
		public static const KEY_LANG:String = "KEY_LANG";
		public static const KEY_SPACE:String = "KEY_SPACE";
		public static const KEY_BACK:String = "KEY_BACK";
		public static const KEY_SEND:String = "KEY_SEND";
		
		public static const MAX_COUNT:int = 80;//最多显示80个
		
		private static var lowerLetterList:Vector.<String>;//小写字库
		
		public static function getLowerList():Vector.<String>{
			if(lowerLetterList == null){
				lowerLetterList = new Vector.<String>();
				for (var i:int = 97; i < 97 + 26; i++) 
				{
					lowerLetterList.push(String.fromCharCode(i));
				}
			}
			return lowerLetterList;
		}
		
		private static var upperLetterList:Vector.<String>;//大写字库
		public static function getUpperList():Vector.<String>{
			if(upperLetterList == null){
				upperLetterList = new Vector.<String>();
				for (var i:int = 65; i < 65 + 26; i++) 
				{
					upperLetterList.push(String.fromCharCode(i));
				}
			}
			return upperLetterList;
		}
		
		private static var numberLetterList:Vector.<String>;//数字字库
		public static function getNumberList():Vector.<String>{
			if(numberLetterList == null){
				numberLetterList = new <String>['1','2','3','4','5','6','7','8','9','0',
					'@','/',':','(',')','￥','【','】','“',
					'。',',','、','？','！'];
			}
			return numberLetterList;
		}
		
		public static function showDefault(y:Number = 0):void{
			if(_keyView == null){
				var kv:DefaultKeyboardView = new DefaultKeyboardView();
				kv.scaleX = Vision.widthScale;
				kv.scaleY = Vision.heightScale;
				kv.x = (Vision.senceWidth - kv.width) / 2;
				kv.y = Vision.senceHeight;
				KeyBoardManager.keyView = kv;
			}
			_keyView.show(y);
		}
		
		public static function hideDefault():void{
			if(_keyView != null){
				_keyView.hide();
			}
		}
		
		private static var _keyView:IUIKeyboard;//默认控制视图
		public static function get keyView():IUIKeyboard
		{
			return _keyView;
		}
		public static function set keyView(value:IUIKeyboard):void
		{
			if(_keyView != null){
				_keyView.removeKeyEvent(keyHandler);
			}
			_keyView = value;
			_keyView.addKeyEvent(keyHandler);
		}
		
		private static function keyHandler(e:KeyEvent):void
		{
			if(e.keyCode == KEY_SHIFT){
				if(!e.isNumber){//非数字阶段
					if(e.isLarge){
						_keyView.dataProvider = getUpperList();
					}else{
						_keyView.dataProvider = getLowerList();
					}
				}
			}else if(e.keyCode == KEY_NUMBER){
				if(e.isNumber){
					_keyView.dataProvider = getNumberList();
				}else{
					if(e.isLarge){
						_keyView.dataProvider = getUpperList();
					}else{
						_keyView.dataProvider = getLowerList();
					}
				}
			}else if(e.keyCode == KEY_LANG){
				trace("切换语言:" + (e.isEnglish ? "英文":"中文"));
			}else if(e.keyCode == KEY_SPACE){
				_keyView.addText(" ");
			}else if(e.keyCode == KEY_BACK){
				_keyView.backText();
			}else if(e.keyCode == KEY_SEND){//清除数据
				var txt:String = _keyView.getText();
				trace("发送:" + txt);
				_keyView.reset();//重置
			}else{
				//根据中英文显示不同的数据
				if(e.isNumber || e.isEnglish){
					_keyView.addText(e.keyCode);//直接打印数据
				}else{//查找中文
					_keyView.addPhraseList(searchKey(e.keyCode));
				}
			}
		}

		private static function searchKey(key:String):Array{
			var data:Array = PYLib.data;
			var keyList:Array = [];
			for each (var str:String in data) 
			{
				var index:int = str.indexOf(key);
				if(index == 0){//从最左边开始
					var charIndex:int = index + key.length;
					var code:int = str.charCodeAt(charIndex);//取出之后的值是否是字母
					//97;  122; i++) 
//					if(code < 97 || code > 122){
						var nowStr:String = str.slice(charIndex);
						keyList = keyList.concat(nowStr.split(","));
						if(keyList.length > MAX_COUNT){
							break;
						}
//					}
				}
//				var tempList:Array = str.split(key);
//				if(tempList.length > 1){//说明存在
//					if(tempList[0] != ""){
//						var nowStr:String = tempList[0] + " + " + key + " " + tempList[1];
//					}else nowStr = tempList[1];
//					keyList = keyList.concat(nowStr.split(","));
//				}
			}
			return keyList;
		}
		
		//去除英文字母
		public static function sortString(str:String):String{
			var tempStr:String = '';
			for (var i:int = 0; i < str.length; i++) 
			{
				var code:int = str.charCodeAt(i);
				if(code < 97 || code > 122){
					var char:String = str.charAt(i);
					if(char != "'")tempStr += char;
				}
			}
			return tempStr;
		}
		
	}
}