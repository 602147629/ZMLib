package
{
	import com.engine.AwayEngine;
	import com.engine.PowerEngine;
	import com.manager.Vision;
	import com.model.GameModel;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	//	[SWF(width="1080",height="1920",frameRate="60",backgroundColor = 0xFFFFFF)]
	[SWF(width="800",height="650",frameRate="60",backgroundColor = 0xFFFFFF)]
	public class Main extends Sprite
	{
		public function Main()
		{
			//			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(flash.events.Event.ADDED_TO_STAGE,addToStage);
			//			Share.clear();
			stage.nativeWindow.addEventListener(Event.CLOSE,onClose);
		}
		
		private function onClose(e:Event):void
		{
			trace("窗口关闭保存数据");
			GameModel.saveAll();
		}
		
		private function addToStage(e:flash.events.Event):void
		{
			Vision.stage = stage;
			Vision.root = this;
			//			MouseWheelEnabler.init(this.stage);//禁止浏览器滚轮事件
			removeEventListener(flash.events.Event.ADDED_TO_STAGE,addToStage);
			initProxies();
		}
		private function initProxies():void
		{
			PowerEngine.backgroundColor = 0;
			PowerEngine.createEngine(GameMain,stage,2/*,CarSence.start*//*,StageBackground*/);
		}
		
		
	}
}