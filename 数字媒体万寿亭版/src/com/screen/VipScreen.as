package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.text.RichTextArea;
	import com.text.RichTextField;
	import com.vo.VipVo;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class VipScreen extends Screen implements IMember
	{
		private var container:ScrollContainer;//滚动容器
		private var titleLabel:TextField;
		private var detailsLabel:RichTextField;//描述文本框
		override protected function initialize():void
		{
			container = new ScrollContainer();
			container.width = Vision.senceWidth;
			container.height = 918 * Vision.heightScale;//300 * Vision.heightScale;//
			container.y = 170 * Vision.heightScale;
			addChild(container);
			container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			createTitle();
			createDetails();
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function createTitle():void
		{
			titleLabel = new TextField(DetailsScreen.DETAILS_WIDTH * Vision.widthScale,
				70 * Vision.heightScale,"");
			titleLabel.hAlign = HAlign.LEFT;
			titleLabel.vAlign = VAlign.TOP;
			titleLabel.x = (Vision.senceWidth - titleLabel.width) / 2;
			titleLabel.y = 30 * Vision.heightScale;
			titleLabel.bold = true;
			titleLabel.fontSize = 36 * Vision.heightScale;
			addChild(titleLabel);
		}
		
		private function createDetails():void
		{
			detailsLabel = new RichTextField(DetailsScreen.DETAILS_WIDTH * Vision.widthScale,
				50 * Vision.heightScale);
			detailsLabel.x = (Vision.senceWidth - detailsLabel.width) / 2;
//			detailsLabel.y = 800 * Vision.heightScale - 170 * Vision.heightScale;
			detailsLabel.fontSize = 25;
			detailsLabel.color = 0x5d5d5d;
			detailsLabel.richScale = Vision.widthScale;
			container.addChild(detailsLabel);
		}
		
		private function removeFromStage(e:starling.events.Event):void
		{
			addEventListener(starling.events.Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE,addToStage);
			//注:让滚动容器恢复起始位置
			container.verticalScrollPosition = 0;//恢复到原来位置
		}
		
		public function setRemoteParams(id:int, typeID:String):void
		{
			var vvo:VipVo = FarmDataBase.getVipVo(id);
			if(vvo != null){
				titleLabel.text = vvo.title;
//				var _richTextArea:RichTextArea = new RichTextArea(400,300);
//				_richTextArea.textField.wordWrap = true;
//				_richTextArea.textField.multiline = true;
//				_richTextArea.textField.autoSize = TextFieldAutoSize.LEFT;
//				trace("配置:" + vvo.contentXml);
//				trace("内容:" + vvo.content);
//				_richTextArea.configXML = vvo.contentXml;
//				_richTextArea.richText = vvo.content;
//				_richTextArea.addEventListener(flash.events.Event.COMPLETE,onComplete);
//				Vision.stage.addChild(_richTextArea);
				detailsLabel.configXML = vvo.contentXml;
				detailsLabel.text = vvo.content;
			}
		}
		
		private function onComplete(e:flash.events.Event):void
		{
			var _richTextArea:RichTextArea = e.currentTarget as RichTextArea;
			_richTextArea.autoAdjust();//调整mask大小
		}
		
		public function set memberData(obj:Object):void
		{
		}
	}
}