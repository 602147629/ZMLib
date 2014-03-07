package com.screen
{
	import com.component.AutoScrollContainer;
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.net.PhpNet;
	import com.rendener.CheckRendener;
	import com.utils.CacheUtils;
	import com.utils.PowerLoader;
	import com.view.CoreMember;
	import com.vo.CheckVo;
	import com.vo.FoodStandVo;
	
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import feathers.controls.Screen;
	
	import org.excel.Excel;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class FoodStandScreen extends Screen implements IMember
	{
		private var checkList:AutoScrollContainer;//食物列表
		private var titleLabel:TextField;
		private var timeLabel:TextField;//日期
		private var resultLabel:TextField;//结果
		public static var leftPadding:Number = 370 * Vision.widthScale;
		public static var topPadding:Number = 128 * Vision.heightScale;
		private var container:Sprite;
		private var headerBack:Quad;
		
		override protected function initialize():void
		{
			createBack();
			
			container = new Sprite();
			addChild(container);
			createTitle();
			createLine();
			createList();
			createPerson();
			showData();
			container.y = (Vision.screenHeight - container.height) / 2;
			//			StarlingLoader.loadFile("assets/stand/tempImage04.jpg",loadImage);
		}
		
		private function createLine():void
		{
			var line:Quad = new Quad(Vision.senceWidth,Math.ceil(2 * Vision.heightScale),
				Vision.selectColor + 0x000F00);
			container.addChildAt(line,0);
			line.y = titleLabel.y + titleLabel.height - 10 * Vision.heightScale;
		}
		
		private function showData():void
		{
			var foodStandVo:FoodStandVo = FarmDataBase.foodStandVo;
			if(foodStandVo != null){
				if(foodStandVo.checKList == null){
					CacheUtils.loadByteAndSave(foodStandVo.xlsPath,PhpNet.WWW_ROOT,onExcelComplete);
				}else{
					showCheck(foodStandVo);
				}
			}else{
				loadStandVo();
			}
		}
		
		private function createTitle():void
		{
			titleLabel = createText(Vision.senceWidth,120 * Vision.heightScale,
				50 * Vision.normalScale,0xFFFFFF,"食品安全检测");
			titleLabel.x = (Vision.senceWidth - titleLabel.width) / 2;
			titleLabel.y = 10 * Vision.heightScale;
			//			titleLabel.bold = true;
			
			var mesureLabel:TextField = createText(200 * Vision.widthScale,30 * Vision.heightScale,
				25 * Vision.normalScale,0xFFFFFF,"单位：公斤");
			mesureLabel.hAlign = HAlign.LEFT;
			mesureLabel.x = leftPadding;
			mesureLabel.y = topPadding;
			
			timeLabel = createText(200 * Vision.widthScale,35 * Vision.heightScale,
				25 * Vision.normalScale,0xFFFFFF);
			timeLabel.hAlign = HAlign.RIGHT;
			timeLabel.x = Vision.senceWidth - leftPadding - timeLabel.width;
			timeLabel.y = topPadding;
			
			resultLabel = createText(1000 * Vision.widthScale,90 * Vision.heightScale,
				22 * Vision.normalScale,0xFFFFFF);
			resultLabel.hAlign = HAlign.LEFT;
			resultLabel.x = (90 + 35) * Vision.widthScale;
			resultLabel.leading = 5 * Vision.heightScale;
			
			createHeader();
		}
		
		private function createHeader():void
		{
			var tHeight:Number = 55 * Vision.heightScale;
			var fontSize:Number = 25 * Vision.normalScale;
			var baseY:Number =  170 * Vision.heightScale;
			
			headerBack = new Quad(Vision.senceWidth,tHeight,Vision.selectColor + 0x000F00);
			container.addChild(headerBack);
			headerBack.y = baseY;
			
			var idLabel:TextField = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"序号");
			idLabel.x = 150 * Vision.widthScale - idLabel.width / 2;
			idLabel.y = baseY;
			
			var merchIdLabel:TextField = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"摊位");
			merchIdLabel.x = 240 * Vision.widthScale - merchIdLabel.width / 2;
			merchIdLabel.y = baseY;
			
			var merchNameLabel:TextField = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"姓名");
			merchNameLabel.x = 370 * Vision.widthScale - merchNameLabel.width / 2;
			merchNameLabel.y = baseY;
			
			var foodNameLabel:TextField = createText(200 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"商品名称");
			foodNameLabel.x = 520 * Vision.widthScale - foodNameLabel.width / 2;
			foodNameLabel.y = baseY;
			
			var originLabel:TextField = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"产地");
			originLabel.x = 670 * Vision.widthScale - originLabel.width / 2;
			originLabel.y = baseY;
			
			var countLabel:TextField = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"数量");
			countLabel.x = 800 * Vision.widthScale - countLabel.width / 2;
			countLabel.y = baseY;
			
			var resultLabel:TextField = createText(200 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF,"检测情况");
			resultLabel.x = 930 * Vision.widthScale - resultLabel.width / 2;
			resultLabel.y = baseY;
		}
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x5c5c5c,
									label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.CENTER;
			labelText.hAlign = HAlign.CENTER;
			labelText.autoScale = false;
			container.addChild(labelText);
			return labelText;
		}
		
