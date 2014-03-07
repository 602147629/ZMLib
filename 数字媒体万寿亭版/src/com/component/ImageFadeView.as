package com.component
{
	import com.control.GamePad;
	import com.event.PadEvent;
	import com.greensock.TweenLite;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	
	import feathers.events.ItemEvent;
	
	import flash.events.MouseEvent;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ImageFadeView extends Sprite
	{
		private var actualWidth:Number;
		private var actualHeight:Number;
		public function ImageFadeView(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
		}
		private var _hideTitle:Boolean;//隐藏标题栏
		public function get hideTitle():Boolean
		{
			return _hideTitle;
		}
		public function set hideTitle(value:Boolean):void
		{
			_hideTitle = value;
			if(back != null){
				back.visible = !_hideTitle;
			}
			if(titleLabel != null){
				titleLabel.visible = !_hideTitle;
			}
		}
		private var _nodeSelectColor:uint = 0xffffff;
		public function set nodeSelectColor(value:uint):void
		{
			_nodeSelectColor = value;
		}
		private var _nodeEnabledColor:uint = 0x5d5d5d;
		public function set nodeEnabledColor(value:uint):void
		{
			_nodeEnabledColor = value;
		}
		
		private var _labelFiled:String = "label";//文字属性名
		public function get labelFiled():String
		{
			return _labelFiled;
		}
		public function set labelFiled(value:String):void
		{
			_labelFiled = value;
		}
		private var _iconFiled:String = "icon";//图片属性
		public function get iconFiled():String
		{
			return _iconFiled;
		}
		public function set iconFiled(value:String):void
		{
			_iconFiled = value;
		}
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _dragEnabled:Boolean;
		public function set dragEnabled(value:Boolean):void
		{
			_dragEnabled = value;
			showDrag();
		}
		
		private function showDrag():void
		{
			if(_dragEnabled){
				GamePad.addChangeDirect(changeDirect);
			}else{
				GamePad.removeChangeDirect(changeDirect);
			}
		}
		private function changeDirect(e:PadEvent):void
		{
			if(_dataProvider == null)return;//不能变化
			if(e.direct == GamePad.DIRECT_LEFT){
				clear();
				prevPage();
				shield();
			}else if(e.direct == GamePad.DIRECT_RIGHT){
				clear();
				nextPage();
				shield();
			}
		}
		
		private var touchEnd:Boolean;
		private function shield():void{
			if(!touchEnd){
				touchEnd = true;
				Vision.stage.addEventListener(MouseEvent.MOUSE_UP,resumeTouch);
			}
		}
		
		private function resumeTouch(e:MouseEvent):void
		{
			Vision.stage.removeEventListener(MouseEvent.MOUSE_UP,resumeTouch);
			touchEnd = false;
		}
		
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				if(value != null){
					showView();
					currentIndex = 0;//重新开始显示
					showImage();
				}else{
					clearState();
				}
//				loadImages();
			}
		}
		
		private function clearState():void
		{
			clear();
			if(backImage != null && backImage.texture != null){
				backImage.texture = Vision.TEXTURE_EMPTY;
			}
			if(fontImage != null && fontImage.texture != null){
				fontImage.texture = Vision.TEXTURE_EMPTY;
				TweenLite.killTweensOf(fontImage);
			}
			if(nodeContainer != null){
				nodeContainer.removeChildren(0,-1,true);
			}
		}
		
		private var imageLoaded:int;
		private function loadImages():void
		{
			imageLoaded = 0;
			for each (var obj:Object in _dataProvider) 
			{
				var iconUrl:String = obj[iconFiled];
				StarlingLoader.loadImageFile(iconUrl,true,tempLoad);
			}
		}
		
		private function tempLoad(t:Texture):void
		{
			if(++imageLoaded == _dataProvider.length){
				showImage();
			}
		}
		
		private function showView():void
		{
			initFace();
			createNode();
			addListeners();
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			addEventListener(TouchEvent.TOUCH,onImageTouch);
		}
		
		private function onImageTouch(e:TouchEvent):void
		{
			if(touchEnd)return;
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null){//点击事件
				if(touch.phase == TouchPhase.ENDED){
					touchScreen();
				}
			}
		}
		
		private function touchScreen():void
		{
			var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
			ie.selectedIndex = currentIndex;
			ie.selectedItem = _dataProvider[currentIndex];
			dispatchEvent(ie);
		}
		
		private function removeFromStage(e:Event):void
		{
			//从显示列表移除
			clear();
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
			GamePad.removeChangeDirect(changeDirect);//移除滑动事件
		}
		
		private function addToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			wait();//继续等待
			showDrag();
		}
		
		private static const QUAD_HEIGHT:Number = 40;
		private var back:Quad;
		private var fontImage:Image;//前后图片
		private var backImage:Image;
		private var titleLabel:TextField;//文本框
		private var nodeContainer:Sprite;//交互节点显示容器
		private function initFace():void
		{
			if(nodeContainer == null){
				back = new Quad(actualWidth,
					QUAD_HEIGHT * Vision.heightScale,0);
				back.alpha = .8;
				addChild(back);
				back.y = actualHeight - QUAD_HEIGHT * Vision.heightScale;
				
				titleLabel = new TextField(actualWidth * 5 / 6,
					(QUAD_HEIGHT + 10) * Vision.heightScale,"");
				titleLabel.fontSize = 16 * Vision.heightScale;
				titleLabel.bold = true;
				titleLabel.hAlign = HAlign.LEFT;
				titleLabel.vAlign = VAlign.CENTER;
				titleLabel.autoScale = true;
				titleLabel.x = 15 * Vision.heightScale;
				titleLabel.y = back.y + QUAD_HEIGHT / 2 * Vision.heightScale - titleLabel.height / 2 + 
					5 * Vision.heightScale;
				addChild(titleLabel);
				titleLabel.color = 0xFFFFFF;
				
				nodeContainer = new Sprite();
				addChild(nodeContainer);
				
				if(_hideTitle){
					back.visible = titleLabel.visible = false;
				}
			}
		}
		
		private function createNode():void
		{
			nodeContainer.removeChildren(0,-1,true);
			//移除子节点
			for (var i:int = _dataProvider.length - 1; i >= 0; i--) 
			{
				var image:Image = new Image(Vision.createNode(_nodeEnabledColor));//灰色
				nodeContainer.addChild(image);
				image.x = 20 * Vision.widthScale * i;
				image.name = "node_" + i;
			}
			nodeContainer.x = actualWidth - 17 * Vision.widthScale - nodeContainer.width;
			nodeContainer.y = actualHeight - (QUAD_HEIGHT / 2 + 5) * Vision.heightScale;
			//5是小球半径
		}
		//显示某一张图片
		private function showImage(index:int = 0):void
		{
			hideFront();
			if(_dataProvider.length > 0){
				var iconUrl:String = _dataProvider[index][iconFiled];
				StarlingLoader.loadImageFile(iconUrl,true,loadImage);
				showInfo();
			}
		}
		
		private function showInfo():void
		{
			var nextNode:Image = nodeContainer.getChildByName("node_" + currentIndex) as Image;
			if(nextNode != null){//亮起来
				nextNode.texture = Vision.createNode(_nodeSelectColor);
			}
			if(!_hideTitle){
				titleLabel.text = _dataProvider[currentIndex][labelFiled];//显示文字
			}
		}
		//前一张隐藏
		private function hideFront():void
		{
			if(backImage != null && backImage.texture != null){
				fontImage = initImage(fontImage,backImage.texture,1);
				fontImage.alpha = 1;
				TweenLite.to(fontImage,.5,{alpha:0,onComplete:wait});
			}else{
				wait();//先进行等待
			}
		}
		
