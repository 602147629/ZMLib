package com.utils
{
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
//	import mx.utils.StringUtil;
	
	public class FarmLoader
	{
		public static var cutAddress:String = '';//剪切的文本
		/**
		 * @param url
		 * @param isTexture 是否转换成材质
		 * @param loadFunc
		 * @param args
		 */		
		public static function loadImageFile(url:String,loadFunc:Function = null,...args):void{
			if(url == null || /*StringUtil.trim(*/url == ""){
				trace("加载地址为null");
				return;
			}
			initFile(url,loadFunc,args);
		}
//		/**
//		 * 以二进制数据方式加载目标
//		 * @param url
//		 * @param loadFunc
//		 * @param args
//		 */		
//		public static function loadByte(url:String,loadFunc:Function = null,...args):void{
//			var data:Object = getFile(url);
//			if(data != null){
//				loadComplete(data,loadFunc,args);
//			}else{
//				loadData(url,loadFunc,args,true);
//			}
//		}
		
		private static function initFile(url:String,loadFunc:Function,args:Array):void
		{
			var data:Object = getFile(url);
			if(data != null){
				loadComplete(data,loadFunc,args);
			}else{
				checkFile(url,loadFunc,args);
			}
		}
		
		private static var urlDic:Dictionary = new Dictionary(true);//key:url,value:loader
		private static var loadDic:Dictionary = new Dictionary(true);//key:loader,value:Vector.<LoadVo>
		private static function checkFile(url:String,  loadFunc:Function, args:Array):void
		{
//			if(urlDic == null)urlDic = new Dictionary(true);
//			if(loadDic == null)loadDic = new Dictionary(true);
			var tempUrl:String = url.toLocaleLowerCase();
			if(tempUrl.lastIndexOf('.png') > 0 || tempUrl.lastIndexOf('.jpg') > 0 || 
				tempUrl.lastIndexOf('.swf') > 0 || tempUrl.lastIndexOf('.gif') > 0){//加载材质数据
				CacheUtils.loadByteAndSave(url,cutAddress,loadImageByte,url,loadFunc,args);
//				loadImage(url,loadFunc,args);
 			}
			loadProgress();
		}
		
		private static function loadImageByte(byte:ByteArray,url:String,
											  loadFunc:Function,args:Array):void
		{
			if(urlDic[url] !== undefined){
				loader = urlDic[url];
			}else{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onAssetsComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
				//				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onAssetsProgress);
				if(url.lastIndexOf('.swf') > 0){
					var lc:LoaderContext = new LoaderContext();
					lc.allowCodeImport = true;
				}
				loader.loadBytes(byte,lc);
			}
			pushLoader(loader,url,loadFunc,args,byte);
		}
		/**
		 * 注册帧循环 每帧监听加载进度
		 */		
		private static function loadProgress():void
		{
//			if(loadDispatcher.hasEventListener(ProgressEvent.PROGRESS))
//			Vision.addLoop(onLoop);
		}
		/**
		 * 抛出全部加载完成事件
		 */		
		private static function endProgress():void{
//			Vision.removeLoop(onLoop);
//			setTimeout(endDispatch,3000);
			endDispatch();
		}
		
		private static function endDispatch():void
		{
			for each (var loader:Object in urlDic) 
			{
				return;//再次确认是否还有剩余 如果下一个已经开始了就停止抛出
			}
			if(loadDispatcher.hasEventListener(Event.COMPLETE))
				loadDispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * 注册加载进度事件:ProgressEvent.PROGRESS
		 * @param func
		 */		
		public static function addProgressEvent(func:Function):void{
			loadDispatcher.addEventListener(ProgressEvent.PROGRESS,func);
		}
		public static function removeProgressEvent(func:Function):void{
			loadDispatcher.removeEventListener(ProgressEvent.PROGRESS,func);
		}
		/**
		 * 注册全部加载完成事件:Event.COMPLETE
		 * @param func
		 */		
		public static function addCompleteEvent(func:Function):void{
			loadDispatcher.addEventListener(Event.COMPLETE,func);
		}
		public static function removeCompleteEvent(func:Function):void{
			loadDispatcher.removeEventListener(Event.COMPLETE,func);
		}
		
		private static var loadDispatcher:EventDispatcher = new EventDispatcher();
		private static function onLoop(e:Event):void
		{
			var bytesLoaded:Number = 0;
			var bytesTotal:Number = 0;
			var loaderCount:int;
			for each (var loader:Object in urlDic) 
			{
				if(loader is Loader){
					bytesLoaded += (loader as Loader).contentLoaderInfo.bytesLoaded;
					bytesTotal += (loader as Loader).contentLoaderInfo.bytesTotal;
				}else{
					bytesLoaded += (loader as URLLoader).bytesLoaded;
					bytesTotal += (loader as URLLoader).bytesTotal;
				}
				loaderCount ++;
			}
			if(loaderCount == 0){//全部加载完毕
				endProgress();
			}else{
				var pe:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				pe.bytesLoaded = bytesLoaded;
				pe.bytesTotal = bytesTotal;
				loadDispatcher.dispatchEvent(pe);
			}
		}
		
		/**
		 * 先检查是否已经开始加载了 如果已经开始加载 就无需再加载 直接传入回调函数即可 等一起加载结束后回调
		 * @param url
		 * @param loadFunc
		 * @param args
		 */		
		private static function loadImage(url:String, loadFunc:Function, args:Array):void
		{
			if(urlDic[url] !== undefined){
				loader = urlDic[url];
			}else{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onAssetsComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
//				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onAssetsProgress);
				loader.load(new URLRequest(url));
			}
			pushLoader(loader,url,loadFunc,args);
		}
		
		private static function onError(e:IOErrorEvent):void
		{
			var loader:Object;
			if(e.target is LoaderInfo){
				loader = (e.target as LoaderInfo).loader;
				(loader as Loader).unloadAndStop();
			}else{
				loader = e.target as URLLoader;
			}
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:String = loadVector[0].url;
			trace('加载地址有误:' + url + '\n错误信息:' + e);
			exit(loader);
		}
		//图片加载结束
		private static function onAssetsComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,onAssetsComplete);
			var loader:Object;
			var asset:Object;
			if(e.target is LoaderInfo){
				loader = (e.target as LoaderInfo).loader;
				asset = (loader as Loader).content;
//				if(asset is Bitmap){
//					//转换成Texture
////					if(bd)
//				}
				var loadVector:Vector.<LoadVo> = loadDic[loader];
				var loadVo:LoadVo = loadVector[0];
				if(loadVo.url.lastIndexOf('.swf') > 0){
					asset = loader;
				}else{
					(loader as Loader).unloadAndStop();
				}
				dispose(loader,asset);
			}
		}
		/**
		 * 目标地址有误 直接跳出
		 * @param loader
		 */		
		private static function exit(loader:Object):void{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:String = loadVector[0].url;
			delete loadDic[loader];
			delete urlDic[url];
			loader = null;
			loadVector.length = 0;
			loadVector = null;
		}
		
		private static function dispose(loader:Object,asset:Object):void{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var loadVo:LoadVo = loadVector[0];
			var url:String = loadVo.url;
			ResourceBox.setResource(url,asset);
			var by:ByteArray = loadVo.byte;
			by.clear();//释放内存
			loadVo.byte = null;
			
			delete loadDic[loader];
			delete urlDic[url];
			
			for each (var lvo:LoadVo in loadVector) 
			{
				loadComplete(asset,lvo.loadFunc,lvo.args);
			}
			loader = null;
			loadVector.length = 0;
			loadVector = null;
		}
		
		/**
		 * 存入和本loader(2D or 3D)相关联的回调函数和参数
		 * @param loader
		 */		
		private static function pushLoader(loader:Object,url:String,  
										   loadFunc:Function, args:Array,byte:ByteArray = null):void
		{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			if(loadVector == null){
				loadVector = loadDic[loader] = new Vector.<LoadVo>();
			}
			loadVector.push(new LoadVo(url,loadFunc,args,byte));
			urlDic[url] = loader;
		}
		
		private static function loadComplete(data:Object,loadFunc:Function, args:Array):void
		{
			if(args != null){ //如果传入第三个参数
				args.unshift(data);
				loadFunc.apply(null,args);//如果第三个参数传入 也将自己作为参数传出
			}else{
				loadFunc(data);
			}
		}
		
		private static function getFile(url:String):Object
		{
			if(ResourceBox.cotainKey(url))return ResourceBox.getResource(url);
			return null;
		}
	}
}
import flash.utils.ByteArray;
import flash.utils.Dictionary;

