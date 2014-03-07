package com.screen
{
	import com.component.NormalButton;
	import com.core.IMember;
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.model.FarmRemoteData;
	import com.model.MerchModel;
	import com.net.NetConfig;
	import com.net.PhpNet;
	import com.rendener.MerchRendener;
	import com.view.LicenseView;
	import com.view.Merch3DView;
	import com.vo.MerchVo;
	import com.vo.MeshInfoVo;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MerchScreen extends Screen implements IMember
	{
		private var merchList:List;
		public static const MERCH_ITEM_WIDTH:Number = 995;
		public static const MERCH_TOP_LINE:Number = 848;
		
		//		private var merchWindow:MerchDetailWindow;
		override protected function initialize():void
		{
			createHeader();
			createList();
			createBack();
		}
		
		private function createBack():void
		{
			var baseY:Number = headBack.y + headBack.height;
			var listHeight:Number = Vision.screenHeight - baseY;// - 10 * Vision.heightScale;
			var back:Quad = new Quad(Vision.senceWidth,listHeight/*merchList.height + headBack.height + newsGap*/);
			back.y = merchList.y;
			//			back.y = MERCH_TOP_LINE * Vision.heightScale;
			addChildAt(back,0);
		}
		
		private static var newsGap:Number = 0;//-1;
		private static var newsCount:int = -1;
		private function createList():void
		{
			var baseY:Number = headBack.y + headBack.height;
			if(newsCount == -1){//开始计算gap
				var listHeight:Number = Vision.screenHeight - baseY - 10 * Vision.heightScale;
				newsCount = listHeight / (Vision.MERCH_ITEM_HEIGHT * Vision.heightScale);
//				newsGap = (listHeight - newsCount * Vision.MERCH_ITEM_HEIGHT * Vision.heightScale) / (newsCount - 1);
			}
			merchList = new List();
			merchList.itemRendererType = MerchRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 0;//newsGap / Vision.heightScale;//5;
			layout.gap = gap * Vision.heightScale;
			merchList.layout = layout;
			merchList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			merchList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			//纵向滑动
			addChild(merchList);
			
			merchList.width = Vision.senceWidth;
			merchList.height = (Vision.MERCH_ITEM_HEIGHT + gap) * newsCount * Vision.heightScale;
			
			merchList.y = baseY;// + gap * Vision.heightScale;
			merchList.addEventListener(Event.CHANGE,onChange);
			merchList.addEventListener(ItemEvent.ITEM_CLICK,onCheckTouch);
			merchList.selectedIndex = 0;
		}
		
		private function resetButton():void{
			if(checkButton != null){
				checkButton.isSelected = false;
			}
		}
		
		private var checkButton:NormalButton;//检查按钮

		private var headBack:Quad;
		private function onCheckTouch(e:ItemEvent):void
		{
			resetButton();
			checkButton = e.item as NormalButton;
			if(checkButton != null){
				checkButton.isSelected = true;
				addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			}
			var merchVo:MerchVo = e.selectedItem as MerchVo;
			if(merchVo != null){
				var list:Array = merchVo.licenseIcon.split(NetConfig.ADDRESS_KEY);
				for (var i:int = list.length - 1; i >= 0 ; i--) 
				{
					if(list[i] != ""){
						list[i] = {icon:PhpNet.WWW_ROOT + FarmRemoteData.IMAGE_FILE + list[i]};
					}else{
						list.splice(i,1);//无效数据切除
					}
				}
				LicenseView.getInstance().show();
				LicenseView.getInstance().dataProvider = list;
				trace("查看证件:" + merchVo.merchId);
				Merch3DView.getInstance().hide();
			}
		}
		
		private function onRemove(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			resetButton();
			LicenseView.getInstance().hide();
//			Merch3DView.getInstance().show();
		}	
		private function onChange(e:Event):void
		{
			if(merchList.selectedItem is MerchVo){
				var mvo:MerchVo = merchList.selectedItem as MerchVo;
				//				showDetail(mvo);
				var mList:Vector.<MeshInfoVo> = MerchModel.searchMeshInfoByMerchId(mvo.merchId);
				if(mList == null){
					trace("目标标记商铺不存在或还未加载merchId:" + mvo.merchId);
					return;
				}
				Merch3DView.getInstance().show();
				Merch3DView.getInstance().showMesh(mList);
				resetButton();
				LicenseView.getInstance().hide();
			}
		}
		
		//		private function showDetail(mvo:MerchVo):void
		//		{
		//			if(merchWindow == null){
		//				merchWindow = new MerchDetailWindow();
		//			}/*else{
		//				merchWindow.visible = true;
		//			}*/
		//			addChild(merchWindow);
		//			merchWindow.show(mvo);
		//			
		//			merchWindow.x = (Vision.senceWidth - merchWindow.width) / 2;
		//			merchWindow.y = merchList.y + merchList.height / 2 - merchWindow.height / 2;
		//			
		//			merchWindow.addEventListener(ItemEvent.ITEM_CLICK,clickItem);
		//			
		//			addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		//		}
		
		//			
		//		
		//		private function clickItem(e:ItemEvent):void
		//		{
		//			hideWindow();
		//			trace("评价" + e.selectedIndex);
		//		}
		
		//		private function hideWindow():void
		//		{
		//			removeChild(merchWindow);
		//		}
		//		
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
		/**
		 * 创建顶部页眉文字
		 */		
		private function createHeader():void
		{
			headBack = new Quad(Vision.senceWidth,
				38 * Vision.heightScale,0xBEBEBE);
			addChild(headBack);
			headBack.x = (Vision.senceWidth - headBack.width) / 2;
			headBack.y = MERCH_TOP_LINE * Vision.heightScale;
			
			var textHeight:int = 30;
			var baseY:Number = headBack.y + headBack.height / 2 - textHeight * Vision.heightScale / 2;
			
			var nameLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"商户");
			addChild(nameLabel);
			nameLabel.x = 125 * Vision.widthScale - nameLabel.width / 2;
			nameLabel.y = baseY;
			
			var merchIdLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"铺位号");
			addChild(merchIdLabel);
			merchIdLabel.x = 290 * Vision.widthScale - merchIdLabel.width / 2;
			merchIdLabel.y = baseY;
			
			var floorLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"楼层");
			addChild(floorLabel);
			floorLabel.x = 385 * Vision.widthScale - floorLabel.width / 2;
			floorLabel.y = baseY;
			
			var levelLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"信用评级");
			addChild(levelLabel);
			levelLabel.x = 608 * Vision.widthScale - levelLabel.width / 2;
			levelLabel.y = baseY;
			
			var licenseLabel:TextField = createText(200 * Vision.widthScale,textHeight * Vision.heightScale,
				20 * Vision.heightScale,0xFFFFFF,"对该商户进行评价");
			addChild(licenseLabel);
			licenseLabel.x = 890 * Vision.widthScale - licenseLabel.width / 2;
			licenseLabel.y = baseY;
		}
		
		public function setRemoteParams(id:int,typeID:String):void
		{
			var mList:Vector.<MerchVo> = 
				FarmDataBase.getDataList(id,typeID) as Vector.<MerchVo>;
			if(mList != null){
				merchList.selectedIndex = -1;
				if(merchList.dataProvider != null){
					if(merchList.dataProvider.data != mList){
						merchList.dataProvider = new ListCollection(mList);
						//不一样 替换数据
					}
				}else{
					merchList.dataProvider = new ListCollection(mList);
				}
				//				merchList.selectedIndex = 0;
			}
			Merch3DView.getInstance().show();
		}
		private static var timerId:uint;
		/**
		 * 用户联动触发选中的数据
		 * @param obj
		 */		
		public function set memberData(obj:Object):void{
			if(obj is MerchVo){//具体的商铺数据
				merchList.removeEventListener(Event.CHANGE,onChange);
				clearTimeout(timerId);
				timerId = setTimeout(setData,500,obj);
			}
		}
		
		private function setData(obj:Object):void{
			merchList.selectedItem = obj;
			var selectedIndex:int = merchList.selectedIndex;
			if(merchList.maxVerticalScrollPosition > 0){
				var itemHeight:Number = Vision.MERCH_ITEM_HEIGHT * Vision.heightScale;
				var pos:Number = (selectedIndex + (merchList.layout as VerticalLayout).gap) * itemHeight;//Vision.menuWidth;
				if(pos > merchList.maxVerticalScrollPosition){
					pos = merchList.maxVerticalScrollPosition;
				}
				TweenLite.to(merchList,.3,{verticalScrollPosition:pos});
			}else{
				merchList.verticalScrollPosition = 0;//回到原位
			}
			merchList.addEventListener(Event.CHANGE,onChange);
		}
	}
}