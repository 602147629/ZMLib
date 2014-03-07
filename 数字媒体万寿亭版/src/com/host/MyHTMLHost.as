package com.host
{
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;
	
	public class MyHTMLHost extends HTMLHost
	{   
		public function MyHTMLHost(defaultBehaviors:Boolean=false)
		{
			super(defaultBehaviors);
		}
		
		override public function createWindow(windowCreateOptions:HTMLWindowCreateOptions):HTMLLoader
		{
			trace("windowCreateOptions:" + windowCreateOptions);
			// all JS calls and HREFs to open a new window should use the existing window
			return htmlLoader;
		}
	}

}