package com.event
{
	import flash.events.Event;
	
	public class DateChangeEvent extends Event
	{
		public static const DATE_CHANGE:String = "dateChange";
		
		public var date:Date;
		
		public function DateChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}