package com.core
{
	public interface IMember
	{
		function setRemoteParams(id:int,typeID:String):void;//传入远程数据刷新信息
		function set memberData(obj:Object):void;
	}
}