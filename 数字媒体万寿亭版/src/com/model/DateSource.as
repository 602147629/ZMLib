package com.model
{
	import com.net.Share;
	import com.vo.FoodDateVo;
	
	import flash.utils.Dictionary;
	
	public class DateSource
	{
		public static const DATE_HOUR:String = '日';//24
		public static const DATE_WEEK:String = '周';//7
		public static const DATE_MONTH:String = '月';//30
		public static const DATE_MONTH_THREE:String = '3月';//30 * 3
		public static const DATE_YEAR:String = '1年';//365
		public static const DATE_YEAR_THREE:String = '3年';//365 * 3
		
		public static const DATE_SOURCE:Array = [{label:"周",date:DateSource.DATE_WEEK},
			{label:"月",date:DateSource.DATE_MONTH},{label:"年",date:DateSource.DATE_YEAR}];
		
		private static const MAX_COUNT:int = 9;//最多显示信息12条
		/**
		 * 间隔时间区间 单位毫秒
		 * @return 
		 */		
		public static function getTimeGap(dType:String):Number{
			var base:int = 1000 * 3600;//1小时
			switch(dType){
				case DATE_HOUR:return base * 24;
				case DATE_WEEK:return base * 24 * 7;
				case DATE_MONTH:return base * 24 * 30;
				case DATE_MONTH_THREE:return base * 24 * 30 * 3;
				case DATE_YEAR:return base * 24 * 365;
				case DATE_YEAR_THREE:return base * 24 * 365 * 3;
			}
			return 0;
		}
		/**
		 * 根据每种类型获取每个单位最多可以显示的间隔
		 * @param dType
		 * @param timeGap
		 * @return 间隔单位数组
		 */		
		public static function getEveryGap(dType:String,timeGap:Number):Vector.<Number>{
			var base:Number = 1000 * 3600;//1小时
			var list:Vector.<Number> = new Vector.<Number>();
			if(dType == DATE_HOUR){
				var hours:Number = Math.ceil(timeGap / base);//小时数
				if(hours < MAX_COUNT){
					for (var i:int = 0; i < hours; i++) list.push(base);
				}else{
					var baseHourGap:int = hours / MAX_COUNT;//间隔小时段
					for (i = 0; i < MAX_COUNT; i++) 
					{
						list.push(base * baseHourGap);
					}
					var lastHour:Number = hours % MAX_COUNT;//剩下的小时数
					for (var j:int = 0;j < lastHour; j++) 
					{
						list[MAX_COUNT - 1 - j] += base;//时间远的间隔数拉长
					}
				}
			}else{
				var days:Number = Math.ceil(timeGap / (24 * base));//天数
				if(days < MAX_COUNT){
					for (i = 0; i < days; i++) list.push(base * 24);
				}else{
					var baseDayGap:int = days / MAX_COUNT;//间隔天数
					for (i = 0; i < MAX_COUNT; i++) 
					{
						list.push(base * 24 * baseDayGap);
					}
					var lastDay:Number = days % MAX_COUNT;//剩下的小时数
					for (j = 0;j < lastDay; j++) 
					{
						list[MAX_COUNT - 1 - j] += base * 24;//时间远的间隔数拉长
					}
				}
			}
			return list;
		}
		//		public static const ID_ALL:int = 0;//表示所有城市平均指标
		/**
		 * 
		 * @param id 植物id
		 * @param dType 时间段
		 * @param startTime 开始时间:-1
		 * @param endTime 结束时间:-1
		 * @return 
		 */		
		public static function queryByRange(id:int,dType:String,startTime:Number = -1,
											endTime:Number = -1):Array{
			var dataList:Array = getDateList(dType,startTime,endTime);
			for (var i:int = dataList.length - 1; i >= 0; i--) 
			{
				dataList[i] = getDateVo(id,dataList[i]);
			}
			return dataList;
		}
		
		public static const HOUR_FORMAT:String = "DD/HH:00";//小时制
		private static function getDateList(dType:String,startTime:Number = -1,
											endTime:Number = -1):Array{
			var waterList:Array = [];
			var tempDate:Date = new Date();
			if(startTime == -1 || endTime == -1){
				var timeGap:Number = getTimeGap(dType);//自己计算间隔时间
				endTime = tempDate.time;//从今天开始
			}else{
				timeGap = endTime - startTime;
			}
			var tempTime:Number = endTime;
			var list:Vector.<Number> = getEveryGap(dType,timeGap);
			list.push(0);
			
			//			var df:DateFormatter = new DateFormatter();
			//			df.formatString ="YYYY/MM/DD";
			for each (var time:Number in list) 
			{
				tempDate.time = tempTime;
				if(dType == DATE_HOUR){
					//df.formatString = HOUR_FORMAT;
				}/*else if(dType == DATE_YEAR || dType == DATE_YEAR_THREE){
					//					df.formatString = "YY/MM/DD";
					waterList.push(tempDate.fullYear + "年" + (tempDate.month + 1) + "月" + tempDate.date + "日");
				}*/else{
					waterList.push((tempDate.month + 1) + "月" + tempDate.date + "日");
					//					df.formatString = "MM/DD";
				}
				//				var date:String = df.format(tempDate);
				//				if(date.lastIndexOf('24:00') >= 0){//搜索到了替换掉
				//					date = date.replace('24:00','00:00');
				//				}
				//				waterList.push(date);
				tempTime -= time;
			}
			return waterList.reverse();
		}
		/**
		 * 获取某城市水指标
		 * @param id 城市id
		 * @param date 时间
		 * @return 
		 */		
		public static function getDateVo(id:int,date:String):FoodDateVo{
			Share.setFile(Share.FILE_FOOD);
			var obj:Object = Share.read(id + '_' + date);
			var dvo:FoodDateVo;
			if(obj == null){
				dvo = new FoodDateVo();
				dvo["price"] = (10 + Math.random() * 50).toFixed(0);
				dvo["count"] = (0 + Math.random() * 200).toFixed(0);
				dvo.date = date;
				Share.wirte(id + '_' + date,{price:dvo.price,count:dvo.count,date:date});
			}else{
				dvo = new FoodDateVo();
				for(var key:String in obj){
					dvo[key] = obj[key];
				}
			}
			return dvo;
		}
	}
}