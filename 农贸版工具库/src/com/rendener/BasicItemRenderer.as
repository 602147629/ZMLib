package com.rendener
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicItemRenderer extends Sprite
	{
		public function BasicItemRenderer()
		{
			initialize();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		/**
		 * 初始化代码
		 */		
		protected function initialize():void
		{
			
		}
		protected function removedFromStageHandler(event:Event):void
		{
		}
		protected var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.commitData();
		}
		/**
		 * 数据获取完毕
		 */		
		protected function commitData():void
		{
			
		}
		
		protected var _index:int = -1;//排列的当前索引值
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			if(this._index == value)
			{
				return;
			}
			this._index = value;
		}
		
		protected var _isSelected:Boolean;
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
		}
		
		protected var _place:int = -1;//当前数据对应的索引值
		public function get place():int
		{
			return _place;
		}
		public function set place(value:int):void
		{
			if(this._place == value)
			{
				return;
			}
			this._place = value;
		}
		
		protected var _owner:Sprite;//父容器或列表
		public function get owner():Sprite
		{
			return this._owner;
		}
		public function set owner(value:Sprite):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
		}
		
		
	}
}