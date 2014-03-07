package com.vo
{
	public class AdmanageVo
	{
		public static const MODE_IMAGE:String = "image";
		public static const MODE_VIDEO:String = "video";
		
		public var id:int;//远程id
		public var mode:String;//图片"image"还是视频"video"
		public var sourceUrl:String;
		public var title:String;
		public var content:String = "广告描述详细信息";//
	}
}