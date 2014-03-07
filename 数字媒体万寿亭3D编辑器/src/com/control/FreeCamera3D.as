package com.control
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.geom.Vector3D;
	
	import away3d.cameras.Camera3D;

	public class FreeCamera3D
	{
		private var camera:Camera3D;
		public function FreeCamera3D(camera3D:Camera3D)
		{
			this.camera = camera3D;
//			updateCamera();
		}
		private var point3D:Vector3D = new Vector3D();//注视(0,0,0)
		private var _centerPoint3D:Vector3D = new Vector3D();//注视的中心点坐标(0,0,0)
		public function get centerPoint3D():Vector3D
		{
			return _centerPoint3D;
		}
		public function set centerPoint3D(value:Vector3D):void
		{
			_centerPoint3D = value;
			this.cameraPoint = value;
		}
		
//		private var isTween:Boolean;
//		public function moveTo(value:Vector3D,onComplete:Function = null,...args):void{
//			if(isTween)return;
//			TweenLite.to(this,.2,{overwrite:0,x:value.x,y:value.y,z:value.z,
//				onComplete:onComplete,
//				onCompleteParams:args,ease:Linear.easeNone});
//			isTween = true;
//		}
//		private function tempComplete(value:Vector3D):void{
//			this.cameraPoint = value; 
//		}
		
		public function set cameraPoint(value:Vector3D):void{
//			TweenLite.to(this,.001,{x:value.x,y:value.y,z:value.z,ease:Linear.easeNone});
//			point3D.x = value.x;
			var hasMax:Boolean = false;
			if(checkPointKey(value.x,"x",_maxRadiusX))hasMax = true;
			if(checkPointKey(value.z,"z",_maxRadiusZ))hasMax = true;
			if(!hasMax)point3D.y = value.y;
//			point3D.z = value.z;
			updateCamera();
		}
		/**
		 * @param value 目标数值
		 * @param nameKey 变化的关键字
		 * @param radius 边界大小
		 * @return 是否超过边界
		 */		
		private function checkPointKey(value:Number,nameKey:String,radius:Number):Boolean{
			if(value < _centerPoint3D[nameKey] - radius){
				point3D[nameKey] = _centerPoint3D[nameKey] - radius;
				return true;
			}else if(value > _centerPoint3D[nameKey] + radius){
				point3D[nameKey] = _centerPoint3D[nameKey] + radius;
				return true;
			}else{
				point3D[nameKey] = value;
			}
			return false;
		}
		
		public function get cameraPoint():Vector3D{
			return point3D;
		}
		
		public function get x():Number
		{
			return point3D.x;
		}
		public function set x(value:Number):void
		{
			point3D.x = value;
			updateCamera();
		}
		public function get y():Number
		{
			return point3D.y;
		}
		public function set y(value:Number):void
		{
			point3D.y = value;
			updateCamera();
		}
		public function get z():Number
		{
			return point3D.z;
		}
		public function set z(value:Number):void
		{
			point3D.z = value;
			updateCamera();
		}

		private var _defaultPanAngle:Number = 0;
		public function set defaultPanAngle(value:Number):void
		{
			_defaultPanAngle = value;
		}
		private var _defaultTiltAngle:Number = 0;//90;
		public function set defaultTiltAngle(value:Number):void
		{
			_defaultTiltAngle = value;
		}
		private var _defaultDistance:Number = 1000;
		public function set defaultDistance(value:Number):void
		{
			_defaultDistance = value;
		}
		private var _panAngle:Number = _defaultPanAngle;//横向旋转角度
		private var _tiltAngle:Number = _defaultTiltAngle;//纵向旋转角度
		private var _distance:Number = _defaultDistance;//当前半径
		
		private var _minPanAngle:Number = -Infinity;
		private var _maxPanAngle:Number = Infinity;
		private var _minTiltAngle:Number = 1;//;
		private var _maxTiltAngle:Number = 89;//90;
		private var _minDistance:Number = 0;
		private var _maxDistance:Number = Infinity;
		
		private var _maxRadiusX:Number = Infinity;//Infinity;//最大X向半径
		public function set maxRadiusX(value:Number):void
		{
			_maxRadiusX = value;
		}
		private var _maxRadiusZ:Number = Infinity;//Infinity;//最大Z向半径
		public function set maxRadiusZ(value:Number):void
		{
			_maxRadiusZ = value;
		}

		public function set minDistance(value:Number):void
		{
			_minDistance = value;
		}
		public function set maxDistance(value:Number):void
		{
			_maxDistance = value;
		}
		
		public function get distance():Number
		{
			return _distance;
		}
		public function set distance(value:Number):void
		{
			if(value < _minDistance){
				value = _minDistance;
			}else if(value > _maxDistance){
				value = _maxDistance;
			}
			if(_distance == value)return;
			_distance = value;
			updateCamera();
		}
		
		public function get panAngle():Number
		{
			return _panAngle;
		}
		public function set panAngle(value:Number):void
		{
			if(value < _minPanAngle){
				value = _minPanAngle;
			}else if(value > _maxPanAngle){
				value = _maxPanAngle;
			}
			if(_panAngle == value)return;
			_panAngle = value;
			updateCamera();
		}
		public function get tiltAngle():Number
		{
			return _tiltAngle;
		}
		public function set tiltAngle(value:Number):void
		{
			if(value < _minTiltAngle){
				value = _minTiltAngle;
			}else if(value > _maxTiltAngle){
				value = _maxTiltAngle;
			}
			if(_tiltAngle == value)return;
			_tiltAngle = value;
			updateCamera();
		}
		
		private function updateCamera():void
		{
			var horizontal:Number = _tiltAngle / 180 * Math.PI;
			var vertical:Number = _panAngle / 180 * Math.PI;
			camera.x = _distance * Math.sin(horizontal) * Math.cos(vertical) + point3D.x;
			camera.y = _distance * Math.cos(horizontal) + point3D.y;
			camera.z = _distance * Math.sin(horizontal) * Math.sin(vertical) + point3D.z;
			camera.lookAt(point3D);
			
			if(horizontal == 0){
				camera.roll(_panAngle + 90);
			}
			if(onUpdate != null)onUpdate();
		}		
		/**
		 * 摄像机横向平移
		 * @param value 移动距离 +-
		 */		
		public function moveHorizontal(value:Number):void{
			var vertical:Number = _panAngle / 180 * Math.PI;
//			point3D.z += value * Math.cos(vertical);
//			point3D.x -= value * Math.sin(vertical);
			checkPointKey(point3D.z + value * Math.cos(vertical),"z",_maxRadiusZ);
			checkPointKey(point3D.x - value * Math.sin(vertical),"x",_maxRadiusX);
			updateCamera();
		}
		/**
		 * 摄像机纵向平移
		 * @param value 移动距离 +-
		 */		
		public function moveVertical(value:Number):void{
			var horizontal:Number = _tiltAngle / 180 * Math.PI;
			var vertical:Number = _panAngle / 180 * Math.PI;
//			point3D.z += value * Math.cos(horizontal) * Math.sin(vertical);
//			point3D.x += value * Math.cos(horizontal) * Math.cos(vertical);
			var hasMax:Boolean = false;
			if(checkPointKey(point3D.z + value * Math.cos(horizontal) * Math.sin(vertical),"z",_maxRadiusZ))
				hasMax = true;
			if(checkPointKey(point3D.x + value * Math.cos(horizontal) * Math.cos(vertical),"x",_maxRadiusX))
				hasMax = true;
			if(!hasMax)point3D.y -= value * Math.sin(horizontal);
			updateCamera();
		}
		/**
		 * 恢复默认位置
		 */		
		public function reset():void{
			this.panAngle = _defaultPanAngle;//横向旋转角度
			this.tiltAngle = _defaultTiltAngle;//纵向旋转角度
			this.distance = _defaultDistance;//当前半径
			this.centerPoint3D = _centerPoint3D;
		}
		private var onUpdate:Function;
		public function setUpadeFuction(onUpdate:Function):void{
			this.onUpdate = onUpdate;
		}
		
		
	}
}