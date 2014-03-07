package com.net
{
	public class NetConfig
	{
		public static const MERCH_ID:int = 4;
		//19:"蔬菜" 20:"肉类" 21:"水产" 22:"粮油" 23:"干货"
		public static const SIGN:String = 'wst';
//		public static const SIGN:String = 'nmc';
		
		public static const CLASS_SHOW:String = SIGN + '.class_show';
		public static const INFOLIST_SHOW:String = SIGN + '.infolist_show';
		public static const VIP_SHOW:String = SIGN + '.info_show';//会员相关界面信息
		public static const MANAGER_SHOW:String = SIGN + '.manager_show';//管理人员
		public static const MERCHANT_SHOW:String = SIGN + '.merchant_show';//商铺人员
//		public static const FOOD_SHOW:String = SIGN + '.food_show';//菜价
		public static const BIG_FOOD_SHOW:String = SIGN + '.bigfood_show';
//		public static const ADMANAGE_SHOW:String = SIGN + '.admanage_show';//头部显示的广告
		public static const ADMANAGE_SHOW:String = SIGN + '.admanage_standby_show';//头部显示的广告
		public static const DETECTION_SHOW:String = SIGN + '.detection1_show';//农残检测
//		public static const DETECTION_SHOW:String = SIGN + '.detection_show';//农残检测
//		public static const TYPE_LIST:String = 'ProjectDB.getTypeList';
		/** 切割图片地址标志位 */
		public static const ADDRESS_KEY:String = ',';
//		[Bindable]
//		public static const imageKey:String = 'maps';
//		[Bindable]
//		public static const fileKey:String = '&map=' + imageKey;
		
//		public static const VERSION:String = 'versionCache';//记录每个列表的版本号 更新用
	}
}