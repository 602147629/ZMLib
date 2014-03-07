package com.control
{
	import com.event.PadEvent;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	/**
	 * 静态的全局交互控制器 可设置鼠标(手指) 键盘作为输入控制 
	 * 可设置输入方式甚至双输入 提供运动趋势参数抛送(自定义事件)
	 * @author GY
	 */	
	public class GamePad
	{
		private static var stage:Stage;
		//存储舞台实例
		
		public static const MODE_KEYBOARD:String = '1';
		public static const MODE_MOUSE:String = '2';
		public static const MODE_ALL:String = '3';
		//输入模式参数
		
		/**
		 * 设置操作输入的模式 '1'键盘 '2'鼠标 '3'皆可
		 */		
		public static function openMode(mode:String = MODE_ALL):void{
			switch(mode){
				case MODE_KEYBOARD:
					openKeyBoard();
					break;
				case MODE_MOUSE:
					openMouse();
					break;
				case MODE_ALL:
					openKeyBoard();
					openMouse();
					break;
			}
		}
		/**
		 * 注册舞台实例 进行存储
		 * @param s
		 */		
		public static function registerStage(s:Stage):void{
			stage = s;
		}
		
		/**
		 * 开启鼠标输入模式
		 */		
		private static function openMouse():void{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,downStage);
		}
		
		/**
		 * 当鼠标按下后 先纪录鼠标当前坐标
		 * 可以后松开后的坐标进行运动趋势判断
		 * @param e
		 */		
		private static var prePoint:Point;
		//手指按下时的坐标点
		private static function downStage(e:MouseEvent):void
		{
			prePoint = new Point(e.stageX,e.stageY);
			stage.addEventListener(MouseEvent.MOUSE_UP,upStage);
		}
		/**
		 * 将该监听移除掉 然后计算松开以后的鼠标坐标系和
		 * 之前保存的prePoint坐标之差来计算运动趋势
		 * @param e
		 */		
		private static function upStage(e:MouseEvent):void
		{
			//(e.stageX,e.stageY)  (prePoint.x,prePoint.y)
			//分别计算左右差值 dirtX dirtY (当前 - 前一个)
			//对左右差值绝对值进行比较 如果左右绝对值 > 上下 
			//趋势是横向的 只要判定dirtX的正负来sendDirect(左或右)
			//其他是纵向的 只要判定dirtY的正负来sendDirect(上或下)
			stage.removeEventListener(MouseEvent.MOUSE_UP,upStage);
			
			var dirtX:Number = e.stageX - prePoint.x;
			var dirtY:Number = e.stageY - prePoint.y;
			if(Math.abs(dirtX) > Math.abs(dirtY)){
				//趋势是横向的
				if(dirtX > 0){
					sendDirect(DIRECT_RIGHT);
				}else if(dirtX < 0){
					sendDirect(DIRECT_LEFT);
				}
			}else{
				//是纵向的
				if(dirtY > 0){
					sendDirect(DIRECT_DOWN);
				}else if(dirtY < 0){
					sendDirect(DIRECT_UP);
				}
			}
			
			
		}
		
		/**
		 * 开启键盘输入模式
		 */		
		private static function openKeyBoard():void{
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		
		public static const DIRECT_UP:int = 1;
		public static const DIRECT_DOWN:int = 2;
		public static const DIRECT_LEFT:int = 3;
		public static const DIRECT_RIGHT:int = 4;
		//定义四方向状态
		
		/**
		 * 当键盘松开的时候触发
		 * 对awsd和上下左右八个键分别进行判断是什么方向的
		 * 将方向值传入sendDirect方法中抛出事件
		 * @param e
		 */		
		private static function keyUpHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode){
				case Keyboard.A:
				case Keyboard.LEFT:
					sendDirect(DIRECT_LEFT);
					break;
				case Keyboard.W:
				case Keyboard.UP:
					sendDirect(DIRECT_UP);
					break;
				case Keyboard.D:
				case Keyboard.RIGHT:
					sendDirect(DIRECT_RIGHT);
					break;
				case Keyboard.S:
				case Keyboard.DOWN:
					sendDirect(DIRECT_DOWN);
					break;
			}
		}
		/**
		 * 接受方向状态值 抛出PadEvent事件 附带此参数direct
		 * 用stage抛送该事件
		 * @param direct
		 */		
		private static function sendDirect(direct:int):void{
			var pe:PadEvent = new PadEvent(PadEvent.CHANGE_DIRCET);
			pe.direct = direct;
			stage.dispatchEvent(pe);
		}
		/**
		 * 侦听改变方向事件 由外部传递处理函数
		 * @param func
		 */		
		public static function addChangeDirect(func:Function):void{
			stage.addEventListener(PadEvent.CHANGE_DIRCET,func);
		}
		/**
		 * 
		 * @param func
		 */		
		public static function removeChangeDirect(func:Function):void{
			stage.removeEventListener(PadEvent.CHANGE_DIRCET,func);
		}
		
		
		
		
		
	}
}