package com.screen
{
	import com.component.ImageFadeView;
	import com.component.TreeMenuView;
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.rendener.PersonRendener;
	import com.vo.PersonVo;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PersonScreen extends Screen implements IMember
	{
		private var personList:List;//管理人员列表
//		private var imageFade:ImageFadeView;
		
		override protected function initialize():void
		{
//			imageFade = new ImageFadeView(Vision.IMAGE_FADE_WIDTH * Vision.widthScale,
//				400 * Vision.heightScale);
//			addChild(imageFade);
//			imageFade.dragEnabled = true;
//			imageFade.x = (Vision.senceWidth - imageFade.width) / 2;//横向居中
//			imageFade.y = 30 * Vision.heightScale;
			
			createHeader();
			createList();
		}
		private var headerBack:Quad;
		/**
		 * 创建顶部页眉文字
		 */		
		private function createHeader():void
		{
			headerBack = new Quad(Vision.senceWidth,
				50 * Vision.heightScale,0xBEBEBE);
			addChild(headerBack);
			headerBack.x = (Vision.senceWidth - headerBack.width) / 2;
//			headerBack.y = 10 * Vision.heightScale;
			
			var textHeight:int = 30;
			var baseY:Number = headerBack.y + headerBack.height / 2 - textHeight * Vision.heightScale / 2;
			
			var nameLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"员工");
			addChild(nameLabel);
			nameLabel.x = 150 * Vision.widthScale - nameLabel.width / 2;
			nameLabel.y = baseY;
			
			var occupLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"职务");
			addChild(occupLabel);
			occupLabel.x = 325 * Vision.widthScale - occupLabel.width / 2;
			occupLabel.y = baseY;
			
			var idLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"编号");
			addChild(idLabel);
			idLabel.x = 450 * Vision.widthScale - occupLabel.width / 2;
			idLabel.y = baseY;
			
			var agreeLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"满意度");
			addChild(agreeLabel);
			agreeLabel.x = 570 * Vision.widthScale - occupLabel.width / 2;
			agreeLabel.y = baseY;
			
			var licenseLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"对该员工进行评价");
			addChild(licenseLabel);
			licenseLabel.x = 850 * Vision.widthScale - licenseLabel.width / 2;
			licenseLabel.y = baseY;
		}
		
		public static function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x4d4d4d,
										  label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.autoScale = false;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.CENTER;
			labelText.hAlign = HAlign.CENTER;
			return labelText;
		}
		private static var newsCount:int = -1;
		//		private static var newsGap:Number = -1;
		private function createList():void
		{
			var baseY:Number = headerBack.y + headerBack.height;
			if(newsCount == -1){//开始计算gap
				var listHeight:Number = Vision.screenHeight - baseY;/* - 10 * Vision.heightScale*/;
				newsCount = listHeight / (Vision.PERSON_ITEM_HEIGHT * Vision.heightScale);
				//				newsGap = (listHeight - newsCount * Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale) / (newsCount - 1);
			}
			personList = new List();
			personList.itemRendererType = PersonRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 0;
			layout.gap = gap * Vision.heightScale;
			layout.useVirtualLayout = false;
			personList.layout = layout;
			personList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			personList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			personList.y = baseY;//460 * Vision.heightScale;
			//纵向滑动
			addChild(personList);
			
			personList.width = Vision.senceWidth;
			var count:int = newsCount;
			personList.height = (Vision.PERSON_ITEM_HEIGHT + gap * (count - 1) / count) * count * Vision.heightScale;
		}
		
		public function setRemoteParams(id:int,typeID:String):void
		{
			var pList:Vector.<PersonVo> = FarmDataBase.getDataList(id,typeID) as Vector.<PersonVo>;
			if(pList != null){
				personList.dataProvider = new ListCollection(pList);
			}
//			var lList:Object = FarmDataBase.getLargeList(id,typeID);
//			if(lList is Vector.<PersonVo>){
//				imageFade.iconFiled = "large";
//				imageFade.labelFiled = "name";
//				imageFade.dataProvider = lList;
//			}
		}
		public function set memberData(obj:Object):void{
			
		}
		
//		override protected function draw():void
//		{
//			
//		}
		
//		private function clickItem(e:ItemEvent):void
//		{
//			personList.dataProvider = new ListCollection(e.selectedItem["personList"]);
//			//"personList"暂时为人员列表
//		}
	}
}