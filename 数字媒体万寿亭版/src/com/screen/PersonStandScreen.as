package com.screen
{
	import com.component.AutoScrollContainer;
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.rendener.ManagerRender;
	import com.view.CoreMember;
	import com.vo.PersonVo;
	
	import feathers.controls.Screen;
	
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PersonStandScreen extends Screen implements IMember
	{
		private var titleLabel:TextField;
		private var personList:AutoScrollContainer;//管理人员列表
		override protected function initialize():void
		{
			createBack();
//			createHeader();
//			var listH:Number = Vision.senceHeight - Vision.VIDEO_HEIGHT * Vision.heightScale - Vision.MENU_HEIGHT * Vision.heightScale;
//			back = new Quad(Vision.senceWidth,listH,0xFFFFFF);
//			addChild(back);
			createTitle();
			createList();
		}
		
//		private var back:Quad;
		private function createBack():void
		{
//			var listH:Number = Vision.senceHeight - Vision.VIDEO_HEIGHT * Vision.heightScale - Vision.MENU_HEIGHT * Vision.heightScale;
			back = new Quad(Vision.senceWidth,
				Vision.screenHeight + (Vision.MENU_ITEM_HEIGHT - 2) * Vision.heightScale,Vision.selectColor);
			addChild(back);
		}
		
		private function createTitle():void
		{
			titleLabel = createText(Vision.senceWidth,120 * Vision.heightScale,
				50 * Vision.normalScale,0xFFFFFF,"市场工作人员及职责");
			titleLabel.x = (Vision.senceWidth - titleLabel.width) / 2;
			titleLabel.y = 10 * Vision.heightScale;
			addChild(titleLabel);
		}
		//		private var headerBack:Quad;
		private var back:Quad;
		/**
		 * 创建顶部页眉文字
		 */		
//		private function createHeader():void
//		{
//			
//			headerBack = new Quad(Vision.senceWidth,
//				40 * Vision.heightScale,0xBEBEBE);
//			headerBack.x = (Vision.senceWidth - headerBack.width) / 2;
//			headerBack.y = 0 * Vision.heightScale;
//			
//			var listH:Number = Vision.senceHeight - Vision.VIDEO_HEIGHT * Vision.heightScale - Vision.MENU_HEIGHT * Vision.heightScale - headerBack.y - headerBack.height;
//			back = new Quad(Vision.senceWidth,listH,0xFFFFFF);
//			addChild(back);
//			
//			addChild(headerBack);
//			
//			var textHeight:int = 30;
//			var baseY:Number = headerBack.y + headerBack.height / 2 - textHeight * Vision.heightScale / 2;
//			
//			var nameLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
//				20 * Vision.heightScale,0xFFFFFF,"员工");
//			addChild(nameLabel);
//			nameLabel.x = 150 * Vision.widthScale - nameLabel.width / 2;
//			nameLabel.y = baseY;
//			
//			var occupLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
//				20 * Vision.heightScale,0xFFFFFF,"职务");
//			addChild(occupLabel);
//			occupLabel.x = 325 * Vision.widthScale - occupLabel.width / 2;
//			occupLabel.y = baseY;
//			
//			var idLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
//				20 * Vision.heightScale,0xFFFFFF,"编号");
//			addChild(idLabel);
//			idLabel.x = 450 * Vision.widthScale - occupLabel.width / 2;
//			idLabel.y = baseY;
//			
//			var agreeLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
//				20 * Vision.heightScale,0xFFFFFF,"满意度");
//			addChild(agreeLabel);
//			agreeLabel.x = 570 * Vision.widthScale - occupLabel.width / 2;
//			agreeLabel.y = baseY;
//			
//			var licenseLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
//				20 * Vision.heightScale,0xFFFFFF,"对该员工进行评价");
//			addChild(licenseLabel);
//			licenseLabel.x = 850 * Vision.widthScale - licenseLabel.width / 2;
//			licenseLabel.y = baseY;
//		}
		
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
		private static var leftPadding:Number;// = 20 * Vision.widthScale;
		private function createList():void
		{
			var columns:int = 5;
			leftPadding = (Vision.senceWidth - columns * Vision.MANAGE_ITEM_WIDTH * Vision.widthScale) / 2;//左边距
			var baseY:Number = 130 * Vision.heightScale;
			var count:int = (back.height - baseY) / (Vision.MANAGE_ITEM_HEIGHT * Vision.heightScale);
//			var h:Number = (Vision.PERSON_ITEM_HEIGHT + gap * (count - 1) / count) * count * Vision.heightScale;
			personList = new AutoScrollContainer(Vision.senceWidth - leftPadding * 2,
				back.height - baseY);
//			personList.autoFill = true;
			personList.itemRendererType = ManagerRender;
			personList.maxRows = count;
			personList.columns = columns;
			personList.hGap = 0;//personList.width - columns * Vision.MANAGE_ITEM_WIDTH * Vision.widthScale;
			personList.scrollSpeed = 2 * Vision.heightScale;
			var vGap:Number = (personList.height - count * Vision.MANAGE_ITEM_HEIGHT * Vision.heightScale) / (count - 1);
			personList.vGap = vGap * Vision.heightScale;
//			personList.y = headerBack.y + headerBack.height;//460 * Vision.heightScale;
			personList.touchable = false;//不能交互
			personList.x = leftPadding;
			personList.y = baseY;
			
			//纵向滑动
			addChild(personList);
			
			showPerson();
		}
		
		private function showPerson():void
		{
			var pList:Vector.<PersonVo> = FarmDataBase.getPersonList();
			if(pList != null){
				personList.dataProvider = pList;
			}
		}
		
		public function setRemoteParams(id:int,typeID:String):void
		{
			var pList:Vector.<PersonVo> = FarmDataBase.getDataList(id,typeID) as Vector.<PersonVo>;
			if(pList != null){
				personList.dataProvider = pList;
			}
		}
		public function set memberData(obj:Object):void{
			
		}
	}
}