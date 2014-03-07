package com.component
{
	import com.greensock.TweenLite;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.utils.StarlingConvert;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * 滚动显示文本数据组件
	 */	
	public class AutoScrollText extends ScrollContainer
	{
		public function AutoScrollText(w:Number,h:Number){
			super();
			this.width = actualWidth = w;
			this.height = actualHeight = h;//交互区域大小
			scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
		}
		
		private var _textColor:uint;
		public function set textColor(value:uint):void
		{
			_textColor = value;
			changeView();
		}

		private var _text:String;
		public function get text():String
		{
			return _text;
		}
		private var isChangeText:Boolean;
		public function set text(value:String):void
		{
			if(_text != value){
				_text = value;
				isChangeText = true;
				changeView();
			}
		}
		private var _scrollSpeed:Number = 1;//卷动速度
		public function set scrollSpeed(value:Number):void
		{
			_scrollSpeed = value;
		}
		
//		private var _containHeight:Number;//包含区域的高度
//		public function get containHeight():Number
//		{
//			return _containHeight;
//		}
//		public function set containHeight(value:Number):void
//		{
//			_containHeight = value;
//			changeView();
//		}
//		private var _containWidth:Number;//包含的区域宽度
		
		
		private var _fontSize:Number = 12;//字号大小
		public function set fontSize(value:Number):void
		{
			_fontSize = value;
			changeView();
		}

		private var _minGap:Number = 50;//两个文本之间最小间距
		public function set minGap(value:Number):void
		{
			_minGap = value;
			changeView();
		}
		
		private function changeView():void
		{
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:Event):void
		{
			move();
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function removeFromStage(e:Event):void
		{
			stop();
		}
		
		private function showView(e:Event = null):void{
			//			this.clipRect = new Rectangle(0,0,actualWidth,actualHeight);
			//显示区域大小
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			createText();
			if(stage != null){//需要显示
				move();
			}
		}
		
		private var txtLabel1:TextField;//交替显示两个文本框
		private var txtLabel2:TextField;
		private function createText():void
		{
			txtLabel1 = initText(txtLabel1);
			txtLabel2 = initText(txtLabel2);
		}
		
		private function initText(txt:TextField):TextField{
//			if(!isNaN(_containHeight)){
//				var h:Number = _containHeight;
//			}else{
//				h = (_fontSize + 15) * Vision.heightScale;
//			}
			var h:Number = actualHeight;
			if(txt == null){
				txt = StarlingConvert.createText(1,h,
					_fontSize * Vision.normalScale,_textColor,_text);
				txt.autoSize = TextFieldAutoSize.HORIZONTAL;//横向延伸
				addChild(txt);
			}else{
				txt.height = h;
				txt.fontSize = _fontSize * Vision.normalScale;
				txt.color = _textColor;
//				txt.text = _text;
			}
			return txt;
		}
		
		private function reset(tweenShow:Boolean = true):void{
			txtLabel1.text = txtLabel2.text = _text;
			if(txtLabel1.width + 2 * _minGap < actualWidth){
				//minGap不够最小距离
				gap = (actualWidth - txtLabel1.width) / 2;
			}else{
				gap = _minGap;
			}
			txtLabel1.x = actualWidth;
			txtLabel2.x = txtLabel1.x + txtLabel1.width + gap;
			isChangeText = false;
			if(tweenShow)TweenLite.to(this,.5,{alpha:1,onComplete:moveStart});
		}
		
		private function moveStart():void{
			TimerManager.setIntervalOut(20,moveRendener);
		}
		
		private var gap:Number;
		private function move():void{
			if(txtLabel1 == null)return;
			if(isChangeText){
				TweenLite.to(this,.5,{alpha:0,onComplete:reset});
			}else{
				reset(false);
				moveStart();
			}
		}
		
		public function stop():void
		{
			TimerManager.clearIntervalOut(moveRendener);
			TweenLite.killTweensOf(this);//停止缓动测试
		}
		/**
		 * 每帧开始运动后执行
		 */		
		private function moveRendener():void
		{
			txtLabel1.x -= _scrollSpeed;
			txtLabel2.x -= _scrollSpeed;
			if(txtLabel1.x < -txtLabel1.width){
				txtLabel1.x = txtLabel2.x;
				txtLabel2.x = txtLabel1.x + txtLabel1.width + gap;
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