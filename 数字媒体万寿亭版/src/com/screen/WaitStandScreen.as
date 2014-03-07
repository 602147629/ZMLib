package com.screen
{
	import com.core.IMember;
	
	import feathers.controls.Screen;
	
	import starling.display.Quad;
	
	public class WaitStandScreen extends Screen implements IMember
	{
		private var back:Quad;//背景图片
		override protected function initialize():void
		{
			createBack();
			
		}
		
		private function createBack():void
		{
			back = new Quad(this.owner.normalWidth,this.owner.normalHeight);
			addChild(back);
		}
		
		public function setRemoteParams(id:int, typeID:String):void
		{
		}
		
		public function set memberData(obj:Object):void
		{
		}
	}
}