//		private function getNextIndex():int{
//			var nextIndex:int = currentIndex;
//			if(++nextIndex > _dataProvider.length - 1){
//				nextIndex = 0;
//			}
//			return nextIndex;
//		}
		
		private var currentIndex:int;
		private function wait():void{
//			TweenLite.to(this,3,{onComplete:next});
			TimerManager.setTimeOut(3000,nextPage);
		}
		private function clear():void{
//			TweenLite.killTweensOf(this);
			TimerManager.clearTimeOut(nextPage);
		}
		
		private function prevPage():void{
			resume();
			if(-- currentIndex < 0){
				currentIndex = _dataProvider.length - 1;
			}
			showImage(currentIndex);
		}
		
		private function resume():void{
			var nowNode:Image = nodeContainer.getChildByName("node_" + currentIndex) as Image;
			if(nowNode != null){
				//					node = initImage(node,Vision.createNode(0x318c0d));
				nowNode.texture = Vision.createNode(_nodeEnabledColor);
			}
		}
		
		private function nextPage():void{
			resume();
			if(++ currentIndex > _dataProvider.length - 1){
				currentIndex = 0;
			}
			showImage(currentIndex);
		}
		private function loadImage(t:Texture):void
		{
			backImage = initImage(backImage,t);
		}
		
		private function initImage(image:Image,t:Texture,index:int = 0):Image{
			if(image == null){
				image = new Image(t);
				image.smoothing = TextureSmoothing.BILINEAR;
				addChildAt(image,index);
			}else{
				image.texture = t;
				image.width = t.width;
				image.height = t.height;
			}
			image.scaleX = Vision.widthScale;
			image.scaleY = Vision.heightScale;
			return image;
		}
		
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
	}
}