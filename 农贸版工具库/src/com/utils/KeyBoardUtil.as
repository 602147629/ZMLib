package com.utils
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class KeyBoardUtil
	{
		private static var stage:Stage;
		//存储舞台实例
		/**
		 * 注册舞台实例 进行存储
		 * @param s
		 */		
		public static function registerStage(s:Stage):void{
			stage = s;
		}
		
		public static function addKeyUpEvent(keyUpHandler:Function):void{
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		public static function removeKeyUpEvent(keyUpHandler:Function):void{
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		public static function addNativeKeyUpEvent(keyUpHandler:Function):void{
			NativeApplication.nativeApplication.addEventListener(
				KeyboardEvent.KEY_UP,keyUpHandler);
		}
		public static function removeNativeKeyUpEvent(keyUpHandler:Function):void{
			NativeApplication.nativeApplication.removeEventListener(
				KeyboardEvent.KEY_UP,keyUpHandler);
		}
		
		public static function addNativeKeyDownEvent(keyUpHandler:Function):void{
			NativeApplication.nativeApplication.addEventListener(
				KeyboardEvent.KEY_DOWN,keyUpHandler);
		}
		public static function removeNativeKeyDownEvent(keyUpHandler:Function):void{
			NativeApplication.nativeApplication.addEventListener(
				KeyboardEvent.KEY_DOWN,keyUpHandler);
		}
	}
}