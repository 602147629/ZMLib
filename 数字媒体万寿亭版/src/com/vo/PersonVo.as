package com.vo
{
	public class PersonVo
	{
		public function PersonVo(icon:String = null,name:String = null,occup:String = null,number:String = null,agree:Number = 0){
			this.icon = icon;
			this.name = name;
			this.occup = occup;
			this.number = number;
			this.agree = agree;
		}
		public var id:int;//服务器id
		public var icon:String;//头像图片地址
		public var name:String;
		public var occup:String;
		public var number:String;//管理员编号
		public var agree:Number = 0;//agree%
		public var large:String;//大图地址
	}
}