package com.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileUtils
	{
		private static var fileStream:FileStream;
		/**
		 * 将二进制数据保存到本地
		 * @param byte
		 */		
		public static function saveFile(byte:ByteArray,file:File,filePath:String):void{
			if(fileStream == null)fileStream = new FileStream();
			var f:File = new File(file.resolvePath(filePath).nativePath);// E:\\air\\" + filePath;
			fileStream.open(f,FileMode.WRITE);
			fileStream.writeBytes(byte);//将数据写入到本地中
			fileStream.close();
		}
		
		public static function loadFile(file:File,filePath:String):ByteArray{
			var f:File = file.resolvePath(filePath);
			if(f.exists){
				if(fileStream == null)fileStream = new FileStream();
				fileStream.open(f,FileMode.READ);
				var by:ByteArray = new ByteArray();
				//定义二进制数组
				fileStream.readBytes(by);
				fileStream.close();
			}
			return by;
		}
		
		
	}
}