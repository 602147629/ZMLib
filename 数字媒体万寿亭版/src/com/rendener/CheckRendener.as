package com.rendener
{
	import com.manager.Vision;
	import com.screen.FoodStandScreen;
	import com.vo.CheckVo;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class CheckRendener extends BasicItemRenderer
	{
		private var idLabel:TextField;//序号
		private var merchIdLabel:TextField;//商铺id号
		private var merchNameLabel:TextField;//商铺名称
		private var foodNameLabel:TextField;//商品名称
		private var originLabel:TextField;//产地名称
		private var countLabel:TextField;//数量
		private var resultLabel:TextField;//结果
		
		override protected function initialize():void
		{
//			createLine();
			createBack();
			
			var tHeight:Number = 35 * Vision.heightScale;
			var fontSize:Number = 25 * Vision.normalScale;
			idLabel = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			idLabel.x = 150 * Vision.widthScale - idLabel.width / 2;
			idLabel.y = (height - idLabel.height) / 2;
			
			merchIdLabel = createText(100 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			merchIdLabel.x = 240 * Vision.widthScale - merchIdLabel.width / 2;
			merchIdLabel.y = (height - merchIdLabel.height) / 2;
			
			merchNameLabel = createText(150 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			merchNameLabel.x = 370 * Vision.widthScale - merchNameLabel.width / 2;
			merchNameLabel.y = (height - merchNameLabel.height) / 2;
			
			foodNameLabel = createText(150 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			foodNameLabel.x = 520 * Vision.widthScale - foodNameLabel.width / 2;
			foodNameLabel.y = (height - foodNameLabel.height) / 2;
			
			originLabel = createText(150 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			originLabel.x = 670 * Vision.widthScale - originLabel.width / 2;
			originLabel.y = (height - originLabel.height) / 2;
			
			countLabel = createText(150 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			countLabel.x = 800 * Vision.widthScale - countLabel.width / 2;
			countLabel.y = (height - countLabel.height) / 2;
			
			resultLabel = createText(250 * Vision.widthScale,tHeight,
				fontSize,0xFFFFFF);
			resultLabel.x = 930 * Vision.widthScale - resultLabel.width / 2;
			resultLabel.y = (height - resultLabel.height) / 2;
		}
		
		private var back:Quad;
		private function createBack():void
		{
			back = new Quad(Vision.senceWidth,height,Vision.selectColor);
			addChild(back);
		}
		//创建下划线
		private function createLine():void
		{
			var w:Number = Vision.senceWidth - FoodStandScreen.leftPadding * 2;
			var line:Quad = new Quad(w,Math.ceil(Vision.heightScale),0xFFFFFF);
			addChild(line);
			line.alpha = .5;
			line.x = (Vision.senceWidth - w) / 2;
			
//			line = new Quad(w,Math.ceil(Vision.heightScale),0xFFFFFF);
//			addChild(line);
//			line.alpha = .5;
//			line.x = (Vision.senceWidth - w) / 2;
//			line.y = height - line.height;
		}
		
		override public function set index(value:int):void
		{
			super.index = value;
		}
		
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x5c5c5c,
									label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.CENTER;
			labelText.hAlign = HAlign.CENTER;
			labelText.autoScale = false;
			addChild(labelText);
			return labelText;
		}
		
		protected override function commitData():void{
			var num:int = (_place + 1);
			idLabel.text = num < 10 ? ("0" + num) : ("" + num);
			merchIdLabel.text = (_data as CheckVo).merchId;
			merchNameLabel.text = (_data as CheckVo).merchName;
			foodNameLabel.text = (_data as CheckVo).foodName;
			originLabel.text = (_data as CheckVo).origin;
			countLabel.text = (_data as CheckVo).count + "";
			resultLabel.text = (_data as CheckVo).result;
			
			back.color = Vision.selectColor + _index % 2 * 0x000F00;
//			back.color = (_index) % 2 == 0 ? Vision.selectColor : (Vision.selectColor + 0x000F00);
		}
		
		public override function get height():Number{
			return Vision.CHECK_ITEM_HEIGHT * Vision.heightScale;// + 20 *Math.random();
		}
		
		
	}
}