package com.manager
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * 层次管理器 将整个应用程序 划分成3个层次 Tips,UI,Map层
	 * 可以在三个层次中添加和移除子实例功能
	 */	
	public class Vision
	{
		public static var visionStage:Stage;//存储舞台实例 可全局访问
		
		public static const TIPS:String = 'tips';//
		public static const UI:String = 'ui';//
		public static const MAP:String = 'map';//
		/**
		 * 用Dictionary将三个层次的容器存放起来 
		 * 三个层次定义三个固定关键字(key) 通过三个关键字来获取层次容器
		 * 那么子实例添加和删除的功能可以通过关键字来寻找父容器完成
		 */
		private static var layerDic:Dictionary = new Dictionary(true);
		//存放三个层次的存储器
		
		/**
		 * 创建三个层次的实例 添加到父容器中
		 * @param root 父容器(一般是舞台或根容器)
		 */		
		public static function createChildren(
			root:DisplayObjectContainer):void{
			
			Vision.visionStage = root.stage;//存入舞台实例
			
			//创建三个Sprite表示三个层次的容器 添加到root中
			var sp1:Sprite = new Sprite();
			root.addChild(sp1);
			layerDic[MAP] = sp1;
			
			var sp2:Sprite = new Sprite();
			root.addChild(sp2);
			layerDic[UI] = sp2;
			
			var sp3:Sprite = new Sprite();
			root.addChild(sp3);
			layerDic[TIPS] = sp3;
			sp3.mouseEnabled = false;//不能交互
			
		}
		/**
		 * 将dpo添加到目标层次容器中
		 * @param layer 目标层级关键字key
		 * @param dpo 需要添加到层次容器的子实例
		 */		
		public static function addView(layer:String,
									   dpo:DisplayObject):void{
			var sp:Sprite = layerDic[layer];
			if(sp != null){//找到目标容器后添加子实例
				sp.addChild(dpo);
			}
		}
		/**
		 * 将dpo从目标层次容器中移除 增加判断子实例是否在父容器中
		 * @param layer 目标层级关键字key
		 * @param dpo 需要添加到层次容器的子实例
		 */		
		public static function removeView(layer:String,
										  dpo:DisplayObject):void{
			var sp:Sprite = layerDic[layer];
			if(dpo != null && sp != null && dpo.parent == sp){
				//父容器存在且子实例在父容器显示列表中才能移除
				sp.removeChild(dpo);//移除子实例
			}
		}
		/**
		 * 返回舞台画布宽度
		 * @return
		 */		
		public static function get senceWidth():Number{
			return visionStage.stageWidth;
		}
		/**
		 * 返回舞台画布高度
		 * @return
		 */		
		public static function get senceHeight():Number{
			return visionStage.stageHeight;
		}
		
		private static var bmdDic:Dictionary = new Dictionary(true);
		public static function getBmdByOnePixel(color:uint):BitmapData{
			if(bmdDic[color] == null){
				bmdDic[color] = new BitmapData(1,1,false,color);
			}
			return bmdDic[color];
		}
		
		
	}
}