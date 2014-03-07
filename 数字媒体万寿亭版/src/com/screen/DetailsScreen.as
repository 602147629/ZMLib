package com.screen
{
	import com.control.GamePad;
	import com.core.IMember;
	import com.event.PadEvent;
	import com.manager.Vision;
	import com.text.RichTextField;
	import com.view.TalkView;
	import com.vo.NormalItemVo;
	
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class DetailsScreen extends Screen implements IMember
	{
		public static const DETAILS_WIDTH:Number = 920;
		private var container:ScrollContainer;//滚动容器
		private var titleLabel:TextField;
		private var detailsLabel:RichTextField;//描述文本框
		private var timeLabel:TextField;//日期
//		private var image:Image;//显示图片
		override protected function initialize():void
		{
			var baseY:Number = 160 * Vision.heightScale;
			var listHeight:Number = Vision.screenHeight - baseY - 10 * Vision.heightScale;
			
			container = new ScrollContainer();
			container.width = Vision.senceWidth;
			container.height = listHeight;//918 * Vision.heightScale;//300 * Vision.heightScale;//
			container.y = baseY;
			addChild(container);
			container.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			container.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			createTitle();
			createDetails();
			
			open();
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function removeFromStage(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
			close();
		}
		
		private function addToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			open();
			//注:让滚动容器恢复起始位置
			container.verticalScrollPosition = 0;//恢复到原来位置
		}
		private function open():void
		{
			GamePad.addChangeDirect(onChange);
		}
		
		private function onChange(e:PadEvent):void
		{
			if(e.direct == GamePad.DIRECT_LEFT){
				dispatchEventWith("onComplete",false);
			}
		}
		
		private function close():void
		{
			GamePad.removeChangeDirect(onChange);
		}
		
		private function createTitle():void
		{
			titleLabel = new TextField(DETAILS_WIDTH * Vision.widthScale,
				70 * Vision.heightScale,"");
			titleLabel.hAlign = HAlign.LEFT;
			titleLabel.vAlign = VAlign.TOP;
			titleLabel.x = (Vision.senceWidth - titleLabel.width) / 2;
			titleLabel.y = 30 * Vision.heightScale;
			titleLabel.bold = true;
			titleLabel.color = 0x4C4C4C;
			titleLabel.fontSize = 36 * Vision.heightScale;
			/*container.*/addChild(titleLabel);
			
			timeLabel = new TextField(180 * Vision.widthScale,50 * Vision.heightScale,"");
			timeLabel.fontSize = 12 * Vision.heightScale;
			timeLabel.hAlign = HAlign.LEFT;
			timeLabel.x = titleLabel.x ;//+ DETAILS_WIDTH * Vision.widthScale - timeLabel.width;
			timeLabel.y = 100 * Vision.heightScale;
			timeLabel.color = 0xBEBEBE;
			/*container.*/addChild(timeLabel);
		}
		
		private function createDetails():void
		{
			detailsLabel = new RichTextField(DetailsScreen.DETAILS_WIDTH * Vision.widthScale,
				50 * Vision.heightScale);
			detailsLabel.x = (Vision.senceWidth - detailsLabel.width) / 2;
			//			detailsLabel.y = 800 * Vision.heightScale - 170 * Vision.heightScale;
			detailsLabel.fontSize = 18;
			detailsLabel.color = 0x878787;//0x5d5d5d;
			detailsLabel.richScale = Vision.widthScale;
			container.addChild(detailsLabel);
		}
//		
//		override protected function draw():void
//		{
//			
//		}
		
		public function setRemoteParams(id:int,typeID:String):void
		{
		}
		
		public function set memberData(obj:Object):void{
			if(obj is NormalItemVo){
				var nvo:NormalItemVo = obj as NormalItemVo;
				titleLabel.text = nvo.title;
				//				detailsLabel.autoScale = true;
				detailsLabel.configXML = nvo.contentXml;
				detailsLabel.text = nvo.content;
				var date:Date = (obj as NormalItemVo).time;
				if(date != null){
					timeLabel.text = date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日";
				}
//				detailsLabel.addEventListener(Event.COMPLETE,onTextComplete);
//				if(image != null)image.texture = Vision.TEXTURE_EMPTY;
//				StarlingLoader.loadFile(nvo.icon,imageLoad);
			}
		}
		
		private function onTextComplete(e:Event):void
		{
			var tv:TalkView = TalkView.getInstance();
			tv.show();
			var c:Sprite = tv.container;
			container.addChild(c);
			c.y = detailsLabel.y + detailsLabel.height;
		}
		
//		private function imageLoad(t:Texture):void
//		{
//			if(image == null){
//				image = new Image(t);
//				container.addChildAt(image,0);
//				image.y = 170 * Vision.heightScale - 170 * Vision.heightScale;
//			}else{
//				image.texture = t;
//			}
//			image.width = 900 * Vision.widthScale;
//			image.height = 560 * Vision.heightScale;
//			image.x = (Vision.senceWidth - image.width) / 2;
//		}
	}
}