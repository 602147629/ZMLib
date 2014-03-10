package com.manager
{
	import com.event.DateChangeEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class DateManager
	{
		private static var dateDispatcher:EventDispatcher = new EventDispatcher();
		
		public static function addDateChange(onDate:Function):void{
			dateDispatcher.addEventListener(DateChangeEvent.DATE_CHANGE,onDate);
			Vision.visionStage.addEventListener(Event.ENTER_FRAME,onLoop);
		}
		
		private static function onLoop(e:Event):void
		{
			if(dateDispatcher.hasEventListener(DateChangeEvent.DATE_CHANGE)){
				var de:DateChangeEvent = new DateChangeEvent(DateChangeEvent.DATE_CHANGE);
				de.date = new Date();
				dateDispatcher.dispatchEvent(de);
			}
		}
	}
}