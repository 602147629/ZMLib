package com.view
{
	import com.component.NormalButton;
	import com.manager.KeyBoardManager;
	import com.manager.Vision;
	
	import feathers.controls.TextInput;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class TalkView
	{
		private static var talkView:TalkView;
		public static function getInstance():TalkView{
			if(talkView == null)talkView = new TalkView();
			return talkView;
		}
		
		public function show():void{
			initFace();
		}
		
		private var _container:Sprite;
		public function get container():Sprite
		{
			return _container;
		}
		
		private var titleLabel:TextField;
		private var tipsLabel:TextField;
		private var talkBtn:NormalButton;
		private var leftPadding:Number = 90 * Vision.widthScale;
		//		private var inputContainer:Sprite;//输入框容器
		//		private var inputLabel:TextInput;//输入框
		private function initFace():void
		{
			if(_container == null){
				_container = new Sprite();
				
				titleLabel = createText(110 * Vision.widthScale,35 * Vision.heightScale,
					25 * Vision.normalScale,0x374047,"市民评论");
				titleLabel.x = 106 * Vision.widthScale;
				titleLabel.y = 40 * Vision.heightScale;
				
				tipsLabel = createText(300 * Vision.widthScale,25 * Vision.heightScale,
					15 * Vision.normalScale,0x374047,"(跟帖44条，100人参与)");
				tipsLabel.x = 210 * Vision.widthScale;
				tipsLabel.y = titleLabel.y + (titleLabel.height - tipsLabel.height) / 2;
				
				talkBtn = new NormalButton(118 * Vision.widthScale, 42 * Vision.heightScale);
				container.addChild(talkBtn);
				talkBtn.label = "我也说两句";
				talkBtn.fontSize = 18 * Vision.normalScale;
				talkBtn.labelColor = 0xFFFFFF;
				talkBtn.backGroundColor = 0xE05757;
				talkBtn.backEnabledColor = 0xBEBEBE;
				talkBtn.backGroundImage = "assets/other/talkBack.png";
				talkBtn.addEventListener(TouchEvent.TOUCH,onTouch);
				talkBtn.isSelected = true;//默认选中状态
				talkBtn.x = Vision.senceWidth - leftPadding - talkBtn.width;
				//				createInput();
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				if(talkBtn.isSelected){
					KeyBoardManager.showDefault(1300 * Vision.heightScale);
				}else{
					KeyBoardManager.hideDefault();
				}
				talkBtn.isSelected = !talkBtn.isSelected;
			}
		}
		
		//		private function createInput():void
		//		{
		//			inputContainer = new Sprite();
		//			_container.addChild(inputContainer);
		//			var w:Number = 860 * Vision.widthScale;
		//			var h:Number = 230 * Vision.heightScale;
		//			var back:Quad = new Quad(w,h,0x808080);
		//			back.alpha = .2;
		//			inputContainer.addChild(back);
		//			
		//			inputLabel = new TextInput();
		//			inputContainer.addChild(inputLabel);
		//			inputLabel.textEditorProperties.fontSize = 20 * Vision.normalScale;
		//			inputLabel.textEditorProperties.color = 0x374047;
		//			inputLabel.textEditorProperties.vAlign = VAlign.CENTER;
		//			inputLabel.width = w;
		//			inputLabel.height = h;
		//			
		//			inputContainer.x = (Vision.senceWidth - inputContainer.width) / 2;
		//			inputContainer.y = titleLabel.y + titleLabel.height + 10 * Vision.heightScale;
		//		}
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x5c5c5c,
									label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.hAlign = HAlign.LEFT;
			labelText.vAlign = VAlign.CENTER;
			labelText.autoScale = false;
			_container.addChild(labelText);
			return labelText;
		}
		
		
	}
}