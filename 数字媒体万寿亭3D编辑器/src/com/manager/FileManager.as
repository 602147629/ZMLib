package com.manager
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	import com.utils.PowerLoader;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	public class FileManager
	{
		public static var modelFilter:FileFilter = new FileFilter("模型文件3ds,awd,obj","*.3ds;*.awd;*.obj;");
		public static var xmlFilter:FileFilter = new FileFilter("xml配置文件","*.xml");
		
		private static var openFile:File = File.desktopDirectory;
		private static var filePath:String = openFile.nativePath;
		private static var loadCallBack:Function;
		public static function browse(fileOver:Function = null,filter:FileFilter = null):void{
			// FileFilter 参数说明       文件类型 , 文件扩展名
			if(filter != null){
				var fileList:Array = [filter];
			}
			openFile.browseForOpen("Open",fileList);
			openFile.addEventListener(Event.SELECT,fileSelected);
			loadCallBack = fileOver;
		}
		
		private static var xmlPath:String;
		private static function fileSelected(e:Event):void
		{
			if(!(openFile.nativePath.indexOf(filePath) >= 0)){
				//表示不存在
				trace("请从桌面打开");
				return;
			}
			var endPath:String = openFile.nativePath.slice(filePath.length + 1);
			trace(filePath);
			var endIndex:int = endPath.lastIndexOf(openFile.name);
			xmlPath = endPath.slice(0,endIndex);
			var xmlNmaeIndex:int = openFile.name.lastIndexOf(openFile.extension);
			xmlPath += openFile.name.slice(0,xmlNmaeIndex) + "xml";
//			trace("配置文件:" + xmlPath);
			
			openFile.load();
			openFile.addEventListener(Event.COMPLETE,onComplete);
//			trace(openFile.name,openFile.extension,openFile.nativePath);  // 输出文件系统完成路径
		}
		
		private static function onComplete(e:Event):void
		{
			var by:ByteArray = openFile.data;
			trace("文件加载完毕");
			if(openFile.type == '.3ds' || openFile.type == '.awd' || openFile.type == '.obj'){
				PowerLoader.convertByteModel(by,modelLoaded);
			}else if(openFile.type == '.xml'){
				if(loadCallBack != null)loadCallBack(by,openFile.name);
			}
		}
		
		private static function modelLoaded(mesh:ObjectContainer3D):void
		{
			if(loadCallBack != null)loadCallBack(mesh,getXml());
		}
		
		public static function getXml():XML{
			
			var file:File = File.desktopDirectory.resolvePath(xmlPath);
			if(file.exists){
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var str:String = fileStream.readUTFBytes(file.size);
				var sourceXml:XML = XML(str);
				fileStream.close();
			}
			return sourceXml;
		}
		
		public static function saveXml(xml:XML):void
		{
			if(xmlPath == null)return;//没打开任何模型
			var file:File = File.desktopDirectory.resolvePath(xmlPath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(xml.toXMLString());
			fs.close();
		}
	}
}