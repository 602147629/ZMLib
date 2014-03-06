package com.utils
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * 对象池 静态工具类 创建任意类型的对象(实例)
	 * 创建的时候从池内进行检查该类型实例是否有创建
	 * 如果有 当做新的实例来用
	 *  
	 * 当对象消失后进行回收处理
	 * @author GY
	 */	
	public class GameObjectPool
	{
		//池 key:className value:Vector.<Object>;
		private static var poolDic:Dictionary = new Dictionary(true);
		/**
		 * 创建一个实例 该实例要从池中进行检查
		 * @param cla
		 * @return 
		 */		
		public static function createObjcet(cla:Class,...args):Object{
			var className:String = getQualifiedClassName(cla);
			//先获取该完全限定类名
			if(poolDic[className] == null){
				//如果该类型的数组没有创建的情况下 创建该类型的池数组
				poolDic[className] = new Vector.<Object>;
			}
			return getInstance(poolDic[className],cla,args);
		}
		/**
		 * 通过查找该类型被回收实例的数组 
		 * 如果数组内有该回收实例的情况下 返回该实例
		 * 没有就创建一个新的
		 * @param list
		 * @return 
		 */		
		private static function getInstance(list:Vector.<Object>,
											cla:Class,args:Array = null):Object
		{
			if(list.length != 0){
				return list.pop(); //返回旧的回收实例
			}
//			return (cla as Function).apply(null,args);
			return new cla(); //如果没有回收的实例 只能创建新的实例
		}
		/**
		 * 将该实例回收利用
		 * @param obj
		 */		
		public static function recycle(obj:Object):void{
			var className:String = getQualifiedClassName(obj);
			//先获取该完全限定类名
			var list:Vector.<Object> = poolDic[className];
			if(list == null)return; //不是对象池创建的对象 无法回收
			
			//获取该类型需要回收的实例数组
			list.push(obj);
		}
	}
}