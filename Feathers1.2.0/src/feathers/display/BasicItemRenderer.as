package feathers.display
{
	import flash.geom.Point;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class BasicItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public function BasicItemRenderer()
		{
			super();
			//initialize();//初始视图
			//commitData();//初始化数据
			//layout();//根据最新尺寸再次布局当前视图
			//注:记得要重写宽高来确定组件的边缘像素 方便布局
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		//重写该方法创建视图元件
		//		override protected function initialize():void
		//		{
		//			if(!this.itemLabel)
		//			{
		//				this.itemLabel = new Label();
		//				this.addChild(this.itemLabel);
		//			}
		//		}
		
		protected function removedFromStageHandler(event:Event):void
		{
			this.touchPointID = -1;
		}
		
		private static const HELPER_POINT:Point = new Point();
		protected var touchPointID:int = -1;
		protected function touchHandler(e:TouchEvent):void
		{
//			var touch:Touch = e.getTouch(this);
//			if(touch != null){
//				if(touch.phase == TouchPhase.ENDED){
//					this.isSelected = true;
//				}
//			}
			const touches:Vector.<Touch> = e.getTouches(this);
			if(touches.length == 0)
			{
				//hover has ended
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					
					touch.getLocation(this, HELPER_POINT);
					//check if the touch is still over the target
					//also, only change it if we're not selected. we're not a toggle.
					if(this.hitTest(HELPER_POINT, true) != null && !this._isSelected)
					{
						this.isSelected = true;
					}
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.touchPointID = touch.id;
						return;
					}
				}
			}
		}
		
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			if(dataInvalid)
			{
				this.commitData();
			}
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
		//自动布局
		protected function autoSizeIfNeeded():Boolean
		{
//			const needsWidth:Boolean = isNaN(this.explicitWidth);
//			const needsHeight:Boolean = isNaN(this.explicitHeight);
//			if(!needsWidth && !needsHeight)
//			{
//				return false;
//			}
////			this.itemLabel.width = NaN;
////			this.itemLabel.height = NaN;
//			this.validate();
//			var newWidth:Number = this.explicitWidth;
//			if(needsWidth)
//			{
//				newWidth = this.width;
//			}
//			var newHeight:Number = this.explicitHeight;
//			if(needsHeight)
//			{
//				newHeight = this.height;
//			}
//			return this.setSizeInternal(newWidth, newHeight, false);
			return false;
		}
		//重写该方法获取数据
		protected function commitData():void
		{
//			if(this._data)
//			{
//				this.itemLabel.text = this._data.toString();
//			}
//			else
//			{
//				this.itemLabel.text = "";
//			}
		}
		//重写该方法让视图重新布局
		protected function layout():void
		{
//			this.itemLabel.width = this.actualWidth;
//			this.itemLabel.height = this.actualHeight;
//			trace("组件宽高:" + this.actualWidth,this.actualHeight);
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
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected var _index:int = -1;
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
			this.invalidate(INVALIDATION_FLAG_DATA);
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
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get owner():List
		{
			return List(this._owner);
		}
		protected var _owner:List;
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
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
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}