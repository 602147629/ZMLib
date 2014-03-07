package com.model
{
	import com.vo.AdmanageVo;
	import com.vo.CheckVo;
	import com.vo.FoodDetailsVo;
	import com.vo.FoodStandVo;
	import com.vo.FoodVo;
	import com.vo.MenuItemVo;
	import com.vo.MenuVo;
	import com.vo.MerchVo;
	import com.vo.NormalItemVo;
	import com.vo.PersonVo;
	import com.vo.TraceVo;
	import com.vo.TreeTrunkVo;
	import com.vo.VipVo;
	
	import flash.utils.Dictionary;

	/**
	 * 农场数据库
	 */	
	public class FarmDataBase
	{
		public static var showState:Boolean = false;//是否显示状态
		public static var showVideo:Boolean = true;//是否显示状态
		public static var showDetection:Boolean = true;//是否显示网络农残数据
		
		public static const TYPE_COUNT:String = "count";
		public static const TYPE_PRICE:String = "price";

		public static function getUnitName(key:String):String{
			if(key == TYPE_COUNT){
				return "公斤";
			}else if(key == TYPE_PRICE){
				return "元/公斤";
			}
			return null;
		}
		
		//0=>单页,1=>列表,2=>管理人员,3=>商户,4=>会员登陆,5=>菜价
		public static const DATA_NORMAL:String = "1";
		//首页普通数据id
		public static const DATA_PERSON:String = "2";
		
		public static const DATA_FOOD:String = "5";
		
		public static const DATA_LINK:String = "8";//链接官网类型
		
		public static const DATA_TRACE:String = "DATA_TRACE";
		
		public static const DATA_MERCH:String = "3";
		
		public static const DATA_VIP:String = "0";//会员服务
		
		public static const DATA_ADMANAGE:String = "DATA_ADMANAGE";//广告
		
		public static const DATA_WAIT:String = "4";//会员登陆系统更新中
		
		private static var _tempMerchData:Array = [
			{name:"美女1",merchId:110,floor:1,level:3,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女2",merchId:111,floor:1,level:2,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女3",merchId:112,floor:1,level:4,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女4",merchId:113,floor:1,level:5,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女6",merchId:116,floor:1,level:3,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女7",merchId:118,floor:1,level:2,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"},
			{name:"美女5",merchId:114,floor:1,level:1,
				avatarIcon:"assets/merch/merch01.jpg",licenseIcon:"assets/merch/license01.jpg"}
		];
		
//		public static function set tempMerchData(value:Array):void
//		{
//			_tempMerchData = value;
//		}
		private static var _tempVipData:Array = [];//id数据列表
		public static function set tempVipData(value:Array):void
		{
			_tempVipData = value;
		}
		private static var _merchDic:Dictionary = new Dictionary(true);//商户各类型列表
		public static function set merchDic(value:Dictionary):void
		{
			_merchDic = value;
		}
		
		private static var _tempTreeData:Object = {
			label:"总经理",
			personList:[
				new PersonVo("assets/person/person01.jpg","美女啊1","主管肯定1","XXXX0",99.9),
				new PersonVo("assets/person/person01.jpg","美女啊2","主管肯定2","XXXX1",69.9),
				new PersonVo("assets/person/person01.jpg","美女啊3","主管肯定3","XXXX2",89.9),
				new PersonVo("assets/person/person01.jpg","美女啊4","主管肯定4","XXXX3",29.5),
				new PersonVo("assets/person/person01.jpg","美女啊5","主管肯定5","XXXX4",19.9)
			],
			itemFiled:[
				{
					label:"部门1",
					personList:[
						new PersonVo("assets/person/person01.jpg","美女啊6","主管肯定6","XXXX5",29.9),
						new PersonVo("assets/person/person01.jpg","美女啊7","主管肯定7","XXXX6",19.9),
						new PersonVo("assets/person/person01.jpg","美女啊8","主管肯定8","XXXX7",39.9),
						new PersonVo("assets/person/person01.jpg","美女啊9","主管肯定9","XXXX8",69.5),
						new PersonVo("assets/person/person01.jpg","美女啊10","主管肯定10","XXXX9",89.9)
					],
					itemFiled:[
						{
							label:"普通员工1",
							itemFiled:[
								{
									label:"员工1"
								},
								{
									label:"员工2"
								},
								{
									label:"员工3"
								}
							]
						},
						{
							label:"精英员工1",
							itemFiled:[
								{
									label:"员工4"
								},
								{
									label:"员工5"
								}
							]
						}
					]
				},
				{
					label:"部门2",
					itemFiled:[
						{
							label:"普通员工2",
							itemFiled:[
								{
									label:"员工6"
								},
								{
									label:"员工7"
								},
								{
									label:"员工8"
								},
								{
									label:"员工9"
								}
							]
						}
					]
				},
				{
					label:"部门3",
					itemFiled:[
						{
							label:"精英员工2",
							itemFiled:[
								{
									label:"员工10"
								},
								{
									label:"员工11"
								},
								{
									label:"员工12"
								}
							]
						}
					]
				}
			]
		};

//		public static function get tempTreeData():Object
//		{
//			return _tempTreeData;
//		}
		public static function set tempTreeData(value:Object):void
		{
			_tempTreeData = value;
		}
		
		private static var _tempPersonList:Array;
		public static function set tempPersonList(value:Array):void{
			_tempPersonList = value;
		}
		
//		public static function set foodDic(value:Array):void
//		{
//			_foodDic = value;
//		}
		
		public static function set tempFoodData(value:Array):void
		{
			_tempFoodData = value;
		}
		
		private static var _tempFoodData:Array = [
			{icon:"assets/food/food01.jpg",name:"茄子",price:5},
			{icon:"assets/food/food02.jpg",name:"胡萝卜",price:6},
			{icon:"assets/food/food03.jpg",name:"玉米",price:7},
			{icon:"assets/food/food04.jpg",name:"辣椒",price:15},
			{icon:"assets/food/food05.jpg",name:"洋葱",price:3},
			{icon:"assets/food/food06.jpg",name:"秋刀鱼",price:25},
			{icon:"assets/food/food07.jpg",name:"山药",price:10}
		];
		public var merchId:String;//商铺id号
		public var merchName:String;//商铺名称
		public var foodName:String;//商品名称
		public var origin:String;//产地名称
		public var count:int;//数量
		public var result:String;//结果
		
		private static var _tempCheckData:Array = [//检测结果
			{merchId:"74",merchName:"涂细旺",foodName:"菠菜",origin:"良褚",count:18,result:1},
			{merchId:"86",merchName:"梅玉财",foodName:"黄瓜",origin:"良褚",count:20,result:1},
			{merchId:"84",merchName:"王祥汉",foodName:"西红柿",origin:"良褚",count:18,result:1},
			{merchId:"76",merchName:"华张根",foodName:"四季豆",origin:"良褚",count:20,result:1},
			{merchId:"88",merchName:"李张林",foodName:"茭白",origin:"萧山",count:16,result:1},
			{merchId:"88",merchName:"李张林",foodName:"包心菜",origin:"萧山",count:10,result:1},
			{merchId:"70",merchName:"陆冬芳",foodName:"芹菜",origin:"萧山",count:15,result:1},
			{merchId:"90",merchName:"陶善良",foodName:"洋葱",origin:"下沙",count:16,result:1},
			{merchId:"91",merchName:"李胜荣",foodName:"玉米",origin:"富阳",count:15,result:1},
			{merchId:"91",merchName:"李胜荣",foodName:"青菜",origin:"富阳",count:20,result:1},
			{merchId:"83",merchName:"吕冬水",foodName:"生菜",origin:"良褚",count:15,result:1},
			{merchId:"74",merchName:"涂细旺",foodName:"四季豆",origin:"良褚",count:18,result:1},
			{merchId:"10",merchName:"方惠通",foodName:"黄鱼",origin:"萧山",count:15,result:1},
			{merchId:"08",merchName:"方佩君",foodName:"带鱼",origin:"萧山",count:18,result:1},
			{merchId:"61",merchName:"孙万国",foodName:"年糕",origin:"自产",count:40,result:1},
			{merchId:"61",merchName:"孙万国",foodName:"潮面",origin:"自产",count:18,result:1},
			{merchId:"59",merchName:"陈创增",foodName:"香肠",origin:"唯心",count:15,result:1},
			{merchId:"59",merchName:"陈创增",foodName:"咸肉",origin:"近江",count:50,result:1},
			{merchId:"44",merchName:"张静彬",foodName:"牛肉",origin:"富阳",count:35,result:1},
			{merchId:"67",merchName:"李笑丽",foodName:"贡丸",origin:"唯心",count:15,result:1}
		];
		
		private static var _foodStandVo:FoodStandVo;
		public static function get foodStandVo():FoodStandVo
		{
			return _foodStandVo;
		}
		public static function set foodStandVo(value:FoodStandVo):void
		{
			_foodStandVo = value;
		}
//		public static function getCheckVo():FoodStandVo{
//			if(checkStandVo == null){
//				createCheckList();
//			}
//			return checkStandVo;
//		}
		
//		private static function createCheckList():void
//		{
//			checkList = new Vector.<CheckVo>();
//			for each (var cObj:Object in _tempCheckData) 
//			{
//				var cvo:CheckVo = new CheckVo();
//				cvo.id = cObj.id;
//				cvo.merchId = cObj.merchId;
//				cvo.merchName = cObj.merchName;
//				cvo.foodName = cObj.foodName;
//				cvo.origin = cObj.origin;
//				cvo.count = cObj.count;
//				cvo.result = cObj.result;
//				checkList.push(cvo);
//			}
//		}
		
		private static var tempTraceData:Array = [
			{date:"12/06",
				foodList:[
					{icon:"assets/food/food01.jpg",id:0,name:"茄子",weight:1.2,price:6,merchId:"086",merchName:"美女1",dealDate:"00:00"},
					{icon:"assets/food/food02.jpg",id:1,name:"胡萝卜",weight:5.2,price:6,merchId:"086",merchName:"美女2",dealDate:"00:00"},
					{icon:"assets/food/food05.jpg",id:4,name:"洋葱",weight:3.2,price:6,merchId:"086",merchName:"美女3",dealDate:"00:00"},
					{icon:"assets/food/food01.jpg",id:0,name:"茄子",weight:1.6,price:6,merchId:"086",merchName:"美女5",dealDate:"00:00"},
					{icon:"assets/food/food03.jpg",id:2,name:"玉米",weight:8,price:6,merchId:"086",merchName:"美女6",dealDate:"00:00"},
					{icon:"assets/food/food04.jpg",id:3,name:"辣椒",weight:1.2,price:6,merchId:"086",merchName:"美女7",dealDate:"00:00"},
					{icon:"assets/food/food07.jpg",id:6,name:"山药",weight:2,price:6,merchId:"086",merchName:"美女8",dealDate:"00:00"},
					{icon:"assets/food/food06.jpg",id:5,name:"秋刀鱼",weight:1.2,price:6,merchId:"086",merchName:"美女9",dealDate:"00:00"}
				]
			},
			{date:"12/05",
				foodList:[
					{icon:"assets/food/food03.jpg",id:2,name:"玉米",weight:1.2,price:6,merchId:"086",merchName:"美女11",dealDate:"00:00"},
					{icon:"assets/food/food01.jpg",id:0,name:"茄子",weight:5.2,price:6,merchId:"086",merchName:"美女12",dealDate:"00:00"},
					{icon:"assets/food/food02.jpg",id:1,name:"胡萝卜",weight:3.2,price:6,merchId:"086",merchName:"美女13",dealDate:"00:00"},
					{icon:"assets/food/food05.jpg",id:4,name:"洋葱",weight:1.6,price:6,merchId:"086",merchName:"美女15",dealDate:"00:00"}
				]
			}
		];
			
		private static var tempNormalData:Array = [
			{icon:"assets/image/image01.jpg",large:"assets/large/large01.jpg",
				title:"省领导参观刀矛巷农贸市场1",des:"省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场"},
			{icon:"assets/image/image02.jpg",large:"assets/large/large02.jpg",
				title:"省领导参观刀矛巷农贸市场2",
				des:"　　农贸市场，作为和老百姓“菜篮子”息息相关的地方，在经过了路边设摊、退路入室的阶段，又将向哪个方向发展，才能够和老百姓日益提高的消费水平相吻合？\n" +
"　　杭州市政府将2006年定为农贸市场管理年，为农贸市场的改造制定了一个新的方向，传统概念中的农贸市场，经过了一年的改造，焕发出了一种新的面貌。\n" + 
"　　记者见闻\n" + 
"　　只有吆喝声里还有老菜场影子\n" + 
"　　刀茅巷农贸市场在杭州城里名气不小，因为这里的蔬菜品种又多又新鲜，每天杭州城都有许多“马大嫂”远从大关、拱宸桥坐车赶来买菜。最近，“马大嫂”们惊喜地发现，她们原先熟悉的那座在大棚底下的市场，完全变了个模样。\n" + 
"　　新的刀茅巷农贸市场在选址上就颇为特别。农贸市场和大型超市在生鲜食品市场上本来就是竞争对手，而新的刀茅巷农贸市场，就开在大型超市好又多的斜对面，大有与超市叫板的意思。\n" + 
"　　走进农贸市场，新鲜感扑面而来。先是市场入口，不光放着普通菜场常见的公平秤，还在一旁立了一个大大的电子屏幕，在屏幕上不断滚动出现“XX摊位，大白菜，今日检测结果，合格”等字样。\n " +
"　　分成两层的市场里，划分得条理清楚，什么区域卖什么东西，一目了然。在水产区，每一种水产品都分处在统一规格的玻璃缸里，排列整齐；家禽摊位做成了全封闭式的，摊主通过玻璃窗和移门与顾客打交道，再也看不到“一地鸡毛”的杂乱景象。市场内，灯光明亮，地面也干净整洁，俨然是一副超市的模样。整个市场里，恐怕只有此起彼伏的吆喝声，和摊主顾客间的讨价还价声提醒记者，现在身处的是农贸市场。\n" + 
"　　刀茅巷农贸市场主任蒋云祥对记者的这些感受一点也不感到奇怪。他告诉记者：“现在的这个市场，面积有近3000平方米，营业面积有2000平方米，还配备了地下车库；所有的污水通过内部下水管道排走，所以地上很干净。菜场里还设有冷藏保险间，配有货梯间、监控录像。”这些设施和此前利用旧厂房改建的菜场设施相比，简直有天壤之别。以往菜场给人的那种“脏、乱、湿、差”的混乱感，在这里完全找不到了。\n" + 
"　　新型农贸市场不光在建设上改变了面貌，以前的那种松散的管理方式也被一系列标准的管理制度所代替。市场里建立了检测室，随时检测商品质量。检测的结果就公布在进门的那个显示屏上，显示屏上还会公布价格信息等等。而通过监控探头，管理人员可以及时掌握和查核市场动态，加强管理和服务。“我们还请了一家电脑公司给我们开发农贸市场管理方面的专门软件。等软件用上之后，我们可以对经营户的情况进行电子化管理，提高工作效率。”\n" + 
"　　老百姓喜欢“讨价还价”的感觉\n" + 
"　　市区内的农贸市场经过这一番改造后，购物环境已与超市相差无几。对于和超市唱对台戏的局面，蒋云祥说这倒是无心之举：“菜场和超市自然是形成了竞争的，超市的生鲜生意也会给我们很大的压力。但是超市走的是大而全的路线，而菜场有自身的灵活、新鲜、多变的特点，可谓各有特色。而且老百姓对于菜场也有一份特别的感情，所以我们只要突出我们特色的内容，就能够取得优势。”\n" + 
"　　记者从买菜的那些大伯大妈们那里，印证了蒋云祥的说法。袁大妈就住在菜场后面的知足巷里，每次接了孩子就放在菜场门口新建的一排塑料椅子上，然后自己到菜场里逛去。“比起超市，这里更加节省时间，这里的菜更加新鲜，而且品种也多，所以还是喜欢来这里买菜。”看来袁大妈是个很会精打细算的人。\n" + 
"　　边上一位看来也很精明的大妈还凑上来加了一句：“超市还有一样不同。在这里，还可以和老板讨价还价，遇到不肯便宜，脾气大的老板，不去买他的东西，买别家的就行了。”这句话引得周围的“马大嫂”们频频点头。看到有这么多人赞同她的观点，这位大妈又补充道：“以前就是觉得菜场的地脏，到处都是泥和水，现在装修得和超市一样，东西还比超市好，当然大家就更加要来菜场里买菜了。”\n" + 
"　　至于菜场的摊主们，换了一个新环境之后，都还在适应过程中。虽然摊位的面积变得小了，规矩也比以前多了，但是他们还是信心满满：“过些日子，一些老顾客知道了新菜场的位置，肯定会赶过来。加上现在菜场里的环境卫生弄得好了，生意会更加好，不怕没有顾客上门。”"},
			{icon:"assets/image/image03.jpg",large:"assets/large/large03.jpg",
				title:"省领导参观刀矛巷农贸市场3",des:"省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场"},
			{icon:"assets/image/image01.jpg",large:"assets/large/large04.jpg",
				title:"省领导参观刀矛巷农贸市场4",des:"省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场"},
			{icon:"assets/image/image02.jpg",large:"assets/large/large05.jpg",
				title:"省领导参观刀矛巷农贸市场5",des:"省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场"},
			{icon:"assets/image/image03.jpg",
				title:"省领导参观刀矛巷农贸市场6",des:"省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场省领导参观刀矛巷农贸市场"}
		];
		
//		avo.id = adObj.id;
//		avo.mode = adObj.mode;
//		avo.sourceUrl = adObj.sourceUrl;
		private static var _tempAdmanageData:Array = [
			{id:0,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/1.jpg"},
			{id:1,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/2.jpg"},
			{id:2,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/3.jpg"},
			{id:3,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/4.jpg"},
			{id:5,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/5.jpg"},
			{id:6,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/6.jpg"},
			{id:7,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/7.jpg"},
			{id:8,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/8.jpg"},
			{id:9,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/9.jpg"},
			{id:10,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/10.jpg"},
			{id:11,mode:AdmanageVo.MODE_IMAGE,sourceUrl:"assets/video/11.jpg"}
		]
		public static function get tempAdmanageData():Array
		{
			return _tempAdmanageData;
		}
		public static function set tempAdmanageData(value:Array):void
		{
			_tempAdmanageData = value;
		}
		
		private static var normalList:Vector.<NormalItemVo>;
		public static function getDataList(id:int,typeID:String):Object{
			switch(typeID){
				case DATA_NORMAL:
					return getNormalList(id);
					break;
				case DATA_PERSON:
					return getPersonList();
					break;
				case DATA_FOOD:
					return getFoodList();
					break;
				case DATA_TRACE:
					return getTraceList();
					break;
				case DATA_MERCH:
					return getMerchList(id);
					break;
				case DATA_VIP:
					return getVipList();
					break;
				case DATA_ADMANAGE:
					return getAdmanageList();
					break;
			}
			return null;
		}
		
		public static function getVipVo(classid:int):VipVo{
			var vList:Vector.<VipVo> = getVipList();
			for each (var vvp:VipVo in vList) 
			{
				if(vvp.classid == classid){
					return vvp;
				}
			}
			return null;
		}
		
		private static var vipList:Vector.<VipVo>;
		private static function getVipList():Vector.<VipVo>
		{
			if(vipList == null){
				createVipList();
			}
			return vipList;
		}
		
		private static function createVipList():void
		{
			vipList = new Vector.<VipVo>();
			for each (var vipObj:Object in _tempVipData) 
			{
				var vvo:VipVo = new VipVo();
				vvo.id = vipObj.id;
				vvo.title = vipObj.title;
				vvo.content = vipObj.content;
				vvo.contentXml = vipObj.contentXml;
				vvo.classid = vipObj.classid;
				vipList.push(vvo);
			}
		}
		
		private static var admanageList:Vector.<AdmanageVo>;
		public static function getAdmanageList():Vector.<AdmanageVo>
		{
			if(admanageList == null){
				createAdmanageList();
			}
			return admanageList;
		}
		
		private static function createAdmanageList():void
		{
			admanageList = new Vector.<AdmanageVo>();
			for each (var adObj:Object in _tempAdmanageData) 
			{
				var avo:AdmanageVo = new AdmanageVo();
				avo.id = adObj.id;
				avo.mode = adObj.mode;
				avo.sourceUrl = adObj.sourceUrl;
				admanageList.push(avo);
			}
		}
		
		private static var personList:Vector.<PersonVo>;
		public static function getPersonList():Vector.<PersonVo>
		{
			if(personList == null){
				createPersonList();
			}
			return personList;
		}
		
		private static function createPersonList():void
		{
			personList = new Vector.<PersonVo>();
			for each (var personObj:Object in _tempPersonList) 
			{
				var pvo:PersonVo = new PersonVo();
				pvo.id = personObj.id;
				pvo.icon = personObj.icon;
				pvo.name = personObj.name;
				pvo.occup = personObj.occup;
				pvo.number = personObj.number;
				pvo.agree = personObj.agree;
				pvo.large = personObj.large;
				personList.push(pvo);
			}
		}
		//		private static var treeTrunkVo:TreeTrunkVo;
//		private static function getTreeList():Object
//		{
//			if(treeTrunkVo == null && _tempTreeData != null){
//				treeTrunkVo = openTrunk(_tempTreeData);
//			}
//			return treeTrunkVo;
//		}
		
		private static function openTrunk(data:Object):TreeTrunkVo{
			var tvo:TreeTrunkVo = getTrunk(data);
			for each (var personObj:Object in data.personList) 
			{
				var pvo:PersonVo = new PersonVo();
				pvo.id = personObj.id;
				pvo.icon = personObj.icon;
				pvo.name = personObj.name;
				pvo.occup = personObj.occup;
				pvo.number = personObj.number;
				pvo.agree = personObj.agree;
				tvo.personList.push(pvo);
			}
			for each (var itemObj:Object in data.itemFiled) 
			{
				var child:TreeTrunkVo = openTrunk(itemObj);
				tvo.itemFiled.push(child);
			}
			return tvo;
		}
		
		private static function getTrunk(treeData:Object):TreeTrunkVo
		{
			if(treeData == null)return null;
			var tvo:TreeTrunkVo = new TreeTrunkVo();
			tvo.label = treeData.label;
			tvo.personList = new Vector.<PersonVo>();
			tvo.itemFiled = new Vector.<TreeTrunkVo>();
			return tvo;
		}		
		
		private static var merchDataList:Dictionary = new Dictionary(true);
		private static function getMerchList(id:int):Vector.<MerchVo>
		{
			if(_merchDic != null && _merchDic[id] != null){
				if(merchDataList[id] == null){
					merchDataList[id] = createMerchList(_merchDic[id]);
				}
				return merchDataList[id];
			}
			else{
				_merchDic[id] = _tempMerchData;
				return getMerchList(id);
			}
		}
		/**
		 * 根据商铺编号获取商铺数据
		 * @param merchId
		 * @return 
		 */		
		public static function getMerchByNumber(number:String):MerchVo{
			for(var key:* in _merchDic) 
			{
				var merchList:Vector.<MerchVo> = getMerchList(key);
				for each (var mvo:MerchVo in merchList) 
				{
//					if(int(mvo.merchId) == int(number)){
//						return mvo;
//					}
					if(mvo.merchId.search(number) >= 0){//表示搜索到了
						return mvo;
					}
				}
			}
			return null;
		}
		
		private static function createMerchList(tList:Array):Vector.<MerchVo>
		{
			var merchList:Vector.<MerchVo> = new Vector.<MerchVo>();
			for each (var mObj:Object in tList) 
			{
				var mvo:MerchVo = new MerchVo();
				mvo.id = mObj.id;
				mvo.name = mObj.name;
				mvo.avatarIcon = mObj.avatarIcon;
				mvo.merchId = mObj.merchId;
				mvo.floor = mObj.floor;
				mvo.level = mObj.level;
				mvo.licenseIcon = mObj.licenseIcon;
				mvo.classid = mObj.classid;
				merchList.push(mvo);
			}
			return merchList;
		}
		public static function getLargeList(id:int,typeID:String):Object{
			switch(typeID){
				case DATA_NORMAL:
					return getNormalLargeList(id);
					break;
				case DATA_PERSON:
					return getPersonLargeList();
					break;
			}
			return null;
		}
		private static var personLargeList:Vector.<PersonVo>;
		private static function getPersonLargeList():Vector.<PersonVo>
		{
			if(personLargeList == null){
				personLargeList = new Vector.<PersonVo>();
				for each (var pvo:PersonVo in personList) 
				{
					if(pvo.large != null)
					personLargeList.push(pvo);
				}
			}
			return personLargeList;
		}
		/**
		 * @return 
		 */		
		public static function getNormalList(id:int):Vector.<NormalItemVo>{
			if(_normalDic != null && _normalDic[id] != null){
				if(normalDataList[id] == null){
					normalDataList[id] = createNormalList(_normalDic[id]);
				}
				return normalDataList[id];
			}
			if(normalList == null){
				normalList = createNormalList(tempNormalData);
			}
			return normalList;
		}
		private static var normalDataList:Dictionary = new Dictionary(true);
		//key:id value:Vector.<NormalItemVo>
		
		private static var traceList:Vector.<TraceVo>;
		private static function getTraceList():Vector.<TraceVo>
		{
			if(traceList == null){
				createTraceList();
			}
			return traceList;
		}
		
		private static function createTraceList():void
		{
			traceList = new Vector.<TraceVo>();
			for each (var tObj:Object in tempTraceData) 
			{
				var tvo:TraceVo = new TraceVo();
				tvo.date = tObj.date;
				tvo.foodList = new Vector.<FoodDetailsVo>();
				traceList.push(tvo);
				for each (var fObj:Object in tObj.foodList) 
				{
					var fvo:FoodDetailsVo = new FoodDetailsVo();
					for(var key:String in fObj) 
					{
						fvo[key] = fObj[key];
					}
					tvo.foodList.push(fvo);
				}
			}
		}
		
		private static var foodList:Vector.<FoodVo>;
//		private static var foodDataList:Dictionary = new Dictionary(true);
		private static function getFoodList(/*id:int*/):Vector.<FoodVo>
		{
			if(foodList == null){
				foodList = createFoodList(_tempFoodData);
			}
			return foodList;
		}
		
		
//		public static function getFoodList():Vector.<FoodVo>{
//			if(foodList == null){
//				createFoodList();
//			}
//			return foodList;
//		}
		
		private static function createFoodList(tList:Array):Vector.<FoodVo>
		{
			var id:int = 0;
			var foodList:Vector.<FoodVo> = new Vector.<FoodVo>();
			for each (var food:Object in tList) 
			{
				var fvo:FoodVo = new FoodVo();
				if(food.id === undefined){
					fvo.id = ++id;
				}else{
					fvo.id = food.id;
				}
				fvo.icon = food.icon;
				fvo.name = food.name;
				fvo.price = food.price;
				foodList.push(fvo);
			}
			return foodList;
		}
//		private static var normalLargeList:Vector.<NormalItemVo>;
		private static var normalLargeDic:Dictionary = new Dictionary(true);
		public static function getNormalLargeList(id:int):Vector.<NormalItemVo>{
			var nList:Vector.<NormalItemVo> = getNormalList(id);
			if(normalLargeDic[nList] == null){
				normalLargeDic[nList] = createNormalLargeList(nList);
			}
			return normalLargeDic[nList];
		}
		private static function createNormalLargeList(nList:Vector.<NormalItemVo>):
			Vector.<NormalItemVo>
		{
			var normalLargeList:Vector.<NormalItemVo> = new Vector.<NormalItemVo>();
			for each (var nvo:NormalItemVo in nList) 
			{
				if(nvo.large != null)
				normalLargeList.push(nvo);
			}
			return normalLargeList
		}
		
		private static function createNormalList(normalData:Object):Vector.<NormalItemVo>
		{
			var normalList:Vector.<NormalItemVo> = new Vector.<NormalItemVo>();
			for each (var normal:Object in normalData) 
			{
				var nvo:NormalItemVo = new NormalItemVo();
				nvo.icon = normal.icon;
				nvo.title = normal.title;
				nvo.des = normal.des;
				nvo.content = normal.content;
				nvo.contentXml = normal.contentXml;
				nvo.large = normal.large;
				nvo.time = normal.time;
				normalList.push(nvo);
			}
			return normalList;
		}
		private static var _normalDic:Dictionary;//id数据列表
		public static function set normalDic(value:Dictionary):void
		{
			_normalDic = value;
		}
	}
}