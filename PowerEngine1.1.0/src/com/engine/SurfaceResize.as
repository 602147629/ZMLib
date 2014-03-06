package com.engine
{
	import flash.events.Event;

	public class SurfaceResize
	{
		protected function initSize():void{
//			AwayEngine.addResize(onResize);
		}
		protected function removeSize():void{
			AwayEngine.removeResize(onResize);
		}
		private function onResize(e:Event):void
		{
			resize();
		}
		protected function resize():void{
			
		}
	}
}