package 
{
	import com.engine.AwayEngine;
	import com.manager.Game;
	import com.manager.Vision;
	import com.model.FarmRemoteData;
	import com.text.ChineseInputWindow;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.utils.setTimeout;
	
	import feathers.events.ItemEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class GameMain extends Sprite
	{
		
		public function GameMain()
		{
//			var theme:MetalWorksMobileTheme = new MetalWorksMobileTheme();
//			createBackGround();
			//初始化层次
			FarmRemoteData.start(onInfoComplete);
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			Vision.createGpu(this);
//			var sb:SliderBar = new SliderBar(242/* * Vision.widthScale*/,50/* * Vision.heightScale*/);
//			addChild(sb);
//			sb.icon = "assets/menu/icon01.png";
////			sb.selectIcon = "assets/menu/icon10.png";
//			sb.color = 0x50b5e1;
//			sb.y = 200;
//			sb.fontSize = 15/* * Vision.normalScale*/;
//			sb.label = "向左滑动提交";
			
//			Vision.shield();
			
		}
		
		private function onInfoComplete():void
		{
			Game.ready();
//			setTimeout(createBackGround,500);
//			setTimeout(createBackGround,500);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		private function clickItem(e:ItemEvent):void
		{
			trace(e.selectedItem);
		}
		
		private function createBackGround():void
		{
//			var h:Number = 50 * Vision.heightScale;
//			var w:Number = 898 * Vision.widthScale;
//			var ci:ChineseInputWindow = new ChineseInputWindow(w,h);
//			addChild(ci);
//			ci.gap = 50 * Vision.widthScale;
//			ci.fontSize = 20 * Vision.normalScale;
//			ci.dataProvider = [
//				{label:"哈"},{label:"哈哈"},{label:"哈哈哈"},{label:"哈哈哈哈"},
//				{label:"哈哈哈哈"},{label:"哈哈哈哈吼吼"},{label:"哈哈哈哈吼吼"},
//				{label:"哈哈哈哈吼吼嘿嘿"},{label:"哈哈哈哈吼吼嘿嘿嘿嘿"},
//				{label:"哈哈哈哈吼吼嘿嘿"},{label:"哈哈哈哈吼吼吼吼嘿嘿"},
//				{label:"哈哈哈哈哈哈哈哈吼吼嘿嘿"}];
//			ci.x = 50;
//			ci.y = 100;
			
//			var quad:Quad = new Quad(Vision.senceWidth,Vision.senceHeight,0xFFFFFF);
//			quad.touchable = false;
//			addChild(quad);
			
			//			var tabs:TabBar = new TabBar();
			//			tabs.tabFactory = function():Button
			//			{
			//				var tab:Button = new Button();
			//				tab.defaultSkin = new Scale9Image( upTextures );
			//				tab.defaultSelectedSkin = new Scale9Image( selectedTextures );
			//				tab.downSkin = new Scale9Image( downTextures );
			//				tab.defaultLabelProperties.textFormat = format;
			//				return tab;
			//			}
			//			tabs.dataProvider = new ListCollection(
			//				[
			//					{ label: "一" },
			//					{ label: "二" },
			//					{ label: "三" }
			//				]);
			//			this.addChild( tabs );
			//			var tm:TreeMenuView = new TreeMenuView();
			//			tm.dataProvider = FarmDataBase.tempTreeData;
			//			addChild(tm);
			//			tm.scaleX = tm.scaleY = .8;
			
//			var tab:TabBarView = new TabBarView();
			//			addChild(tab);
			//			tab.lineColor = tab.selectColor = 0x666666;
			//			tab.dataProvider = [{label:"周"},{label:"月"},{label:"年"}];
			//			tab.defaultColor = 0xBBFFFF;
			//			tab.itemWidth = 75 * Vision.widthScale;
			//			tab.itemHeight = 45 * Vision.heightScale;
			//			tab.fontSize = 25 * Vision.heightScale;
			//			tab.x = tab.y = 100;
			//			tab.addEventListener(ItemEvent.ITEM_CLICK,clickItem);
		}
	}
}