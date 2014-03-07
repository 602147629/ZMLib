package com.event
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author GY
	 */	
	public class PadEvent extends Event
	{
		public static const CHANGE_DIRCET:String = 'CHANGE_DIRCET';
		//定义改变方向的事件类型
		
		/** 存储方向值 给用户作为参照 */		
		public var direct:int;
		
		public function PadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}