package com.component
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import feathers.events.ItemEvent;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class VerticalAutoList extends Sprite
	{
		private var _itemHeight:Number;//条目宽高
		public function set itemHeight(value:Number):void
		{
			_itemHeight = value;
			changeView();
		}
		private var _itemWidth:Number;
		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
			changeView();
		}
		
		private var _selectIcon:String;
		public function set selectIcon(value:String):void
		{
			_selectIcon = value;
			changeView();
		}
		
		private var _iconFiled:String = "icon";//图标关键字
		public function set iconFiled(value:String):void
		{
			_iconFiled = value;
			changeView();
		}
		
		private var _scaleRate:Number = .6;//横纵缩放比例
		public function set scaleRate(value:Number):void
		{
			_scaleRate = value;
			changeView();
		}
		
		private var _alhpaRate:Number = .7;//透明度变化比例
		public function set alhpaRate(value:Number):void
		{
			_alhpaRate = value;
			changeView();
		}
		
		private var _autoTime:Number = .5;//过度时间
		public function set autoTime(value:Number):void
		{
			_autoTime = value;
		}
		
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				changeView();
			}
		}
		private var _selectedIndex:int;
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
//			changeView();
			initView();
		}
//		private var _selectedItem:Object;
		public function get selectedItem():Object
		{
			return _dataProvider != null ? _dataProvider[_selectedIndex] : null;
		}
		public function set selectedItem(value:Object):void
		{
//			_selectedItem = value;
			selectedIndex = getItemIndex(value);
		}
		
		public function getItemIndex(item:Object):int{
			if(_dataProvider == null)return -1;
			for (var i:int = _dataProvider.length - 1; i >= 0; i--) 
			{
				if(_dataProvider[i] == item){
					return i;
				}
			}
			return -1;
		}
		
		private function changeView():void
		{
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
		}
		
		private function showView(e:Event = null):void{
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			initView();
		}
		
		private function initView():void
		{
			initIcon();
			if(_dataProvider == null || numChildren != _dataProvider.length){
				removeChildren();//重新布局 子实例个数不统一
			}
			if(_dataProvider != null){
				autoScale();//自动重对齐
			}
		}
		
		private function autoScale():void{
			var baseY:Number = 0;
			for (var i:int = 0; i < _dataProvider.length; i++) 
			{
				if(i < numChildren){
					var child:Sprite = getChildAt(i) as Sprite;
					var image:Image = child.getChildAt(0) as Image;
					StarlingLoader.loadImageFile(_dataProvider[i][_iconFiled],true,showImage,image);
				}else{
					child = new Sprite();
					addChild(child);
					image = new Image(Vision.TEXTURE_EMPTY);
					image.smoothing = TextureSmoothing.BILINEAR;
					child.addChild(image);
					StarlingLoader.loadImageFile(_dataProvider[i][_iconFiled],true,showImage,image);
					child.name = i + "";//名字就是索引
					child.addEventListener(TouchEvent.TOUCH,onTouch);
				}
				if(i == _selectedIndex){
					TweenLite.to(child,_autoTime,{y:baseY,scaleX:1,scaleY:1,alpha:1});
					baseY += _itemHeight;//计算坐标
				}else{
					TweenLite.to(child,_autoTime,{y:baseY,scaleX:_scaleRate,scaleY:_scaleRate,
						alpha:_alhpaRate});
					baseY += _itemHeight * _scaleRate;//计算坐标
				}
			}
			touchImage();
		}
		
		private function touchImage():void
		{
			var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
			ie.selectedIndex = _selectedIndex;
			ie.selectedItem = _dataProvider[_selectedIndex];
			dispatchEvent(ie);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){//点击事件
				var sp:Sprite = e.currentTarget as Sprite;
				_selectedIndex = int(sp.name);//获取点中索引值
				showIcon();
				autoScale();
			}
		}
		
		private function showImage(t:Texture,image:Image):void
		{
			image.texture = t;
			image.readjustSize();
			image.scaleX = Vision.widthScale;
			image.scaleY = Vision.heightScale;
			image.y = (_itemHeight - image.height) / 2;
		}
		
		private var iconImage:Image;
		private function initIcon():void
		{
			if(_selectIcon != null){
				StarlingLoader.loadImageFile(_selectIcon,true,onIconLoad);
			}else{
				iconImage.texture = Vision.TEXTURE_EMPTY;
			}
		}		
		
		private function onIconLoad(t:Texture):void
		{
			if(iconImage == null){
				iconImage = new Image(t);
				iconImage.scaleX = Vision.widthScale;
				iconImage.scaleY = Vision.heightScale;
			}else{
				iconImage.texture = t;
				iconImage.readjustSize();
			}
			showIcon();
		}		
		/**
		 * 将选中图标显示在对应容器中!!!
		 */		
		private function showIcon():void
		{
			if(iconImage == null)return;//图标还未初始化 或 不需要
			var child:Sprite = getChildByName(_selectedIndex + "") as Sprite;
			if(child != null){
				iconImage.x = _itemWidth;
				iconImage.y = (_itemHeight - iconImage.height) / 2;//纵向居中
				child.addChild(iconImage);
			}
		}
		
	}
}