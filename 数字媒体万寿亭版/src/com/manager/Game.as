package com.manager
{
	import com.control.GamePad;
	import com.engine.AwayEngine;
	import com.model.FarmDataBase;
	import com.view.CoreMember;
	import com.view.FarmMenu;
	import com.view.StandMember;
	import com.view.VideoWindow;

	public class Game
	{
		public static function ready():void{
			AwayEngine.showStats = FarmDataBase.showState;
			
			GamePad.registerStage(Vision.stage);
			GamePad.openMode();
			FontManager.register();
			start();
		}
		
		public static function start():void
		{
			VideoWindow.getInstance().show();
			CoreMember.getInstance().show();
			FarmMenu.getInstance().show();
			StandMember.getInstance().showDefault();
		}
	}
}