package com.control
{
	import com.utils.KeyboardUtil;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class FreeCameraControl
	{
		private static var freeCameraControl:FreeCameraControl;
		public static function getInstance():FreeCameraControl{
			if(freeCameraControl == null)freeCameraControl = new FreeCameraControl();
			return freeCameraControl;
		}
		
		private var _freeCamera:FreeCamera3D;
		public function set freeCamera(value:FreeCamera3D):void
		{
			_freeCamera = value;
		}
		private var _stage:Stage;
		public function set stage(value:Stage):void
		{
			_stage = value;
			KeyboardUtil.start(value);
			open();
		}
		
		private var _twoToTreeRate:Number = .2;
		/*public function get twoToTreeRate():Number
		{
		return _twoToTreeRate;
		}*/
		public function set twoToTreeRate(value:Number):void
		{
			_twoToTreeRate = value;
		}
		
		private var _keyBoardTurn:Boolean = true;//键盘支持旋转
		public function get keyBoardTurn():Boolean
		{
			return _keyBoardTurn;
		}
		public function set keyBoardTurn(value:Boolean):void
		{
			_keyBoardTurn = value;
			if(value){
				_stage.addEventListener(Event.ENTER_FRAME,onLoop);
			}else{
				_stage.removeEventListener(Event.ENTER_FRAME,onLoop);
			}
		}
		//		public function FreeCameraControl(stage:Stage,freeCamera)
		//		{
		//			this.freeCamera = freeCamera;
		//			this.stage = stage;
		//			Stage.mouseLock = true;
		//			open();
		//		}
		
		private var cameraEnabled:Boolean = true;
		public function open():void{
			cameraEnabled = true;
//			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			if(_keyBoardTurn)_stage.addEventListener(Event.ENTER_FRAME,onLoop);
		}
		
		private function onLoop(e:Event):void
		{
			if(!cameraEnabled)return;
			if(KeyboardUtil.keyIsDown(Keyboard.UP) || KeyboardUtil.keyIsDown(Keyboard.W)){
				_freeCamera.tiltAngle -= 5;
			}else if(KeyboardUtil.keyIsDown(Keyboard.DOWN) || KeyboardUtil.keyIsDown(Keyboard.S)){
				_freeCamera.tiltAngle += 5;
			}else if(KeyboardUtil.keyIsDown(Keyboard.LEFT) || KeyboardUtil.keyIsDown(Keyboard.A)){
				_freeCamera.panAngle -= 1;
			}else if(KeyboardUtil.keyIsDown(Keyboard.RIGHT) || KeyboardUtil.keyIsDown(Keyboard.D)){
				_freeCamera.panAngle += 1;
			}else if(KeyboardUtil.keyIsDown(Keyboard.SPACE)){
				reset();
			}else if(KeyboardUtil.keyIsDown(Keyboard.I)){
				_freeCamera.moveVertical(- 5 * _twoToTreeRate);
			}else if(KeyboardUtil.keyIsDown(Keyboard.K)){
				_freeCamera.moveVertical( 5 * _twoToTreeRate);
			}else if(KeyboardUtil.keyIsDown(Keyboard.J)){
				_freeCamera.moveHorizontal( -5 * _twoToTreeRate);
			}else if(KeyboardUtil.keyIsDown(Keyboard.L)){
				_freeCamera.moveHorizontal( 5 * _twoToTreeRate);
			}
		}
		
		public function reset():void
		{
			_freeCamera.reset();
			movePowerX = movePowerY = 0;
		}
		
		public function close():void{
			cameraEnabled = false;
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			_stage.removeEventListener(Event.ENTER_FRAME,onLoop);
		}
		private var _perDistance:Number = 100;//放大镜每次移动的距离
		public function set perDistance(value:Number):void
		{
			_perDistance = value;
		}
		
		private function onWheel(e:MouseEvent):void
		{
			if(!cameraEnabled)return;
			zoomCamera(e.delta > 0);
		}
		
		public function zoomCamera(isLarge:Boolean = false):void{
			if(isLarge){
				_freeCamera.distance -= _perDistance;
			}else{
				_freeCamera.distance += _perDistance;
			}
		}
		
		private var prePoint:Point = new Point();
		private function onMouseDown(e:MouseEvent):void
		{
			if(!cameraEnabled)return;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			prePoint.x = _stage.mouseX;
			prePoint.y = _stage.mouseY;
		}		
		
		private function onMouseUp(e:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private var movePowerX:Number = 0;//当前的移动值
		private var minPowerX:Number = -200;
		private var maxPowerX:Number = 200;
		private var movePowerY:Number = 0;//当前的移动值
		private var minPowerY:Number = -200;
		private var maxPowerY:Number = 200;
		
		private function onMouseMove(e:MouseEvent):void
		{
			if(!cameraEnabled)return;
			var dirtX:Number = _stage.mouseX - prePoint.x;
			var dirtY:Number = _stage.mouseY - prePoint.y;
			prePoint.x = _stage.mouseX;
			prePoint.y = _stage.mouseY;
			//			trace("dirtX:" + dirtX,"dirtY:" + dirtY);
//			if(movePowerX + dirtX < minPowerX){
//				//				dirtX = minPower - movePower;
////				movePowerX = minPowerX;
//				dirtX = 0;
//			}else if(movePowerX + dirtX > maxPowerX){
//				//				dirtX = maxPower - movePower;
////				movePowerX = maxPowerX;
//				dirtX = 0;
//			}
//			if(movePowerY + dirtY < minPowerY){
////				movePowerY = minPowerY;
//				dirtY = 0;
//			}else if(movePowerY + dirtY > maxPowerY){
////				movePowerY = maxPowerY;
//				dirtY = 0;
//			}
			if(dirtX != 0){
				movePowerX += dirtX;
				_freeCamera.moveHorizontal(-dirtX * _twoToTreeRate);
			}
			if(dirtY != 0){
				movePowerY += dirtY;
				_freeCamera.moveVertical(-dirtY * _twoToTreeRate);
			}
		}
	}
}