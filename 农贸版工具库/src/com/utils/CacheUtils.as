package com.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	public class CacheUtils
	{
		public static var fileSavePath:File = File.documentsDirectory;
		
		/**
		 * 只会以二进制方式加载获取二进制数据 并保存到本地我的文档目录中缓存
		 * @param url
		 */		
		public static function loadByteAndSave(url:String,cutAddress:String,onComplete:Function = null,...args):void{
			if(url == null || /*StringUtil.trim*/(url) == ""){
				trace("加载地址为null");
				return;
			}
			initFile(url,cutAddress,onComplete,args);
		}
		
		private static function initFile(url:String,cutAddress:String,loadFunc:Function,args:Array):void
		{
			var data:ByteArray = getFile(url,cutAddress);
			if(data != null){
				loadComplete(data,loadFunc,args);
			}else{
				loadByte(url,cutAddress,loadFunc,args);
			}
		}
		
		private static var urlDic:Dictionary = new Dictionary(true);//key:url,value:loader
		private static var loadDic:Dictionary = new Dictionary(true);//key:loader,value:Vector.<LoadVo>
		private static function loadByte(url:String,cutAddress:String, loadFunc:Function, args:Array):void
		{
			if(urlDic[url] !== undefined){
				loader = urlDic[url];
			}else{
				var loader:URLLoader = new URLLoader(new URLRequest(url));
				loader.dataFormat = URLLoaderDataFormat.BINARY;//二进制形式加载
				loader.addEventListener(Event.COMPLETE,onByteComplete);
//				loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
			}
			pushLoader(loader,url,cutAddress,loadFunc,args);
		}
		
		private static function onProgress(e:ProgressEvent):void
		{
			var loader:URLLoader = e.target as URLLoader;
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:String = loadVector[0].url;
			trace(url + "百分比:" + int((e.bytesLoaded / e.bytesTotal) * 100) + "%");
		}
		/**
		 * @param loader
		 */		
		private static function pushLoader(loader:Object,
										   url:String, cutAddress:String,loadFunc:Function, args:Array):void
		{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			if(loadVector == null){
				loadVector = loadDic[loader] = new Vector.<LoadVo>();
			}
			loadVector.push(new LoadVo(url,cutAddress,loadFunc,args));
			urlDic[url] = loader;
		}
		
		private static function onError(e:IOErrorEvent):void
		{
			var loader:Object = e.target as URLLoader;
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:String = loadVector[0].url;
			trace('加载地址有误:' + url + '\n错误信息:' + e);
			exit(loader);
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
		
		private static function onByteComplete(e:Event):void
		{
			var loader:URLLoader = e.target as URLLoader;
			var data:ByteArray = loader.data;
			dispose(loader,data);
		}
		
		private static function dispose(loader:Object,data:ByteArray):void{
			var loadVector:Vector.<LoadVo> = loadDic[loader];
			var url:String = loadVector[0].url;
			saveFile(url,loadVector[0].cutAddress,data);
			
			delete loadDic[loader];
			delete urlDic[url];
			loader = null;
			for each (var lvo:LoadVo in loadVector) 
			{
				loadComplete(data,lvo.loadFunc,lvo.args);
			}
			loadVector.length = 0;
			loadVector = null;
		}
		
		private static function loadComplete(data:Object,loadFunc:Function, args:Array):void
		{
			if(args != null){ //如果传入第三个参数
				args.unshift(data);
				if(loadFunc != null)loadFunc.apply(null,args);//如果第三个参数传入 也将自己作为参数传出
			}else{
				loadFunc(data);
			}
		}
		
		private static var byteDic:Dictionary = new Dictionary(true);
		//key:url value:ByteArray
		private static function getFile(url:String,cutAddress:String):ByteArray
		{
			if(byteDic[url] !== undefined)return byteDic[url];
			if(url.indexOf(cutAddress) >= 0){//名字中存在ip地址
				var filePath:String = url.slice(cutAddress.length);
				
				var byte:ByteArray = FileUtils.loadFile(fileSavePath,filePath);//从本地进行二次读取
				if(byte != null){
					saveFile(url,cutAddress,byte,false);//无需存入本地
				}
			}
			return byte;
		}
		//保存到本地
		private static function saveFile(url:String,cutAddress:String,byte:ByteArray,isWrite:Boolean = true):void{
			byteDic[url] = byte;
			if(isWrite){
				if(cutAddress != null && cutAddress != "" && url.indexOf(cutAddress) >= 0){//名字中存在ip地址
					var filePath:String = url.slice(cutAddress.length);//确定写入
					FileUtils.saveFile(byte,fileSavePath,filePath);
				}
			}
		}
	}
}
class LoadVo
{
	public function LoadVo(url:String, cutAddress:String, loadFunc:Function, args:Array):void{
		this.url = url;
		this.cutAddress = cutAddress;
		this.loadFunc = loadFunc;
		this.args = args;
	}
	
	public var url:String;
	public var cutAddress:String;
	public var loadFunc:Function;
	public var args:Array;
}