package com.vo
{
	/**
	 * 管理人员树形结构 以后需要改动!!! 先这样吧
	 */	
	public class TreeTrunkVo
	{
		public var label:String;
		public var personList:Vector.<PersonVo>;
		public var itemFiled:Vector.<TreeTrunkVo>;
	}
}