//		private var goodCount:int = 20;
//		private var unGoodCount:String = "-";
//		private var result:String = "";
//		private var personName:String = "孙薛琴，刘培娥";
//		private var time:String = "2014年1月8日";
		private static var maxCount:int = 20;//最多显示20个
		private function createList():void
		{
			var gap:Number = 0;
			var h:Number = (Vision.CHECK_ITEM_HEIGHT + gap) * maxCount * Vision.heightScale;
			checkList = new AutoScrollContainer(Vision.senceWidth,h);
			checkList.itemRendererType = CheckRendener;
			checkList.maxRows = maxCount;
			checkList.scrollSpeed = 2 * Vision.heightScale;
			checkList.vGap = gap * Vision.heightScale;
			checkList.autoFill = true;
			//纵向滑动
			container.addChild(checkList);
			//			checkList.height = (Vision.FOOD_ITEM_HEIGHT + gap) * 7 * Vision.heightScale;
			checkList.y = headerBack.y + headerBack.height;//210 * Vision.heightScale;
			
			resultLabel.y = checkList.y + maxCount * Vision.CHECK_ITEM_HEIGHT * Vision.heightScale + 
				20 * Vision.heightScale;
		}
		
		private function loadStandVo():void
		{
			if(FarmDataBase.showDetection){
				showCheck(FarmDataBase.foodStandVo);
			}else{
				PowerLoader.loadUrl(new URLRequest("xml/check.xml"),URLLoaderDataFormat.TEXT,loadStandXml);
//				CacheUtils.loadByteAndSave("assets/excel/农残检测.xlsx",PhpNet.WWW_ROOT,onExcelComplete);
			}
//			PowerLoader.loadUrl(new URLRequest("xml/check.xml"),URLLoaderDataFormat.TEXT,loadStandXml);
		}
		
		private function onExcelComplete(by:ByteArray):void
		{
			var svo:FoodStandVo = FarmDataBase.foodStandVo;
			if(svo == null){
				svo = FarmDataBase.foodStandVo = new FoodStandVo();
			}
			var ex:Excel = new Excel(by);
			var eList:Array = ex.getSheetArray();
			//从第二行开始添加 第一行是标题
			var cList:Vector.<CheckVo> = new Vector.<CheckVo>();
			for (var i:int = 1; i < eList.length; i++) 
			{
				var prop:Array = eList[i];
				var cvo:CheckVo = new CheckVo();
				cvo.merchId = prop[0];
				cvo.merchName = prop[1];
				cvo.foodName = prop[2]
				cvo.origin = prop[3];
				cvo.count = prop[4];
				cvo.result = prop[5];
				cList.push(cvo);
			}
			svo.checKList = cList;
			showCheck(svo);
		}
		
		private function loadStandXml(str:String):void
		{
			var xml:XML = XML(str);
			var svo:FoodStandVo = new FoodStandVo();
			svo.personName = xml.data[0].@personName;
			var date:Date = new Date();
			date.time = Number(xml.data[0].@time) * 1000;
			svo.time = date;
			svo.result = xml.data[0].@result;
			var cList:Vector.<CheckVo> = new Vector.<CheckVo>();
			svo.checKList = cList;
			for each (var propXml:XML in xml.props.prop) 
			{
				var cvo:CheckVo = new CheckVo();
				//								cvo.id = propXml.@id;
				cvo.merchId = propXml.@merchId;
				cvo.merchName = propXml.@merchName;
				cvo.foodName = propXml.@foodName;
				cvo.origin = propXml.@origin;
				cvo.count = propXml.@count;
				cvo.result = (propXml.@result == 1) ? "合格" : "不合格";
				cList.push(cvo);
			}
			FarmDataBase.foodStandVo = svo;
			showCheck(svo);
		}
		
		private function showCheck(foodStandVo:FoodStandVo):void{
//			foodStandVo.checKList.push(foodStandVo.checKList[0],foodStandVo.checKList[1]/*,foodStandVo.checKList[2]*/);
			checkList.dataProvider = foodStandVo.checKList;
			
			var goodCount:int;
			var cList:Vector.<CheckVo> = foodStandVo.checKList;
			if(cList == null)return;//
			for each (var cvo:CheckVo in cList) 
			{
				if(cvo.result.indexOf("不合格") < 0){
					goodCount ++;
				}
			}
			var unGoodCount:int = cList.length - goodCount;
			resultLabel.text = "今日抽查:   " + cList.length + "   户    不超标:  " + goodCount + "   户    超标:   " + 
				(unGoodCount == 0 ? "-" : unGoodCount) + "   户\n" + "处理结果:   " + foodStandVo.result;
			var date:Date = foodStandVo.time;
			timeLabel.text = date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日";
			personLabel.text = "检测人:" + foodStandVo.personName;
		}
		
		private var personLabel:TextField;
		private function createPerson():void
		{
			personLabel = createText(500 * Vision.widthScale,30 * Vision.heightScale,
				25 * Vision.normalScale,0xFFFFFF);
			personLabel.hAlign = HAlign.RIGHT;
			personLabel.x = Vision.senceWidth - personLabel.width - (90 + 30) * Vision.widthScale;
			personLabel.y = 1130 * Vision.heightScale;
		}
		
		private var back:Quad;
		private function createBack():void
		{
			back = new Quad(Vision.senceWidth,
				Vision.screenHeight + (Vision.MENU_ITEM_HEIGHT - 2) * Vision.heightScale,Vision.selectColor);
			addChild(back);
		}
		
		private function loadImage(t:Texture):void
		{
			var image:Image = new Image(t);
			addChild(image);
			image.scaleX = Vision.widthScale;
			image.scaleY = Vision.heightScale;
		}
		public function setRemoteParams(id:int, typeID:String):void
		{
		}
		
		public function set memberData(obj:Object):void
		{
		}
	}
}