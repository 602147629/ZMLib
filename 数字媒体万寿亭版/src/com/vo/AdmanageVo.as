package com.vo
{
	public class AdmanageVo
	{
		public static const MODE_IMAGE:String = "image";
		public static const MODE_VIDEO:String = "video";
		public static const MODE_TEXT:String = "text";//文本信息
		
		public var id:int;//远程id
		public var mode:String;//图片"image"还是视频"video"
		public var sourceUrl:String;
		public var title:String;
		public var content:String = "广告描述详细信息";//
		public var stick:Boolean;//置顶
		public var delay:int;//延迟时间(秒)
		public var startTime:Number;//开始时间戳
		public var endTime:Number;//结束时间戳
	}
}