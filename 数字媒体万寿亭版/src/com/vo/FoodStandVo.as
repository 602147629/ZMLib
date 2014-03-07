package com.vo
{
	public class FoodStandVo
	{
		public var personName:String;//检测人
		public var time:Date = new Date();//时间戳
		public var result:String;//显示结果
		public var goodCount:int;
		public var unGoodCount:int;
		public var totalCount:int;
		public var content:String;//详细html内容
		public var contentXml:XML;//详细内容解析xml
		public var checKList:Vector.<CheckVo>;
		public var xlsPath:String;//xlsx地址
	}
}