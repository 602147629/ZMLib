package com.utils
{
	import away3d.entities.Mesh;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipFile;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * zip文件解析器，还原压缩的模型文件
	 * 2013/9/26
	 */	
	public class ZipResolve
	{
		private static var _meshList:Mesh;
		private static var _loadFuncDic:Dictionary;
		private static var _load3DFuncDic:Dictionary;
		private static var _namespace:String;//名字关键字
		/**
		 * 传入已经加载完成的zip数据
		 * @param zipByteArray zip数据
		 * @param loadFunc 回调函数
		 * @param args 可多选参数
		 */		
		public static function loadByteArray(zipByteArray:Object,loadFunc:Function,
											 ns:String = null):void
		{
			if(_loadFuncDic == null)
			{
				_loadFuncDic = new Dictionary();
			}
			_namespace = ns;
			
			var zip:FZip = new FZip();
			_loadFuncDic[zip] = loadFunc;
			zip.addEventListener(Event.COMPLETE,onLoadZipComplete);
			zip.addEventListener(FZipErrorEvent.PARSE_ERROR,onZipParseError);
			zip.loadBytes(zipByteArray as ByteArray);
//			zip.addEventListener(ProgressEvent.PROGRESS,onProgress);
		}
		
//		private static function onProgress(e:ProgressEvent):void
//		{
//			trace('解压百分比:' + (e.bytesLoaded / e.bytesTotal * 100).toFixed(2));
//		}
		
		protected static function onZipParseError(e:FZipErrorEvent):void
		{
			trace("文件类型解析失败" + e);
		}
		
		protected static function onLoadZipComplete(e:Event):void
		{
//			trace("文件解压完成");
			var zipTarget:FZip = e.currentTarget as FZip;
			var fc:int = zipTarget.getFileCount();
			
			for(var i:int = 0;i < fc;i++)
			{
				var zipfile:FZipFile = zipTarget.getFileAt(i);
				var modelData:Object = zipfile.content;
				var meshName:String = (zipfile.filename.split("_"))[1];
				Parsers.enableAllBundled();
				var loader3D:Loader3D = new Loader3D();
				loader3D.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceComplete);
				loader3D.name = meshName;
				loader3D.loadData(modelData,null,_namespace);
				if(_load3DFuncDic == null)
				{
					_load3DFuncDic = new Dictionary();
				}
				_load3DFuncDic[loader3D] = _loadFuncDic[zipTarget];
			}
			delete _loadFuncDic[zipTarget];
			zipTarget.close();
		}		
		
		private static function resourceComplete(e:LoaderEvent):void
		{
			var loader3DTarget:Loader3D = e.currentTarget as Loader3D;
			var meshName:String = loader3DTarget.name;
			var numChildrenCount:int = loader3DTarget.numChildren;
			if(numChildrenCount > 0)
			{
				for(var i:int = numChildrenCount - 1; i >= 0;i--)
				{
					var asset:Object = loader3DTarget.getChildAt(i);
					if(asset is Mesh)
					{
						if(_meshList == null)
						{
							_meshList = new Mesh(null);
						}
						_meshList.addChild(asset as Mesh);
					}
				}
			}
			if (_meshList != null)
			{
				var loadFuncComplete:Function = _load3DFuncDic[loader3DTarget];
				_meshList.name = meshName;
				dispose(_meshList,loadFuncComplete);
			}
			loader3DTarget.dispose();
			_meshList = null;
			delete _load3DFuncDic[loader3DTarget];
		}
		
		private static function dispose(data:Object,loadFuncComplete:Function):void
		{
			if(loadFuncComplete != null)
			{
				loadFuncComplete(data);
			}
		}
		
		public function ZipResolve()
		{
		}
		
	}
}