package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.FarmRemoteData;
	import com.view.CoreMember;
	
	import feathers.controls.Screen;
	
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class BlankScreen extends Screen implements IMember
	{
		private var titleLabel:TextField;
		override protected function initialize():void
		{
			createTitle();
		}
		
		private function createTitle():void
		{
			titleLabel = createText(Vision.senceWidth,150 * Vision.heightScale,
				110 * Vision.normalScale,Vision.selectColor);
			titleLabel.x = (Vision.senceWidth - titleLabel.width) / 2;
			titleLabel.y = (Vision.screenHeight - titleLabel.height) / 2;
			addChild(titleLabel);
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
		
		public function setRemoteParams(id:int, typeID:String):void
		{
			if(FarmRemoteData.isConnect){
				titleLabel.text = "网页链接中...";
			}else{
				titleLabel.text = "网络已断开!!!";
			}
		}
		
		public function set memberData(obj:Object):void
		{
		}
	}
}