class ResourceBox
{
	/**
	 * 通过Dictionary保存图片序列bitmapData标签为图片url
	 * 主要实现 存最新图片序列 检查已有的图片序列 取目标图片序列
	 */		
	private static var resource:Dictionary = new Dictionary(true);
	
	/**
	 * 存入目标资源
	 * @param url 目标资源地址
	 * @param data 目标资源（图片序列BitmapData 或 影片MovieClip）
	 */		
	public static function setResource(url:String , data:* ):void{
		resource[url] = data;
	}
	
	/**
	 * 检查目标资源地址对应的目标资源是否已经在素材管理器里面存在
	 * data的值即不是null也不是undefined表示存在才为true
	 * @param url 目标资源地址
	 * @return 是否有
	 */		
	public static function cotainKey(url:String):Boolean{
		if(resource[url] !== undefined && resource[url] != null){
			return true; //发现该种子对应的数据确实有的
		}
		return false;
	}
	
	/**
	 * 取得目标资源地址对应的目标资源
	 * @param url 目标资源地址
	 * @return 目标资源
	 */		
	public static function getResource(url:String):*{
		return resource[url];
	}
}
class LoadVo
{
	public function LoadVo(url:String,loadFunc:Function, args:Array,byte:ByteArray = null):void{
		this.url = url;
		this.loadFunc = loadFunc;
		this.args = args;
		this.byte = byte;
	}
	public var url:String;
	public var loadFunc:Function;
	public var args:Array;
	public var byte:ByteArray;
}