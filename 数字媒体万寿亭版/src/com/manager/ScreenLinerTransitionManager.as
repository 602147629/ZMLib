package com.manager
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import feathers.controls.ScreenNavigator;
	
	import starling.display.DisplayObject;

	public class ScreenLinerTransitionManager
	{
		protected var duration:Number = 0.25;
		protected var delay:Number = 0.1;
		
		private var navigator:ScreenNavigator;
		public function ScreenLinerTransitionManager(navigator:ScreenNavigator)
		{
			this.navigator = navigator;
			navigator.transition = onTransition;
		}
		
		private var oldTween:TweenLite;
		private var newTween:TweenLite;
		
		/**
		 * The function passed to the <code>transition</code> property of the
		 * <code>ScreenNavigator</code>.
		 */
		protected function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, 
										onComplete:Function):void
		{
			var oldIndex:int = navigator.getScreenIndex(oldScreen);
			var newIndex:int = navigator.getScreenIndex(newScreen);
			clear();
			if(oldIndex < newIndex){
				newScreen.x = this.navigator.normalWidth;
//				TweenLite.killTweensOf(newScreen);
				newTween = TweenLite.to(newScreen,duration,{overwrite:2,delay:delay,x:0,onComplete:onComplete});
				if(oldScreen != null)
					oldTween = TweenLite.to(oldScreen,duration,{overwrite:2,delay:delay,x:-navigator.normalWidth,
						onComplete:reset,onCompleteParams:[oldScreen]});
			}else{
				newScreen.x = -this.navigator.normalWidth;
				newTween = TweenLite.to(newScreen,duration,{overwrite:2,delay:delay,x:0,onComplete:onComplete});
				if(oldScreen != null)
					oldTween = TweenLite.to(oldScreen,duration,{overwrite:2,delay:delay,x:navigator.normalWidth,
						onComplete:reset,onCompleteParams:[oldScreen]});
			}
		}
		
		private function reset(screenDpo:DisplayObject):void{
			screenDpo.x = 0;
		}
		
		private function clear():void
		{
			if(newTween != null){
				newTween.kill();
				newTween = null;
			}
			if(oldTween != null){
				oldTween.kill();
				oldTween = null;
			}
		}
	}
}