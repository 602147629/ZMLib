package 
{
	import com.engine.AwayEngine;
	import com.engine.PowerEngine;
	import com.manager.Game;
	import com.manager.Vision;
	
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class GameMain extends Sprite
	{
		
		public function GameMain()
		{
//			var theme:MetalWorksMobileTheme = new MetalWorksMobileTheme();
//			createBackGround();
			//初始化层次
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			Vision.createGpu(this);
//			Vision.shield();
			AwayEngine.showStats = true;
			PowerEngine.fieldOfView = 10;//70;
			onInfoComplete();
		}
		
		private function onInfoComplete():void
		{
			Game.ready();
		}
		
//		private function createBackGround():void
//		{
//			var quad:Quad = new Quad(Vision.senceWidth,Vision.senceHeight,0xFFFFFF);
//			quad.touchable = false;
//			addChild(quad);
//		}
	}
}