package com.event
{
	import flash.events.Event;
	import flash.ui.Keyboard;
	/**
	 * 自定义键盘事件
	 */	
	public class KeyEvent extends Event
	{
		public static const KEY_ENTER:String = "KEY_ENTER";//键盘输入
		public var keyCode:String;//键值
		public var isLarge:Boolean;//是否大写
		public var isNumber:Boolean;//是否数字输入形式
		public var isEnglish:Boolean;//是否是英文方式输入
		
		public function KeyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}