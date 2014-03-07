package com.component
{
	import com.greensock.TweenLite;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.model.MenuXMLData;
	import com.vo.MenuItemVo;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.ILayout;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MenuList extends Sprite
	{
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		public function MenuList(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
			initList();
		}
		
		private var _leftSkin:DisplayObject;
		public function get leftSkin():DisplayObject
		{
			return _leftSkin;
		}

		public function set leftSkin(value:DisplayObject):void
		{
			if(_leftSkin != null){
				removeChild(_leftSkin);
			}
			_leftSkin = value;
			_leftSkin.touchable = false;
			changeView();
		}
		private var _rightSkin:DisplayObject;
		public function get rightSkin():DisplayObject
		{
			return _rightSkin;
		}

		public function set rightSkin(value:DisplayObject):void
		{
			if(_rightSkin != null){
				removeChild(_rightSkin);
			}
			_rightSkin = value;
			_rightSkin.touchable = false;
			changeView();
		}
		
		private var _dataProvider:Object;
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				if(_dataProvider != null){
					list.stopScrolling();//停止滑动
					list.dataProvider = new ListCollection(_dataProvider);
					list.horizontalScrollPosition = 0;
					changeView();
				}
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _layout:ILayout;
		public function get layout():ILayout
		{
			return _layout;
		}
		private var _selectedItem:Object
		public function get selectedItem():Object
		{
			return list.selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			selectedIndex = list.dataProvider.getItemIndex(value);
		}
		public function get selectedIndex():int
		{
			return list.selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			list.selectedIndex = value;
			if(_dataProvider == null)return;
			var maxCount:int = MenuXMLData.menuLength - MenuXMLData.homeGap;//最多显示的个数
			if(list.maxHorizontalScrollPosition > 0 && list.selectedItem is MenuItemVo && 
				_dataProvider.length > maxCount){//超过最大数据量
				var itemWidth:Number = (list.selectedItem as MenuItemVo).itemWidth;
				var pos:Number = (value + (_layout as HorizontalLayout).gap) * itemWidth;//Vision.menuWidth;
				if(pos > list.maxHorizontalScrollPosition){
					pos = list.maxHorizontalScrollPosition;
				}
				TweenLite.to(list,.3,{horizontalScrollPosition:pos});
			}else{
				list.horizontalScrollPosition = 0;//回到原位
			}
		}
		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			_layout = list.layout = value;
//			changeView();
		}
		public function get itemRendererType():Class
		{
			return list.itemRendererType;
		}
//		private var _itemRendererType:Class;
		public function set itemRendererType(value:Class):void
		{
			list.itemRendererType = value;
		}
		
		private function changeView():void
		{
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
		}		
		private var list:List;//背景图片
		private function showView(e:Event = null):void{
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			initList();
			initSkin();
		}
		
		private function initSkin():void
		{
			if(_leftSkin != null){
				addChild(_leftSkin);
			}
			if(_rightSkin != null){
				addChild(_rightSkin);
				_rightSkin.x = actualWidth - _rightSkin.width;
			}
			checkSkin();
		}
		
		private function initList():void
		{
			if(list == null){
				list = new List();
				list.width = actualWidth;
				list.height = actualHeight;
				list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
				list.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
				addChild(list);
			}
//			list.itemRendererType = _itemRendererType;
//			list.layout = _layout;
//			trace("最大:" + ,"宽度:" + actualWidth);
			if(list.maxHorizontalScrollPosition > 0){//表示能滑动
				list.addEventListener(Event.SCROLL,onScrollComplete);
			}else{
				list.removeEventListener(Event.SCROLL,onScrollComplete);
			}
			list.addEventListener(Event.CHANGE, itemChange);
		}
		
		private function itemChange(e:Event):void
		{
			dispatchEvent(e);
		}
		
		private function onScrollComplete(e:Event):void
		{
			checkSkin();
		}
		
		private function checkSkin():void{
			if(list.maxHorizontalScrollPosition == 0){
//				_leftSkin.visible = false;
//				_rightSkin.visible = false;
				if(_leftSkin != null)TweenLite.to(_leftSkin,.2,{alpha:0});
				if(_rightSkin != null)TweenLite.to(_rightSkin,.2,{alpha:0});
				return;
			}
			if(list.horizontalScrollPosition <= 0){
				if(_leftSkin != null)TweenLite.to(_leftSkin,.2,{alpha:0});
				if(_rightSkin != null)TweenLite.to(_rightSkin,.2,{alpha:1});
//				_leftSkin.visible = false;
//				_rightSkin.visible = true;
			}else if(list.horizontalScrollPosition >= list.maxHorizontalScrollPosition){
//				_leftSkin.visible = true;
//				_rightSkin.visible = false;
				if(_leftSkin != null)TweenLite.to(_leftSkin,.2,{alpha:1});
				if(_rightSkin != null)TweenLite.to(_rightSkin,.2,{alpha:0});
			}
		}
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
	}
}