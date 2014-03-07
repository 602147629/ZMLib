package com.event
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public var postion:Number;//已经滑动的位置
		public static const SCROLL:String = "SCROLL";
		
		public function ScrollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}