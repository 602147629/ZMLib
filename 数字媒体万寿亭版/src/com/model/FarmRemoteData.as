package com.model
{
	import com.control.FreeCameraControl;
	import com.manager.Vision;
	import com.net.NetConfig;
	import com.net.PhpNet;
	import com.net.Share;
	import com.utils.CacheUtils;
	import com.utils.PowerLoader;
	import com.utils.StarlingLoader;
	import com.view.Merch3DView;
	import com.view.StandMember;
	import com.view.VideoWindow;
	import com.vo.CheckVo;
	import com.vo.FoodStandVo;
	
	import flash.filesystem.File;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	public class FarmRemoteData
	{
		public static const IMAGE_FILE:String = NetConfig.SIGN + '/';
		private static var onComplete:Function;
		//delstate	set('true')
		//checkinfo 审核通过OK
		
		public static var address:String;//服务器ip地址
		public static var path:String;
		public static var isLocal:Boolean;//是否离线版
		public static var isConnect:Boolean = true;//是否连接网络
		
		public static function start(onComplete:Function):void{
			FarmRemoteData.onComplete = onComplete;
			loadConfig();
		}
		
		private static function loadConfig():void
		{
			PowerLoader.loadUrl(new URLRequest("xml/config.xml"),
				URLLoaderDataFormat.TEXT,loadStand);
		}
		
		private static function loadStand(str:String):void
		{
			var xml:XML = XML(str);
			var stand:int = xml.stand[0];
			StandMember.defaultId = stand;
			screenId = xml.screen[0];
			
			var normalColor:uint = xml.color.@normalColor;
			var selectColor:uint = xml.color.@selectColor;
			//系统主色调
			Vision.normalColor = normalColor;
			Vision.selectColor = selectColor;
			
			var beta:Boolean = (int(xml.beta) == 1);
			//			trace("beta" + beta);
			FarmDataBase.showState = beta;
			var detection:Boolean = (int(xml.detection) == 1);
			FarmDataBase.showDetection = detection;
			
			FreeCameraControl.getInstance().keyBoardTurn = int(xml.keyboard) == 1;
			
			var cachePath:int = int(xml.cache);
			saveCachePath(cachePath);
			
			var showVideo:Boolean = (int(xml.video) != 0);
			FarmDataBase.showVideo = showVideo;
			if(showVideo){
				VideoWindow.videoType = int(xml.video);
			}
			if(isLocal){//离线加载
				setTimeout(loadLocalData,500);
				return;
			}
			
			var phpXml:XML = xml.php[0];
			var address:String = phpXml.@address;
			var path:String = phpXml.@path;
			connet(address,path);
		}
		
		/**
		 * 1:桌面位置 2:我的文档 3:applicationDirectory 4:applicationStorageDirectory 5:用户目录userDirectory
		 */		
		private static function saveCachePath(cachePath:int):void
		{
			if(cachePath == 1){
				CacheUtils.fileSavePath = File.desktopDirectory;
			}else if(cachePath == 2){
				CacheUtils.fileSavePath = File.documentsDirectory;
			}else if(cachePath == 3){
				CacheUtils.fileSavePath = File.applicationDirectory;
			}else if(cachePath == 4){
				CacheUtils.fileSavePath = File.applicationStorageDirectory;
			}else if(cachePath == 5){
				CacheUtils.fileSavePath = File.userDirectory;
			}
		}
		
		private static function connet(address:String,path:String):void{
			//			PhpNet.changeServerRoot("http://localhost/");
			//									PhpNet.changeServerRoot("http://192.168.1.107/");
			//			PhpNet.changeServerRoot("http://192.168.1.171/","amf/gateway.php");
			
			if(FarmRemoteData.address != null){
				address = FarmRemoteData.address;
			}else FarmRemoteData.address = address;//再次存储字段
			if(FarmRemoteData.path != null){
				path = FarmRemoteData.path;
			}else FarmRemoteData.path = path;
			
			StarlingLoader.cutAddress = PowerLoader.cutAddress = address;
			//必须设置切点
			PhpNet.changeServerRoot(address,path);
			
			PhpNet.call(NetConfig.CLASS_SHOW,onClassComplete);
			PhpNet.call(NetConfig.INFOLIST_SHOW,onInfoComplete);
			PhpNet.call(NetConfig.MANAGER_SHOW,onManagerComplete);
			PhpNet.call(NetConfig.MERCHANT_SHOW,onMerchantComplete);
			//			PhpNet.call(NetConfig.FOOD_SHOW,onFoodComplete);
			PhpNet.call(NetConfig.BIG_FOOD_SHOW,onFoodComplete);
			PhpNet.call(NetConfig.VIP_SHOW,onVIPComplete);
			
			if(FarmDataBase.showDetection)//需要显示网络农残
				PhpNet.call(NetConfig.DETECTION_SHOW,onDetectionComplete);
			
			if(FarmDataBase.showVideo)
				PhpNet.call(NetConfig.ADMANAGE_SHOW,onAdmanageComplete);
			
			PhpNet.addCompleteEvent(loadLocalData);
			PhpNet.addErrorEvent(onError);
			
			Share.setFile(Share.PHP_DATA);//设置为保存php文件
		}
		
		private static function loadLocalData():void{
			
			Merch3DView.getInstance().loadFloorData(onComplete);
		}
		/**
		 * 链接出错了直接读cache
		 */		
		private static function onError():void
		{
			//			if(onComplete != null)onComplete();
			trace("网络连接失败，读取本地数据");
			isConnect = false;//没有联网状态
			readCache();
		}
		
		/**
		 * 读取本地缓存数据
		 */		
		private static function readCache():void
		{
			if(Share.hasKey(NetConfig.CLASS_SHOW)){
				onClassComplete(Share.read(NetConfig.CLASS_SHOW));
			}
			if(Share.hasKey(NetConfig.INFOLIST_SHOW)){
				onInfoComplete(Share.read(NetConfig.INFOLIST_SHOW));
			}
			if(Share.hasKey(NetConfig.MANAGER_SHOW)){
				onManagerComplete(Share.read(NetConfig.MANAGER_SHOW));
			}
			if(Share.hasKey(NetConfig.MERCHANT_SHOW)){
				onMerchantComplete(Share.read(NetConfig.MERCHANT_SHOW));
			}
			if(Share.hasKey(NetConfig.BIG_FOOD_SHOW)){
				onFoodComplete(Share.read(NetConfig.BIG_FOOD_SHOW));
			}
			if(Share.hasKey(NetConfig.VIP_SHOW)){
				onVIPComplete(Share.read(NetConfig.VIP_SHOW));
			}
			if(FarmDataBase.showVideo && Share.hasKey(NetConfig.ADMANAGE_SHOW)){
				onAdmanageComplete(Share.read(NetConfig.ADMANAGE_SHOW));
			}
			if(FarmDataBase.showDetection && Share.hasKey(NetConfig.DETECTION_SHOW)){
				onDetectionComplete(Share.read(NetConfig.DETECTION_SHOW));
			}
			loadLocalData();
		}
		
		private static function onAdmanageComplete(info:Object):void
		{
			Share.wirte(NetConfig.ADMANAGE_SHOW,info);
			var admanageArr:Array = [];
			for each (var admanageObj:Object in info.data) 
			{
				if(admanageObj.checkinfo == "true" && !(admanageObj.delstate == "true")){
					admanageObj.mode = admanageObj.admode;
					admanageObj.sourceUrl = PhpNet.WWW_ROOT + IMAGE_FILE + admanageObj.picurl;
					admanageArr.push(admanageObj);
				}
			}
			FarmDataBase.tempAdmanageData = admanageArr;
		}
		private static const TEMP_ATT:int = 100;//非法属性值
		//0=>单页,1=>列表,2=>管理人员,3=>商户,4=>会员登陆
		public static const SCREEN_A:String = "A";//政府屏 
		public static const SCREEN_NULL:String = "0";//不分屏 
		private static var screenId:String = SCREEN_A;//分屏id 
		
		private static function onClassComplete(info:Object):void
		{
			Share.wirte(NetConfig.CLASS_SHOW,info);
			
			//			checkinfo//审核通过再存储
			var menuList:Array = [];
			var itemDic:Dictionary = new Dictionary(true);
			//key:pId value:[itemObj...]
			for each (var menuObj:Object in info.data) 
			{
				if(menuObj.checkinfo == "true" && !(menuObj.delstate == "true") && menuObj.class_attribute != TEMP_ATT 
					&& (screenId != SCREEN_NULL ? menuObj.screen == screenId : true)){
					if(menuObj.parentid == 0){//主导航
						menuList.push(menuObj);
					}else{
						if(itemDic[menuObj.parentid] == null){
							itemDic[menuObj.parentid] = [];
						}
						itemDic[menuObj.parentid].push(menuObj);//存放子菜单条目
					}
				}
			}
			//			if(screenId == SCREEN_A){
			//				menuList.push({classname:"工商网"});//
			//			}
			for each (menuObj in menuList) 
			{
				//				var menuSource:Object = getMenuSource(menuObj.id);
				//				if(menuSource == null)continue;//表示不存在
				if((menuObj.picurl) != "")
					menuObj.icon = PhpNet.WWW_ROOT + IMAGE_FILE + menuObj.picurl;
				menuObj.label = menuObj.classname;
				//				menuObj.normalColor = menuSource.normalColor;
				//				menuObj.selectColor = menuSource.selectColor;
				menuObj.items = itemDic[menuObj.id];
				//				menuObj.stand = menuSource.stand;
				menuObj.typeID = menuObj.infotype;
				for each (var itemObj:Object in menuObj.items) 
				{
					var itemSource:Object = getMenuSource(itemObj.id,true);
					itemObj.label = itemObj.classname;
					itemObj.typeID = itemObj.infotype;
					itemObj.attribute = itemObj.class_attribute;
					//					if(itemSource != null){
					//						itemObj.typeID = itemSource.typeID;
					//					}else{
					//						itemObj.typeID = FarmDataBase.DATA_WAIT;
					//					}
				}
			}
			MenuXMLData.menuBarSource = menuList;//重新替换掉客户端的数据
		}
		
		private static function getMenuSource(id:int,isItem:Boolean = false):Object{
			var menuBarSource:Array = MenuXMLData.menuBarSource;
			for each (var menuSource:Object in menuBarSource) 
			{
				if(isItem){
					for each (var itemSource:Object in menuSource.items) 
					{
						if(itemSource["id"] == id){
							return itemSource;
						}
					}
				}else{
					if(menuSource["id"] == id){
						return menuSource;
					}
				}
			}
			return null;
		}
		
		private static function onInfoComplete(info:Object):void
		{
			Share.wirte(NetConfig.INFOLIST_SHOW,info);
			var normalDic:Dictionary = new Dictionary(true);
			for each (var infoObj:Object in info.data) 
			{
				if(infoObj.checkinfo == "true" && !(infoObj.delstate == "true")){
					if(normalDic[infoObj.classid] == null){
						normalDic[infoObj.classid] = [];
					}
					if((infoObj.picurl) != ""){
						infoObj.icon = PhpNet.WWW_ROOT + IMAGE_FILE + infoObj.picurl;//图片地址
					}
					if(infoObj.picbig != null && (infoObj.picbig) != "")
						infoObj.large = PhpNet.WWW_ROOT + IMAGE_FILE + infoObj.picbig;//大图图片地址
					//				nvo.title = normal.title;//标题本来就在
					var date:Date = new Date();
					date.time = infoObj.posttime * 1000;
					//					trace("时间戳:" +  date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日");
					infoObj.time = date;
					
					infoObj.des = infoObj.description;//摘要
					if(infoObj.content != null){
						infoObj.content = infoObj.content.replace("/o:p/gi","b");
						try{
							var xml:XML = XML("<root>" + infoObj.content + "</root>");
							//			xml.p[0].appendChild(":o");
							var config:XML = checkXml(xml);
							var result:String = xmlToString(xml);
							result = result.replace("/&nbsp/gi","　");
							result = result.replace("/宋体/gi","黑体");
							infoObj.content = result + "<br><br><br><br>";
							infoObj.contentXml = config;
						}catch(e:Error){
							trace(infoObj.title + " 内容错误:" + e);
						}
					}
					//					infoObj.large = normal.large;//暂时没有大图
					normalDic[infoObj.classid].push(infoObj);
				}
			}
			FarmDataBase.normalDic = normalDic;
		}
		
		private static function onFoodComplete(info:Object):void
		{
			var tempFoodData:Array = [];
			Share.wirte(NetConfig.BIG_FOOD_SHOW,info);
			for each (var foodObj:Object in info.data) 
			{
				if(foodObj.checkinfo == "true" && !(foodObj.delstate == "true") && foodObj.guide == "true"){
					if((foodObj.picurl) != "")
						foodObj.icon = PhpNet.WWW_ROOT + IMAGE_FILE + foodObj.picurl;
					foodObj.name = foodObj.title;
					//					fvo.id = obj.id;
					//					fvo.number = obj.number;
					//					fvo.title = obj.title;
					//					fvo.price = obj.price;
					tempFoodData.push(foodObj);
				}
			}
			FarmDataBase.tempFoodData = tempFoodData;
			return;
			var menuList:Array = MenuXMLData.menuBarSource;
			if(info.data != null && info.data.length > 0){
				foodObj = info.data[0];
				var classid:String = foodObj.classid;//父id;
				p:for each (var menuObj:Object in menuList) 
				{
					for each (var item:Object in menuObj.items) 
					{
						if(classid == item.id){//找出主导航
							//							var items:Array = menuObj.items;//获取所有子条目
							//							//itemDic[menuObj.id] = obj;
							//							var autos:Array = [];
							menuObj.items = null;
							break p;//跳出循环
						}
					}
				}
			}
			return;//种类全部合并
			//			var foodDic:Dictionary = new Dictionary(true);
			//			for each (var foodObj:Object in info.data) 
			//			{
			//				if(foodObj.checkinfo == "true" && !(foodObj.delstate == "true") && foodObj.guide == "true"){
			//					if((foodObj.picurl) != "")
			//						foodObj.icon = PhpNet.WWW_ROOT + IMAGE_FILE + foodObj.picurl;
			//					foodObj.name = foodObj.title;
			//					//					fvo.id = obj.id;
			//					//					fvo.number = obj.number;
			//					//					fvo.title = obj.title;
			//					//					fvo.price = obj.price;
			//					
			//					if(foodDic[foodObj.classid] == null){
			//						foodDic[foodObj.classid] = [];
			//					}
			//					foodDic[foodObj.classid].push(foodObj);
			//				}
			//			}
			//			if(autos != null){
			//				for(classid in foodDic) 
			//				{
			//					for each (item in items) 
			//					{
			//						if(classid == item.id){//表示这个蔬菜存在
			//							autos.push(item);
			//							break;
			//						}
			//					}
			//					//					if(items[key] !== undefined){//表示这个蔬菜存在
			//					//						autoDic[key] = items[key];//存储起来
			//					//					}
			//				}
			//				menuObj.items = autos;//替换菜单 把其他没有蔬菜的隐藏
			//			}
			//			FarmDataBase.foodDic = foodDic;
		}
		
		private static function onManagerComplete(info:Object):void
		{
			Share.wirte(NetConfig.MANAGER_SHOW,info);
			var pList:Array = [];
			for each (var managerObj:Object in info.data) 
			{
				if(managerObj.checkinfo == "true" && !(managerObj.delstate == "true")){
					if((managerObj.picurl) != "")
						managerObj.icon = PhpNet.WWW_ROOT + IMAGE_FILE + managerObj.picurl;
					managerObj.name = managerObj.title;
					managerObj.occup = managerObj.job;
					if((managerObj.flag) != "")
						managerObj.large = PhpNet.WWW_ROOT + IMAGE_FILE + managerObj.picbig;
					pList.push(managerObj);
				}
			}
			FarmDataBase.tempPersonList = pList;
			//			var managerDic:Dictionary = new Dictionary(true);
			//			var mainObj:Object;//领头人物
			//			for each (var managerObj:Object in info.data) 
			//			{
			//				if(managerObj.checkinfo){
			//					managerDic[managerObj.id] = managerObj;
			//					if(managerObj.mainpstr == -1){
			//						mainObj = managerObj;//定位领头
			//					}
			//				}
			//			}
			//			for each (managerObj in managerDic) 
			//			{
			//				managerObj.label = managerObj.title;
			//				managerObj.personList = [{id:managerObj.id,icon:PhpNet.WWW_ROOT + IMAGE_FILE + managerObj.picurl,
			//					name:managerObj.title,occup:managerObj.job,number:managerObj.number}];
			//				if(managerObj.mainpstr != -1){
			//					var parentObj:Object = managerDic[managerObj.mainpstr];
			//					if(parentObj != null){
			//						if(parentObj.itemFiled == null){
			//							parentObj.itemFiled = [];
			//						}
			//						parentObj.itemFiled.push(managerObj);
			//					}
			//				}
			//			}
			//			FarmDataBase.tempTreeData = mainObj;
		}
		
		private static function onVIPComplete(info:Object):void
		{
			Share.wirte(NetConfig.VIP_SHOW,info);
			var vipList:Array = [];
			for each (var vipObj:Object in info.data) 
			{
				if(vipObj.checkinfo == "true" && !(vipObj.delstate == "true")){
					if(vipObj.content != null){
						try{
							var xml:XML = XML("<root>" + vipObj.content + "</root>");
							//			xml.p[0].appendChild(":o");
							var config:XML = checkXml(xml);
							var result:String = xmlToString(xml);
							result = result.replace("/&nbsp/g","　");
							vipObj.content = result + "<br><br><br><br>";
							vipObj.contentXml = config;
						}catch(e:Error){
							trace(vipObj.title + " 内容错误:" + e);
						}
					}
					vipList.push(vipObj);
				}
			}
			FarmDataBase.tempVipData = vipList;
		}
		
		private static function onDetectionComplete(info:Object):void
		{
			Share.wirte(NetConfig.DETECTION_SHOW,info);
			var fvo:FoodStandVo = new FoodStandVo();
			for each (var deteObj:Object in info.data) 
			{
				if(deteObj.checkinfo == "true" && !(deteObj.delstate == "true")){
					fvo.personName = deteObj.author;
					var date:Date = new Date();
					date.time = Number(deteObj.posttime) * 1000;
					fvo.time = date;
					fvo.result = deteObj.report;//检测结果
					if((deteObj.picurl) != ""){
						fvo.xlsPath = PhpNet.WWW_ROOT + IMAGE_FILE + deteObj.picurl;//图片地址
					}
					break;
				}
			}
			FarmDataBase.foodStandVo = fvo;
			//			return;
			//			var cList:Vector.<CheckVo> = new Vector.<CheckVo>();
			//			for each (var deteObj:Object in info.data) 
			//			{
			//				if(deteObj.checkinfo == "true" && !(deteObj.delstate == "true")){
			//					var cvo:CheckVo = new CheckVo();
			//					cvo.id = deteObj.id;
			//					if(int(deteObj.booth) < 10)deteObj.booth = "0" + deteObj.booth;
			//					cvo.merchId = deteObj.booth;
			//					cvo.merchName = deteObj.title;
			//					cvo.foodName = deteObj.goods;
			//					cvo.origin = deteObj.origin;
			//					cvo.count = deteObj.number;
			//					cvo.result = deteObj.detection;
			//					cList.push(cvo);
			//					if(fvo.personName == null){
			//						fvo.personName = deteObj.author;//检测人
			//					}
			//					if(fvo.time == null){
			//						var date:Date = new Date();
			//						date.time = Number(deteObj.time) * 1000;
			//						fvo.time = date;
			//					}
			//					if(fvo.result == null){
			//						fvo.result = deteObj.report;
			//					}
			//				}
			//			}
			//			fvo.checKList = cList;
			//			FarmDataBase.foodStandVo = fvo;
		}
		
		/**
		 * 
		 */		
		private static function onMerchantComplete(info:Object):void
		{
			Share.wirte(NetConfig.MERCHANT_SHOW,info);
			var merchDic:Dictionary = new Dictionary(true);
			//			for each (var merchObj:Object in info.data) 
			//			{
			//				if(merchObj.checkinfo == "true" && !(merchObj.delstate == "true")){
			//					merchObj.name = merchObj.title;
			//					merchObj.merchId = merchObj.number;
			//					merchObj.level = merchObj.grade;
			//					merchObj.licenseIcon = merchObj.picarr;
			//					if((merchObj.picurl) != "")
			//						merchObj.avatarIcon = PhpNet.WWW_ROOT + IMAGE_FILE + merchObj.picurl;
			//					if(merchDic[merchObj.classid] == null){
			//						merchDic[merchObj.classid] = [];
			//					}
			//					merchDic[merchObj.classid].push(merchObj);
			//				}
			//			}
			var menuList:Array = MenuXMLData.menuBarSource;
			if(info.data != null && info.data.length > 0){
				var foodObj:Object = info.data[0];
				var classid:String = foodObj.classid;//父id;
				p:for each (var menuObj:Object in menuList) 
				{
					for each (var item:Object in menuObj.items) 
					{
						if(classid == item.id){//找出主导航
							var items:Array = menuObj.items;//获取所有子条目
							//itemDic[menuObj.id] = obj;
							var autos:Array = [];
							menuObj.items = null;
							break p;//跳出循环
						}
					}
				}
			}
			for each (var merchObj:Object in info.data) 
			{
				if(merchObj.checkinfo == "true" && !(merchObj.delstate == "true")){
					merchObj.name = merchObj.title;
					merchObj.merchId = merchObj.number;
					merchObj.level = merchObj.grade;
					merchObj.licenseIcon = merchObj.picarr;
					if((merchObj.picurl) != "")
						merchObj.avatarIcon = PhpNet.WWW_ROOT + IMAGE_FILE + merchObj.picurl;
					if(merchDic[merchObj.classid] == null){
						merchDic[merchObj.classid] = [];
					}
					merchDic[merchObj.classid].push(merchObj);
				}
			}
			if(autos != null){
				for each (item in items) 
				{
					for(classid in merchDic) 
					{
						if(classid == item.id){//表示这个蔬菜存在
							autos.push(item);
							break;
						}
					}
				}
				//					if(items[key] !== undefined){//表示这个蔬菜存在
				//						autoDic[key] = items[key];//存储起来
				//					}
				menuObj.items = autos;//替换菜单 把其他没有蔬菜的隐藏
			}
			FarmDataBase.merchDic = merchDic;
			//			FarmDataBase.tempMerchData = merchList;
		}
		/**
		 * @param tarXml
		 * @return config
		 */		
		private static function checkXml(tarXml:XML,config:XML = null):XML{
			var index:int = 0;
			if(config == null){
				config = <root></root>;
			}
			for each (var child:XML in tarXml.children()) 
			{
				if(child.name() == "img"){
					var tag:String = "`" + index++;
					if((child.@src) != "")
						child.@src = PhpNet.WWW_ROOT + IMAGE_FILE + child.@src;
					config.appendChild(<icon iconUrl={child.@src} iconType ="jpg" iconStr={tag}/>);
					tarXml.replace(child.childIndex(), tag);
				}else if(child.name() == "strong"){
					tarXml.replace(child.childIndex(), <b>{child.toString()}</b>);
				}
				if(child.hasOwnProperty("@style")){
					delete child.@style;
//					trace(child.@style);
				}
				checkXml(child,config);
			}
			return config;
		}
		
		private static function xmlToString(tarXml:XML,result:String = null):String{
			if(result == null){
				result = "";
			}
			for each (var child:XML in tarXml.children()) 
			{
				if(child.name() == null){
					result += child.toString();
				}else{
					var str:String = "";
					result += xmlToString(child,str);
				}
			}
			var attName:String = " ";
			for each(var att:Object in tarXml.attributes()){
				attName += att.name() + "='" + att + "' ";
			}
			return "<" + tarXml.name() + attName + ">" + result + "</" + tarXml.name() + ">";
		}
		
		
	}
}