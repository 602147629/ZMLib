package com.utils
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	/**
	 * 键盘控制器 工具类 存储所有按键的弹起和按下的状态(Array)
	 */	
	public class KeyboardUtil
	{
		private static var keyCodeList:Array = [];
		//存储器 存储所有按键状态 
		//如:按下A键  keyCodeList[A键码] = true;
		//松开D键 keyCodeList[D键码] = false;
		/**
		 * 让该键盘启动 侦听键盘弹起和按下事件
		 * 传入舞台实例s:Stage 让该舞台侦听键盘事件
		 */		
		public static function start(s:Stage):void{
			s.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			s.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		//在键盘松开事件处理函数中 用键码:e.keyCode 当做索引值 记录状态:false
		//表示这个键是松开的 如松开D键 keyCodeList[D键码] = false;
		private static function onKeyUp(e:KeyboardEvent):void
		{
			keyCodeList[e.keyCode] = false;//表示松开了
		}
		//在键盘按下事件处理函数中 用键码:e.keyCode 当做索引值 记录状态:true
		//如A键  keyCodeList[A键码] = true;
		private static function onKeyDown(e:KeyboardEvent):void
		{
			keyCodeList[e.keyCode] = true;//表示按下
		}
		/**
		 * 判断某个键现在是否是按下的 从keyCodeList[键码] == true(按下)??? 中判断
		 * @param code 对应按键的键码
		 * @return Boolean是否按下的状态
		 */		
		public static function keyIsDown(code:uint):Boolean{
			if(keyCodeList[code] == true){
				return true;//某按键按下了 返回状态true
			}
			return false;
		}
		
	}
}