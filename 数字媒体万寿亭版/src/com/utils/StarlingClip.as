package com.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	/**
	 * @author skyMaster by GY
	 */	
	public class StarlingClip extends Sprite
	{
		//池 key:className value:Vector.<StaringClip>;
		private static var poolDic:Dictionary = new Dictionary(true);
		
		/**
		 * 创建一个实例 该实例要从池中进行检查
		 * @param cla
		 * @return 
		 */		
		public static function createClip(classType:Class,fps:int = 48,scale:Number = 1):StarlingClip{
			//先获取该完全限定类名
			if(poolDic[classType] == null){
				//如果该类型的数组没有创建的情况下 创建该类型的池数组
				poolDic[classType] = new Vector.<StarlingClip>;
			}
			var sc:StarlingClip = getInstance(poolDic[classType],classType,fps,scale);
			sc.gotoAndStop(1);
			return sc;
		}
		/**
		 * 通过查找该类型被回收实例的数组 
		 * 如果数组内有该回收实例的情况下 返回该实例 
		 * 没有就创建一个新的
		 * @param list
		 * @return 
		 */		
		private static function getInstance(list:Vector.<StarlingClip>,cla:Class,
											fps:int = 48,scale:Number = 1):StarlingClip
		{
			if(list.length != 0){
				return list.pop(); //返回旧的回收实例
			}
			var sc:StarlingClip = new StarlingClip(cla,fps,scale);
			sc.canRecycle = true;
			return sc; //如果没有回收的实例 只能创建新的实例
		}
		
		/**
		 * 将该实例回收利用
		 * @param obj
		 */		
		private static function recycle(sc:StarlingClip):void{
			//先获取该完全限定类名
			var list:Vector.<StarlingClip> = poolDic[sc.classType];
			if(list == null)return; //不是对象池创建的对象 无法回收
			//获取该类型需要回收的实例数组
			sc.alpha = sc.scaleX = sc.scaleY = 1;
			sc.rotation = sc.x = sc.y = 0;
			list.push(sc);
		}
		
		
		private static var clipPool:Dictionary = new Dictionary(true);
		private static var mcPool:Dictionary = new Dictionary(true);
		
		//存放从影片里面切出来的图片
		private var bitmapList:Vector.<ClipVo>;
		//用来渲染位图序列
		private var bitmapClip:Image;
		
		//private var _containSp:Sprite;
		//用来计算现在是第几帧
		private var _currentFrame:int = 0;//当前帧 从0开始找
		
		private var startFrame:int = -1; //循环播放起始帧
		private var endFrame:int = -1; //循环播放结束 帧
		private var loopTime:int; //循环次数

		private var loopEndFunc:Function; //循环结束后回调
		private var loopEndArgs:Array; //循环结束回调所需参数列表
		
		private var _source:MovieClip;
		private var dealy:Number; //1秒执行多少帧
		private var currentTime:Number;
		private var canRecycle:Boolean;
//		private var maxHeight:Number;
//		private var maxWidth:Number;
//		public override function get height():Number{
//			return maxHeight;
//		}
//		public override function get width():Number{
//			return maxWidth;
//		}
		private var _fps:int;
		public function get fps():int
		{
			return _fps;
		}
		public function set fps(value:int):void
		{
			_fps = value;
			dealy = 1000 / value;
		}
		/**
		 * 设置图片横向拉伸度
		 * @param value
		 */		
		/*public function set bmpScaleX(value:Number):void{
			bitmapClip.scaleX = value;
		}*/
		
		/**
		 * 
		 * @param value
		 */		
		private var _smoothing:Boolean;
		public function set smoothing(value:Boolean):void{
			_smoothing = value;
		}
		
		/**
		 * 设置图片纵向拉伸度
		 * @param value
		 */	
		public function set bmpScaleY(value:Number):void{
			bitmapClip.scaleY = value;
		}
		
		/*public function isClick(px:Number,py:Number):Boolean{
			var bd:BitmapData = bitmapClip.texture;
			if(!bd)return false;
			var toX:int = px - (x + bitmapClip.x);
			if(bitmapClip.scaleX == -1)toX = - px + (x - bitmapClip.x);
			var toY:int = py - (y + bitmapClip.y);
			
//			trace(toX,toY);
//			trace(bd.getPixel(10,20));
//			bd.fillRect(new Rectangle(toX,toY,10,10),0xFFFFFFFF);
//			trace(bd.getPixel32(toX,toY))
			return bd.getPixel32(toX,toY) > 0;
		}*/
		/**
		 * 从头到尾播放一次后自动回收
		 */		
		public function playOnce():void{
			playLoop(1,totalFrames,1,endpose);
		}
		/**
		 * 从start - end播放loop遍 结束后endFunc
		 */		
		public function playLoop(sFrame:*,eFrame:*,loop:int = -1,
								 endFunc:Function = null,...args):void{
			var s:int = getFrame(sFrame);
			var e:int = getFrame(eFrame);
			if(s == startFrame && e == endFrame)return;
			_currentFrame = startFrame = s;
			endFrame = e;
			loopTime = loop;
			loopEndFunc = endFunc;
			loopEndArgs = args;
			
			drawClip();
			currentTime = getTimer();
			start();
		}
		private static var empty:Texture;
		private var classType:Class;
		public function StarlingClip(classType:Class = null,fps:int = 48,scale:Number = 1)
		{
			super();
			this.classType = classType;
			if(empty == null)empty = Texture.empty(1,1);
			bitmapClip = new Image(empty);
			/*_containSp = new Sprite();
			_containSp.addChild(bitmap);
			addChild(_containSp);*/
			addChild(bitmapClip);
			this.fps = fps;
			if(classType){
				cutMap(classType,scale,scale);
//				addChild(_source);
//				_source.x = 50;
//				_source.y = 50;
//				_source.alpha = 1;
			}
		}
		
		public function get contain():Image
		{
			return bitmapClip;
		}

		public static function convert(movieClip:MovieClip,fps:int = 48):StarlingClip{
			var className:String = getQualifiedClassName(movieClip);
			var bitmapClip:StarlingClip = new StarlingClip();
			bitmapClip.ensureInstance(movieClip,className);
			bitmapClip.x = movieClip.x;
			bitmapClip.y = movieClip.y;
			bitmapClip.scaleX = movieClip.scaleX;
			bitmapClip.scaleY = movieClip.scaleY;
			bitmapClip.fps = fps;
			return bitmapClip;
		}
		
		/*public function setVersa(bool:Boolean):void{
			_containSp.scaleX = bool ? (-1):1;
		}*/
		
		public function get source():MovieClip{
			return _source;
		}
		
		/*public function getChild(name:String):DisplayObject{
			_source.gotoAndStop(currentFrame);
			return _source[name];
		}*/
		
		public function cutMap(classType:Class,sx:Number = 1,sy:Number = 1,
							   width:Number = 0,height:Number = 0,
							   offsetX:Number= NaN, offsetY:Number= NaN):void
		{
			if(classType == null){
				bitmapClip.texture = empty;
				return;
			}
			_currentFrame = 0;
//			maxHeight = 0;
//			maxWidth = 0;
			var className:String = getQualifiedClassName(classType);
			bitmapList = clipPool[className]; //通过类名先去寻找是否存在当前位图序列数组
			_source = mcPool[className];
			for (var key:* in scriptDic){
				delete scriptDic[key];
			}
			if(bitmapList != null && _source != null){
//				trace("重用SpriteClip序列:" + classType);
				drawClip();
				return; //如果已经切过了就用原来的
			}
			
			ensureInstance(new classType(),className,sx,sy,
				width,height,offsetX,offsetY);
			
			/*mcPool[className] = _source = new classType();//创建影片实例
			var totalFrames:int = _source.totalFrames;
			clipPool[className] = bitmapList = new Vector.<ClipVo>();
			
			for(var i:int = 1; i <= totalFrames; i++){
				_source.gotoAndStop(i); //先跳到当前帧 然后计算此帧影片的宽高 再绘制
				var cVo:ClipVo = new ClipVo();
				cVo.frameLabel = _source.currentFrameLabel;
				bitmapList.push(cVo);
			}*/
			
			drawClip();
			
//			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		private function getData(index:int):ClipVo{
			
			var cVo:ClipVo = bitmapList[index];
			if(cVo != null){
				return cVo;
			}
			 //先跳到当前帧 然后计算此帧影片的宽高 再绘制
			/*trace('-------------------------------','帧长度:' + _source.totalFrames + 
			' 当前帧:' +  _source.currentFrame);
			for (var i:int = 0; i < _source.numChildren; i++) 
			{
			trace(_source.getChildAt(i));
			}*/
			_source.gotoAndStop(index + 1);
			//if(_source.numChildren > 1)_source.removeChildAt(1);
			
			var mcWidth:Number = _source.width;
			if(mcWidth == 0){
				return cVo;
			}
			var mcHeight:Number = _source.height;
			var offSetX:Number = _source.getBounds(null).x;//getOffSetX(_source);
			var offSetY:Number = _source.getBounds(null).y;//getOffSetY(_source);
			cVo.x = offSetX;
			cVo.y = offSetY;
			var matrix:Matrix = new Matrix(1,0,0,1,-offSetX,-offSetY);
			var bitmapData:BitmapData = new BitmapData(mcWidth,mcHeight,true,0x00000000);
			bitmapData.lock();
			bitmapData.draw(_source,matrix);
			bitmapData.unlock();
			cVo.bitmapData = bitmapData;
			return cVo;
		}
		
		public function ensureInstance(mc:MovieClip,className:String,
									   sx:Number = 1,sy:Number = 1,
					w:Number = 0,h:Number = 0, ox:Number= NaN, oy:Number= NaN):void{
			/*bitmapList = clipPool[className]; //通过类名先去寻找是否存在当前位图序列数组
			_source = mcPool[className];
			if(bitmapList != null){
				//				trace("重用SpriteClip序列:" + classType);
				drawClip();
				return; //如果已经切过了就用原来的
			}
			clipPool[className] = bitmapList = new Vector.<ClipVo>(_source.totalFrames);
			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);*/
			
			mcPool[className] = _source = mc; //创建影片实例
			clipPool[className] = bitmapList = new Vector.<ClipVo>;
			//创建数组并用池保存数组 数组用来保存图片序列
			//遍历影片的所有帧，然后通过bitmapData去绘制
			var totalFrames:int = mc.totalFrames;
			if(sx != 1 && sy != 1){
				mc.scaleX = sx;
				mc.scaleY = sy;
				var tempSp:flash.display.Sprite = new flash.display.Sprite();
				tempSp.addChild(mc);
			}
			for(var i:int = 1; i <= totalFrames; ++i){
				mc.gotoAndStop(i); //先跳到当前帧 然后计算此帧影片的宽高 再绘制
				var mcWidth:Number = mc.width;
				var mcHeight:Number = mc.height;
				var cVo:ClipVo = new ClipVo();
				cVo.frameLabel = mc.currentFrameLabel;
				if(mcWidth == 0 && mcHeight == 0){
					bitmapList.push(cVo);
					continue;
				}
				var bounds:Rectangle = mc.getBounds(null);
				var offSetX:Number = bounds.x * sx;//getOffSetX(mc);
				var offSetY:Number = bounds.y * sy;//getOffSetY(mc);
				cVo.x = offSetX;
				cVo.y = offSetY;
				var matrix:Matrix = new Matrix(1,0,0,1,-offSetX,-offSetY);
				var bitmapData:BitmapData = new BitmapData(mcWidth,mcHeight,true,0x00000000);
				if(tempSp != null)bitmapData.draw(tempSp,matrix);
				else bitmapData.draw(mc,matrix);
				cVo.bitmapData = bitmapData;
				bitmapList.push(cVo);
			}
			tempSp = null;
			drawClip();
		}
		
		public function get totalFrames():int{
			return bitmapList ? bitmapList.length : 0;
		}
		
		public function get currentFrameLabel():String{
			if(!bitmapList[_currentFrame])return null;
			return bitmapList[_currentFrame].frameLabel;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame + 1;
		}
		
		/**
		 * 创建完毕开始播放动画
		 */		
		public function play():void{
			start();
			drawClip();
			startFrame = -1; //循环播放起始帧
			endFrame = -1; //循环播放结束帧
			currentTime = getTimer();
		}
		
		public function stop():void
		{
			startFrame = -1; //循环播放起始帧
			endFrame = -1; //循环播放结束帧
			drawClip();
			over();
		}
		
//		public function get isPlaying():Boolean{
//			return hasEventListener(Event.ENTER_FRAME);
//		}
		
		private var scriptDic:Object;
		public function addFrameScript(frame:*,...args):void{
			if(!scriptDic)scriptDic = {};
			scriptDic[frame] = args; //args function数组
		}
		
		public function gotoAndPlay(frame:*):void{
			_currentFrame = getFrame(frame);
			play();
		}
		
		private function getFrame(frame:*):int{
			if(frame is String){
				for each(var cVo:ClipVo in bitmapList){
					if(cVo && cVo.frameLabel == frame){
						var index:int = bitmapList.indexOf(cVo);
						if(index >= 0) return index;
						else return _currentFrame;
					}
				}
			}
			return frame - 1;
		}
		
		public function gotoAndStop(frame:*):void{
			_currentFrame = getFrame(frame);
			stop();
		}
		
		private static var texturePool:Dictionary = new Dictionary(true);
		private function getTexture(clipVo:ClipVo):Texture{
			if(texturePool[clipVo.id] === undefined){
				texturePool[clipVo.id] = Texture.fromBitmapData(clipVo.bitmapData);
				clipVo.bitmapData.dispose();
				clipVo.bitmapData = null;
			}
			return texturePool[clipVo.id];
		}
		private function drawClip():void
		{
			var clipVo:ClipVo = getData(_currentFrame);
			if(clipVo != null){
				bitmapClip.texture = getTexture(clipVo);
				bitmapClip.width = bitmapClip.texture.width;
				bitmapClip.height = bitmapClip.texture.height;
				this.pivotX = -clipVo.x //* bitmapClip.scaleX;
				this.pivotY = -clipVo.y //* bitmapClip.scaleY;
//				bitmapClip.smoothing = _smoothing ? TextureSmoothing.BILINEAR : TextureSmoothing.NONE;
//				flatten();
//				if(super.width > maxWidth)maxWidth = super.width;
//				if(super.height > maxHeight)maxHeight = super.height;
			}else{
				bitmapClip.texture = empty;
			}
			if(scriptDic){
				var funcArgs:Array = scriptDic[currentFrame];
				//先从当前帧上拿
				if(funcArgs){
					delete scriptDic[currentFrame];
				}else{
					funcArgs = scriptDic[currentFrameLabel];
					if(funcArgs)delete scriptDic[currentFrameLabel];
				}
				if(funcArgs){
					for each(var func:Function in funcArgs){
						func();
					}
				}
			}
		}
		
		private function clipLoop(e:EnterFrameEvent):void
		{
			var preTime:Number = getTimer();
			if((preTime - currentTime) < dealy)return;
			currentTime = preTime;
			_currentFrame ++;
			if(endFrame >= 0){
				drawClip();
				if(_currentFrame >= endFrame){
					if(loopTime != -1 && --loopTime == 0){
						stop();
						if(loopEndFunc != null){
							loopEndArgs ? loopEndFunc.apply(null,
								loopEndArgs) : loopEndFunc();
						}
						return;
					}
					_currentFrame = startFrame;
				}
				return;
			}
			if(_currentFrame > bitmapList.length - 1){
				_currentFrame = 0;
			}
			drawClip();
			if(currentFrameLabel && currentFrameLabel.split("_")[0] == "stop"){
				stop();
				return;
			}
		}
		
		
		private function start():void
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME,steper);
		}
		
		private function steper(e:EnterFrameEvent=null):void
		{
			clipLoop(e);
		}
		
		private function over():void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME,steper);
		}
		
		public function endpose(e:EnterFrameEvent = null):void{
			this.stop();
			startFrame = -1; //循环播放起始帧
			endFrame = -1; //循环播放结束帧
			if(this.parent) this.parent.removeChild(this);
			dispose();
			clear();
			if(canRecycle)StarlingClip.recycle(this);
		}
		
		public function clear():void{
			bitmapClip.texture = empty;
			bitmapClip.dispose();
		}
		
		public function clone():StarlingClip{
			var sc:StarlingClip = StarlingClip.createClip(classType,fps);
			sc.gotoAndStop(currentFrame);
			sc.x = this.x;
			sc.y = this.y;
			return sc;
		}
	}
}
import flash.display.BitmapData;

/**
 * 位图引擎专用vo 存储位图数据和偏移
 * @author Administrator
 */
class ClipVo{
	private static var clipId:int;
	public function ClipVo():void{
		this.id = clipId ++;
	}
	public var id:int;
	public var x:Number = 0;
	public var y:Number = 0;
	public var bitmapData:BitmapData;
	public var frameLabel:String;
}