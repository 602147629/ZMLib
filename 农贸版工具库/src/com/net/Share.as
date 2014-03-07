package com.net
{
	import flash.net.SharedObject;

	/**
	 * 封装SharedObject实例 提供所有关于操作数据的静态方法(存入，读取，查找字段，删除)
	 * @author gao sir
	 */	
	public class Share
	{
//		public static const BIG_SKY:String = 'bigSky';
		//通过获取硬盘位置创建SharedObject实例
		private static var so:SharedObject;// = SharedObject.getLocal(BIG_SKY);
		
		private static var _fileName:String;//共享文档的文件名
		public static function get fileName():String
		{
			return _fileName;
		}
		public static function set fileName(value:String):void
		{
			_fileName = value;
			so = SharedObject.getLocal(_fileName);
		}
		/**
		 * 将目标字段存储的数据value立即写入到硬盘中
		 * so.data.字段名 = 值
		 * @param key
		 * @param value
		 */			
		public static function wirte(key:String,value:*):void{
			so.data[key] = value;
			so.flush();
		}
		/**
		 * 通过目标字段获取data中的数据
		 * @param key
		 * @return 
		 */		
		public static function read(key:String):*{
			return so.data[key];
		}
		/**
		 * 通过目标字段移除此字段对应的数据 delete
		 * @param key
		 */		
		public static function remove(key:String):void{
			delete so.data[key];
		}
		/**
		 * 判断对应的字段数据是否存储过 没有存储值为undefined
		 * @param key
		 * @return 
		 */		
		public static function hasKey(key:String):Boolean{
			return so.data[key] != undefined;
		}
		public static function clear():void{
			so.clear();
		}
		
		
	}
}