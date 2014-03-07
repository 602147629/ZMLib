package com.utils
{
	import com.manager.Vision;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	 * 封装MovieClip实例进行位图优化 按照MovieClip的调用形式创建相关跳帧API
	 * @author skyMaster by GY
	 */	
	public class SpriteClip extends Sprite
	{
		private static var clipPool:Dictionary = new Dictionary();
		private static var mcPool:Dictionary = new Dictionary();
		
		//存放从影片里面切出来的图片
		private var bitmapList:Vector.<ClipVo>;
		//用来渲染位图序列
		private var bitmap:Bitmap;
		
//		private var _containSp:Sprite;
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
		
//		private var maxHeight:Number;
//		private var maxWidth:Number;
//		public override function get height():Number{
//			return maxHeight;
//		}
//		public override function get width():Number{
//			return maxWidth;
//		}
		
		public function set fps(value:int):void
		{
			dealy = 1000 / value;
//			currentTime = getTimer();
		}
		/**
		 * 设置图片横向拉伸度
		 * @param value
		 */		
		public function set bmpScaleX(value:Number):void{
			bitmap.scaleX = value;
		}
		/**
		 * 设置图片纵向拉伸度
		 * @param value
		 */	
		public function set bmpScaleY(value:Number):void{
			bitmap.scaleY = value;
		}
		
		/**
		 * 从头到尾播放一次后自动回收
		 */		
		public function playOnce():void{
			playLoop(1,totalFrames,1,dispose);
		}
		
		public function isClick(/*px:Number,py:Number*/):Boolean{
//			trace(mouseX + " : " + mouseY);
			/*if(!hitTestPoint(p.x,p.y)){
				trace("边界不检测");
				return false;
			}*/
			var p:Point = bitmap.globalToLocal(
				new Point(Vision.visionStage.mouseX,Vision.visionStage.mouseY));
			var px:Number = p.x;
			var py:Number = p.y;
//			trace(px,py);
			var bd:BitmapData = bitmap.bitmapData;
			if(!bd)return false;
			var toX:int = px;
//			if(this.scaleX == -1)toX = -px;
			var toY:int = py;
			
//			trace(toX,toY);
//			trace(bd.getPixel(10,20));
//			bd.fillRect(new Rectangle(toX,toY,10,10),0xFFFFFFFF);
//			trace(bd.getPixel32(toX,toY))
			return bd.getPixel32(toX,toY) > 0;
		}
		
		public function playLoop(start:*,end:*,loop:int = -1,
								 endFunc:Function = null,...args):void{
			var s:int = getFrame(start);
			var e:int = getFrame(end);
			if(s == startFrame && e == endFrame)return;
			_currentFrame = startFrame = s;
			endFrame = e;
			loopTime = loop;
			loopEndFunc = endFunc;
			loopEndArgs = args;
			
			addEventListener(Event.ENTER_FRAME,clipLoop);
			drawClip();
			currentTime = getTimer();
		}
		
		public function SpriteClip(classType:Class = null,fps:int = 48)
		{
			super();
			bitmap = new Bitmap();
			/*_containSp = new Sprite();
			_containSp.addChild(bitmap);
			addChild(_containSp);*/
			this.addChild(bitmap);
			this.fps = fps;
			if(classType){
				cutMap(classType);
			}
		}
		
		public function get contain():Bitmap
		{
			return bitmap;
		}

		public static function convert(movieClip:MovieClip,fps:int = 48):SpriteClip{
			var className:String = getQualifiedClassName(movieClip);
			var bitmapClip:SpriteClip = new SpriteClip();
			bitmapClip.ensureInstance(movieClip,className,movieClip.scaleX,movieClip.scaleY,movieClip.width,movieClip.height);
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
		
		public function cutMap(classType:Class,sx:Number = 1,sy:Number = 1,
							   width:Number = 0,height:Number = 0,
							   offsetX:Number= NaN, offsetY:Number= NaN):void
		{
//			this.fps = fps;
			if(classType == null){
				bitmap.bitmapData = null;
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
			if(bitmapList != null){
//				trace("重用SpriteClip序列:" + classType);
				drawClip();
				return; //如果已经切过了就用原来的
			}
			
//			mcPool[className] = _source = new classType(); //创建影片实例
			ensureInstance(new classType(),className,sx,sy,
				width,height,offsetX,offsetY);
			
			/*var totalFrames:int = _source.totalFrames;
			clipPool[className] = bitmapList = new Vector.<ClipVo>(totalFrames);
			
			for(var i:int = totalFrames; i >= 1; --i){
				_source.gotoAndStop(i); //先跳到当前帧 然后计算此帧影片的宽高 再绘制
				bitmapList[i - 1].frameLabel = _source.currentFrameLabel;
			}
			drawClip();*/
			
//			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		private function getData(index:int):ClipVo{
			var cVo:ClipVo = bitmapList[index];
			if(cVo){
				return cVo;
			}
			var mc:MovieClip = _source;
			mc.gotoAndStop(index + 1); //先跳到当前帧 然后计算此帧影片的宽高 再绘制
			var mcWidth:Number = mc.width;
			cVo = new ClipVo();
//			cVo.frameLabel = mc.currentFrameLabel;
			bitmapList[index] = cVo;
			if(mcWidth == 0){
				return cVo;
			}
			var mcHeight:Number = mc.height;
			var offSetX:int = mc.getRect(mc).x;//getOffSetX(mc);
			var offSetY:int = mc.getRect(mc).y;//getOffSetY(mc);
			cVo.x = offSetX;
			cVo.y = offSetY;
			var matrix:Matrix = new Matrix(1,0,0,1,-offSetX,-offSetY);
			var bitmapData:BitmapData = new BitmapData(mcWidth,mcHeight,true,0x00000000);
			bitmapData.lock();
			bitmapData.draw(mc,matrix);
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
			mcPool[className] = _source = mc; //创建影片实例
			clipPool[className] = bitmapList = new Vector.<ClipVo>(_source.totalFrames);
			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);*/
			
			clipPool[className] = bitmapList = new Vector.<ClipVo>;
			//创建数组并用池保存数组 数组用来保存图片序列
			
			//遍历影片的所有帧，然后通过bitmapData去绘制
			var totalFrames:int = mc.totalFrames;
			if(sx != 1 && sy != 1){
				mc.scaleX = sx;
				mc.scaleY = sy;
			}
			addChild(mc);
			for(var i:int = 1; i <= totalFrames; ++i){
				mc.gotoAndStop(i); //先跳到当前帧 然后计算此帧影片的宽高 再绘制
				if(w == 0 || h == 0){
					var mcWidth:Number = mc.width;
					var mcHeight:Number = mc.height;
				}else{
					mcWidth = w;
					mcHeight = h;
				}
				var cVo:ClipVo = new ClipVo();
				cVo.frameLabel = mc.currentFrameLabel;
				if(mcWidth == 0 && mcHeight == 0){
					bitmapList.push(cVo);
					continue;
				}
				if(w == 0 || h == 0){
					var offSetX:int = mc.getBounds(null).x * sx;//getOffSetX(mc);
					var offSetY:int = mc.getBounds(null).y * sy;//getOffSetY(mc);
				}else{
					offSetX = ox;
					offSetY = oy;
				}
				cVo.x = offSetX;
				cVo.y = offSetY;
				var matrix:Matrix = new Matrix(1,0,0,1,-offSetX,-offSetY);
				var bitmapData:BitmapData = new BitmapData(mcWidth,mcHeight,true,0x00000000);
				bitmapData.draw(this,matrix);
				cVo.bitmapData = bitmapData;
				bitmapList.push(cVo);
			}
			removeChild(mc);
			drawClip();
		}
		
		public function get totalFrames():int{
			return bitmapList ? bitmapList.length : 0;
		}
		
		/*private function getOffSetX(display:DisplayObject):Number{
			//			var disParent:DisplayObjectContainer = display.parent;
			var normalWidth:Number = display.width;
			var sp:Sprite = new Sprite();
			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill(0);
			shape.graphics.drawRect(0,0,normalWidth,1);
			shape.graphics.endFill();
			
			sp.addChild(shape);
			sp.addChild(display);
			
			var preWidth:Number = sp.width;
			var interX:Number = preWidth - normalWidth;
			if(interX == 0){
				//				disParent.addChild(display);
				return 0;
			}
			shape.x = -normalWidth;
			var nowWidth:Number = sp.width;
			//			disParent.addChild(display);
			if(interX <= normalWidth){
				if(nowWidth >= 2 * normalWidth){
					return interX;
				}else{
					return -interX;
				}
			}else{
				if(preWidth > nowWidth){
					return -interX;
				}else{
					return interX;
				}
			}
			return 0;
		}
		
		private function getOffSetY(display:DisplayObject):Number{
			//			var disParent:DisplayObjectContainer = display.parent;
			var normalHeight:Number = display.height;
			var sp:Sprite = new Sprite();
			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill(0);
			shape.graphics.drawRect(0,0,1,normalHeight);
			shape.graphics.endFill();
			
			sp.addChild(shape);
			sp.addChild(display);
			
			var preHeight:Number = sp.height;
			var interY:Number = preHeight - normalHeight;
			if(interY == 0){
				//				disParent.addChild(display);
				return 0;
			}
			shape.y = -normalHeight;
			var nowHeight:Number = sp.height;
			//			disParent.addChild(display);
			if(interY <= normalHeight){
				if(nowHeight >= 2 * normalHeight){
					return interY;
				}else{
					return -interY;
				}
			}else{
				if(preHeight > nowHeight){
					return -interY;
				}else{
					return interY;
				}
			}
			return 0;
		}*/
		
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
			//			addEventListener(Event.ENTER_FRAME,clipLoop);
			addEventListener(Event.ENTER_FRAME,clipLoop);
			drawClip();
			startFrame = -1; //循环播放起始帧
			endFrame = -1; //循环播放结束帧
			currentTime = getTimer();
		}
		
		public function stop():void
		{
			startFrame = -1; //循环播放起始帧
			endFrame = -1; //循环播放结束帧
			removeEventListener(Event.ENTER_FRAME,clipLoop);
			drawClip();
			//			removeEventListener(Event.ENTER_FRAME,clipLoop);
		}
		
		public function get isPlaying():Boolean{
			return hasEventListener(Event.ENTER_FRAME);
		}
		
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
		
		private function drawClip():void
		{
			var clipVo:ClipVo = getData(_currentFrame);
			if(clipVo && clipVo.bitmapData){
				bitmap.x = clipVo.x * bitmap.scaleX;
				bitmap.y = clipVo.y * bitmap.scaleY;
				bitmap.bitmapData = clipVo.bitmapData;
				bitmap.smoothing = true;
//				if(super.width > maxWidth)maxWidth = super.width;
//				if(super.height > maxHeight)maxHeight = super.height;
			}else{
				bitmap.bitmapData = null;
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
		
		private function clipLoop(e:Event):void
		{
			var preTime:Number = getTimer();
			if(preTime - currentTime < dealy)return;
			currentTime = preTime;
			_currentFrame ++;
			if(endFrame >= 0){
				if(_currentFrame >= endFrame){
					if(loopTime != -1 && --loopTime == 0){
						if(loopEndFunc != null){
							loopEndArgs ? loopEndFunc.apply(null,
								loopEndArgs) : loopEndFunc();
							loopEndFunc = null;
						}
						stop();
						return;
					}
					_currentFrame = startFrame;
				}
				drawClip();
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
		
		public function dispose(event:Event = null):void
		{
			this.stop();
			if(this.parent) this.parent.removeChild(this);
//			this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
			startFrame = -1; //循环播放起始帧
			endFrame = -1; //循环播放结束帧
//			bitmap.bitmapData = null;
		}
	}
}
import flash.display.BitmapData;

/**
 * 位图引擎专用vo 存储位图数据和偏移
 * @author Administrator
 */
class ClipVo{
	public var x:int = 0;
	public var y:int = 0;
	public var bitmapData:BitmapData;
	public var frameLabel:String;
}