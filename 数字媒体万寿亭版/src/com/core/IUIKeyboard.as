package com.core
{
	public interface IUIKeyboard
	{
		function addKeyEvent(handler:Function):void;
		function removeKeyEvent(handler:Function):void;
		function set dataProvider(value:Object):void;
		function get dataProvider():Object;
		function reset():void;//视图复位
		function addText(char:String):void;//添加文本
		function backText():void;//回退一格
		function getText():String;//获取所有的文本
		function addPhraseList(value:Array):void;//添加词组
		function show(y:Number = 0):void;
		function hide():void;
	}
}