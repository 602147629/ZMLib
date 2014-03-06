package com.external
{
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import starling.text.TextField;

	public class ExternalInterfaceHandler
	{
		private static var _onCompleteFunc:Function;
		private static var _text:TextField;

		public static function init(handlerFunc:Function, text:TextField):void
		{
			_onCompleteFunc=handlerFunc;
			_text=text;

			if (ExternalInterface.available)
			{
				try
				{
					_text.text+="Adding callback 2013/9/29...\n";
					ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
					if (checkJavaScriptReady())
					{
						_text.text+="JavaScript is ready. 2013/9/29\n";
					}
					else
					{
						_text.text+="JavaScript is not ready, creating timer.\n";
						var readyTimer:Timer=new Timer(100, 0);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				}
				catch (error:SecurityError)
				{
					_text.text+="A SecurityError occurred: " + error.message + "\n";
				}
				catch (error:Error)
				{
					_text.text+="An Error occurred: " + error.message + "\n";
				}
			}
			else
			{
				_text.text+="External interface is not available for this container.";
			}
		}

		private static function receivedFromJavaScript(value:String,typeName:String):void
		{
			_text.text+="JavaScript says: " + value + typeName +"\n";
			if (_onCompleteFunc != null) _onCompleteFunc(value,typeName);
		}

		private static function checkJavaScriptReady():Boolean
		{
			var isReady:Boolean=ExternalInterface.call("isReady");
			return isReady;
		}

		private static function timerHandler(event:TimerEvent):void
		{
			_text.text+="Checking JavaScript status...\n";
			var isReady:Boolean=checkJavaScriptReady();
			if (isReady)
			{
				_text.text+="JavaScript is ready.\n";
				Timer(event.target).stop();
			}
		}

	}
}
