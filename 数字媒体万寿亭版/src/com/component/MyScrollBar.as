
package com.component{
/*
================================================================================

《元件滚动条》

更改了对文本滚动控制改为对元件的控制，并增加缓动效果。
代码借鉴了：火山动态文本滚动条 V5 ，特此注明！

对象高度有变更时调用init函数。
--
2011-7-7 增加外部侦听接口，判断是否在滚动状态，修改更新滚动内容高度调用。
2012-8-15 修复拖动条出位问题。
2012-12-28 设置滚轮缓动效果，修改调用方式，优化计算等若干问题。
2013-4-19 因元件未添加到场景执行顺序导致访问对象没有属性的错误加ADDED_TO_STAGE事件。
          鼠标离开拖动条后的定位。
2013-4-24 将mask遮罩方式改为scrollRect方式，解决flash滚轮控制与浏览器滚轮控制的冲突
------------------------------------------------------------

Copyright (c) 2011 [无空]

My web:
  闪耀互动
  http://www.flashme.cn/
E-mail:
  flashme@live.cn

                                                  2011-3-4
================================================================================
*/
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.getTimer;


	public class MyScrollBar extends Sprite {

		//=============本类属性==============
		////接口元件
		private var scrollCon:*;
		private var scrollBar_sprite:Sprite;
		private var up_btn:SimpleButton;
		private var down_btn:SimpleButton;
		private var pole_sprite:Sprite;
		private var bg_sprite:Sprite;
		private var _area:uint,_height:uint,_width:uint;
		////初始数据
		private var poleStartHeight:Number;
		private var poleStartY:Number;
		private var totalPixels:Number;
		private var conHeight:Number;
		private var areaY:int;
		private var areaBg:uint;
		private var easingSpeed:uint=8;
		private var Drag:Boolean=false;
		////上下滚动按钮按钮下时间
		private var putTime:Number;
		private var wheelY:int;
		private var maskRect:Rectangle=new Rectangle(0,0,500,400);
		public static const ROLL:String="RollEvent";

		/**
		 * @param scrollCon_fc:被滚动的元件
		 * @param scrollBarMc_fc：舞台上与本类所代理的滚动条元件
		 * @param area_fc：显示区域
		 * @param height_fc：滚动条高
		 * @param width_fc：滚动条宽
		 */
		public function MyScrollBar(scrollCon_fc:*, scrollBarMc_fc:Sprite, area_fc:uint=0, height_fc:uint=0, width_fc:uint=0) {
			//——————滚动条_sprite，滚动条按钮和滑块mc，被滚动的文本域初始化
			scrollCon=scrollCon_fc;
			scrollBar_sprite=scrollBarMc_fc;
			up_btn=SimpleButton(scrollBar_sprite.getChildByName("up_btn"));
			down_btn=SimpleButton(scrollBar_sprite.getChildByName("down_btn"));
			pole_sprite=Sprite(scrollBar_sprite.getChildByName("pole_mc"));
			bg_sprite=Sprite(scrollBar_sprite.getChildByName("bg_mc"));
			_area=area_fc;
			_height=height_fc;
			_width=width_fc;
			
			scrollCon_fc.addEventListener(Event.ADDED_TO_STAGE,addCon);
			scrollBarMc_fc.addEventListener(Event.ADDED_TO_STAGE,addBar);
			
			
		}
		private function addBar(e:Event):void {
			e.target.removeEventListener(Event.ADDED_TO_STAGE,addBar);
			
			//——————注册侦听器
			//上滚动按钮
			up_btn.addEventListener(MouseEvent.MOUSE_DOWN, upBtn);
			up_btn.stage.addEventListener(MouseEvent.MOUSE_UP, upBtnUp);
			//下滚动按钮
			down_btn.addEventListener(MouseEvent.MOUSE_DOWN, downBtn);
			down_btn.stage.addEventListener(MouseEvent.MOUSE_UP, downBtnUp);
			//滑块
			pole_sprite.addEventListener(MouseEvent.MOUSE_DOWN, poleSprite);
			pole_sprite.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);
			//滑块背景点击
			bg_sprite.addEventListener(MouseEvent.MOUSE_DOWN, bgDown);
		}
		private function addCon(e:Event):void {
			e.target.removeEventListener(Event.ADDED_TO_STAGE,addCon);
			
			//鼠标滚轮
			scrollCon.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			scrollCon.scrollRect=maskRect;
			areaY = scrollCon.y;
			
			scrollCon.addEventListener(MouseEvent.MOUSE_OVER, handleMousIn);
			scrollCon.addEventListener(MouseEvent.MOUSE_OUT, handleMousOut);
			
			init(_area, 0, _height, _width);
			
		}
		/**
		 * @param area_fc：显示区域
		 * @param top_fc：重定义顶部起点
		 * @param height_fc：滚动条高
		 * @param width_fc：滚动条宽
		 */
		public function init(area_fc:uint=0, top_fc:int=0, height_fc:uint=0, width_fc:uint=0):void {
			//重置时需要中断之前的事件
			Drag=false;
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, poleDown);
			maskRect.y=ConNewY(pole_sprite.y);
			
			//areaY位置会重定义为scrollCon.y，scrollCon.y位置有变更。
			if(top_fc!=0){
				areaY = top_fc;
				scrollCon.y=areaY;
			}
			
			//——————可用性控制
			scrollBar_sprite.mouseChildren=false;
			pole_sprite.visible=false;
			//up_btn.enabled=false;
			//down_btn.enabled=false;

			//——————其他属性初始化
			
			if(area_fc==0){
				//未接收到高度定义时默认让其上下距离相等
				area_fc=scrollCon.parent.stage.stageHeight-areaY*2;
			}
			areaBg = area_fc;
			bg_sprite.useHandCursor=false;
			//
			//遮罩
			maskRect.width=scrollCon.width;
			maskRect.height=areaBg;
			
			if (height_fc==0) {
				bg_sprite.height=areaBg;
			} else {
				bg_sprite.height=height_fc;
			}
			if (width_fc!=0) {
				bg_sprite.width=width_fc+2;
				pole_sprite.width=width_fc;
				up_btn.width=up_btn.height=down_btn.width=down_btn.height=width_fc;
			}
			down_btn.y=bg_sprite.y+bg_sprite.height-down_btn.height-1;
			poleStartHeight=Math.floor(down_btn.y-up_btn.y-up_btn.height);
			poleStartY=pole_sprite.y=Math.floor(up_btn.y+up_btn.height);
			
			//调用函数更新高度
			renew();
		}
		
		private function renew():void {
			conHeight=getFullBounds(scrollCon).height;
			//判断滑块儿是否显示，并根据元件高度定义滑块高度
			if (conHeight>areaBg) {
				scrollBar_sprite.mouseChildren=true;
				pole_sprite.visible=true;
				up_btn.enabled=true;
				down_btn.enabled=true;
				//定义一个高度因子
				var heightVar:Number=areaBg/conHeight;
				//根据高度因子初始化滑块的高度
				pole_sprite.height=Math.floor(poleStartHeight*Math.pow(heightVar,0.3));
				//拖动条可响应的范围
				totalPixels=Math.floor(down_btn.y-up_btn.y-up_btn.height-pole_sprite.height);
				pole_sprite.y=PoleNewY(maskRect.y);
				scrollCon.scrollRect=maskRect;

			} else {
				scrollBar_sprite.mouseChildren=false;
				pole_sprite.visible=false;
				//up_btn.enabled=false;
				//down_btn.enabled=false;
			}
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, downBtnDown);
			scrollCon.removeEventListener(Event.ENTER_FRAME, WheelEnter);
		}

		/**
		 * 计算公式
		 */
		//以拖动条的位置计算来MC的位置，返回int值
		private function ConNewY(nowPosition:int):int {
			//外部判断在滚动时的侦听
			dispatchEvent(new Event(MyScrollBar.ROLL));
			//return -(conHeight-areaBg)*(nowPosition-poleStartY)/totalPixels +areaY;
			return (conHeight-areaBg)*(nowPosition-poleStartY)/totalPixels;
			
		}
		//以MC的位置来计算拖动条的位置，返回int值
		private function PoleNewY(nowPosition:int):int {
			//外部判断在滚动时的侦听
			dispatchEvent(new Event(MyScrollBar.ROLL));
			//return totalPixels*(areaY-nowPosition)/(conHeight-areaBg) +poleStartY;
			return totalPixels*nowPosition/(conHeight-areaBg) +poleStartY;
			
		}
		//解决设置scrollRect后获取DisplayObject.height不是原始高度的问题
		private function getFullBounds(displayObject : *):Rectangle {
			var transform:Transform = displayObject.transform;
			var currentMatrix:Matrix = transform.matrix;
			var toGlobalMatrix:Matrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix;
			var rect:Rectangle = transform.pixelBounds.clone();
			transform.matrix = currentMatrix;
			return rect;
		}

		/**
		 * 滑块滚动
		 */
		private function poleSprite(event : MouseEvent):void {
			Drag=true;
			//调用函数更新高度
			renew();
			//监听舞台，这样可以保证拖动滑竿的时候，鼠标在舞台的任意位置松手，都会停止拖动
			scrollBar_sprite.stage.addEventListener(MouseEvent.MOUSE_UP, poleUp);
			//限定拖动范围
			var dragRect:Rectangle=new Rectangle(pole_sprite.x,poleStartY,0,totalPixels);
			pole_sprite.startDrag(false, dragRect);
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, poleDown);
		}

		private function poleDown(event : Event):void {
			//在滚动过程中及时获得滑块所处位置
			var nowPosition:int=pole_sprite.y;
			//新位置
			var newY:int=ConNewY(nowPosition);
			//缓动效果，scrollCon.y的位置： scrollCon.y += ((计算出的新位置)-scrollCon.y)/缓动值
			maskRect.y += (newY - maskRect.y)/easingSpeed;
			if(Drag==false&&newY==maskRect.y){
				scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, poleDown);
				maskRect.y=ConNewY(nowPosition);
			}
			scrollCon.scrollRect=maskRect;

		}

		private function poleUp(event : MouseEvent):void {
			Drag=false;

			pole_sprite.stopDrag();
			scrollBar_sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
			//scrollCon.addEventListener(Event.SCROLL, textScroll);
		}

		/**
		 * 滑块背景点击
		 */
		private function bgDown(event : MouseEvent):void {
			//调用函数更新高度
			renew();
			var nowPosition:int;
			if ((scrollBar_sprite.mouseY-up_btn.y-up_btn.height) < (pole_sprite.height / 2)) {
				nowPosition=Math.floor(up_btn.y+up_btn.height);
			} else if ((down_btn.y - scrollBar_sprite.mouseY) < pole_sprite.height / 2) {
				nowPosition=Math.floor(down_btn.y-pole_sprite.height);
			} else {
				nowPosition=scrollBar_sprite.mouseY-pole_sprite.height/2;
			}
			pole_sprite.y=nowPosition;
			maskRect.y=ConNewY(nowPosition);
			scrollCon.scrollRect=maskRect;

		}

		/**
		 * 下滚动按钮
		 */
		private function downBtn(event : MouseEvent):void {
			//调用函数更新高度
			renew();
			if (maskRect.y<(conHeight-areaBg)) {
				maskRect.y+=10;
				var nowPosition:int=maskRect.y;
				pole_sprite.y=PoleNewY(nowPosition);
				scrollCon.scrollRect=maskRect;
			}
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime=getTimer();
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, downBtnDown);
		}

		private function downBtnDown(event : Event):void {
			if (getTimer()-putTime>500) {
				if (maskRect.y<(conHeight-areaBg)) {
					maskRect.y+=3;
					var nowPosition:int=maskRect.y;
					pole_sprite.y=PoleNewY(nowPosition);
					scrollCon.scrollRect=maskRect;
				}
			}
		}

		private function downBtnUp(event : MouseEvent):void {
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, downBtnDown);
		}

		/**
		 * 上滚动按钮
		 */
		private function upBtn(event : MouseEvent):void {
			//调用函数更新高度
			renew();
			if (maskRect.y>0) {
				maskRect.y-=10;
				var nowPosition:int=maskRect.y;
				pole_sprite.y=PoleNewY(nowPosition);
				scrollCon.scrollRect=maskRect;
			}
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime=getTimer();
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, upBtnDown);
		}

		private function upBtnDown(event : Event):void {
			if (getTimer()-putTime>500) {
				if (maskRect.y>0) {
					maskRect.y-=3;
					var nowPosition:int=maskRect.y;
					pole_sprite.y=PoleNewY(nowPosition);
					scrollCon.scrollRect=maskRect;
				}
			}
		}

		private function upBtnUp(event : MouseEvent):void {
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, upBtnDown);
		}

		/**
		 * 鼠标滚轮事件
		 */
		private function mouseWheel(event : MouseEvent):void {

			if(conHeight<areaBg){
				return;
			}
			//调用函数更新高度
			renew();
			wheelY=(maskRect.y-Math.floor(event.delta*80));
			
			if (event.delta<0) {
				wheelY=wheelY>(conHeight-areaBg)?conHeight-areaBg:wheelY;
			} else if (event.delta>0) {
				wheelY=wheelY<0?0:wheelY;
			}
			scrollCon.addEventListener(Event.ENTER_FRAME, WheelEnter);
		}
		private function WheelEnter(e:Event):void {
			
			maskRect.y += (wheelY-maskRect.y)/easingSpeed;
			
			pole_sprite.y=PoleNewY(maskRect.y);
			scrollCon.scrollRect=maskRect;
			if(maskRect.y==wheelY){
				scrollCon.removeEventListener(Event.ENTER_FRAME, WheelEnter);
			}
			
		}
		/**
		 * 解决鼠标滚轮的冲突
		 */
		private function handleMousIn(e:Event):void {
			mouseWheelEnabled(false);
		}

		private function handleMousOut(e:Event):void {
			mouseWheelEnabled(true);
		}
		public function mouseWheelEnabled(value:Boolean):void {
			if (! value) {
				ExternalInterface.call("eval", "var _onFlashMousewheel = function(e){e = e || event;e.preventDefault && e.preventDefault();e.stopPropagation && e.stopPropagation();return e.returnValue = false;};if(window.addEventListener){var type = (document.getBoxObjectFor)?'DOMMouseScroll':'mousewheel';window.addEventListener(type, _onFlashMousewheel, false);}else{document.onmousewheel = _onFlashMousewheel;}");
			} else {
				ExternalInterface.call("eval", "if(window.removeEventListener){var type = (document.getBoxObjectFor)?'DOMMouseScroll':'mousewheel';window.removeEventListener(type, _onFlashMousewheel, false);}else{document.onmousewheel = null;}");
			}
		}
		
		
		
	}
}