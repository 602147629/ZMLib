package com.manager
{
	import com.view.CoreMember;
	import com.view.Game3DView;
	import com.view.GameMenu;

	public class Game
	{
		public static function ready():void{
			start();
		}
		
		public static function start():void
		{
			GameMenu.getInstance().show();
			Game3DView.getInstance().show();
			CoreMember.getInstance().show();
		}
	}
}