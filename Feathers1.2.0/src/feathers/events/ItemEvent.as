package feathers.events
{
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class ItemEvent extends Event
	{
		public static const ITEM_CLICK:String = 'ItemEvent.ITEM_CLICK';
		public static const ITEM_OVER:String = 'ItemEvent.ITEM_OVER';
		public static const ITEM_OUT:String = 'ItemEvent.ITEM_OUT';
		public static const ITEM_CHANGE:String = 'ItemEvent.ITEM_CHANGE';
		
		public var preItem:DisplayObject;//前一个被点中的条目视图
		public var item:DisplayObject;//点中的条目视图
		public var selectedIndex:int;//条目索引值
		public var selectedItem:Object;//点中的条目数据
		public var value:Object;//附带参数
		
		public function ItemEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
		
	}
}