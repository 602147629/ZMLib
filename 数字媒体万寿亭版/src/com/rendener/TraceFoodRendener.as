package com.rendener
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	import com.vo.FoodDetailsVo;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class TraceFoodRendener extends BasicItemRenderer
	{
		private var nameLabel:TextField;
		private var wieghtLabel:TextField;
		private var priceLabel:TextField;
		private var totalPriceLabel:TextField;
		private var merchIdLabel:TextField;//商户id
		private var merchNameLabel:TextField;//商户id
		private var dealDateLabel:TextField;//交易时间
		override protected function initialize():void
		{
			var tHeight:Number = 30;
			nameLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
			nameLabel.x = 120 * Vision.widthScale;
			nameLabel.y = (height - nameLabel.height) / 2;
			
			wieghtLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
			wieghtLabel.x = 260 * Vision.widthScale;
			wieghtLabel.y = (height - wieghtLabel.height) / 2;
			
			priceLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
			priceLabel.x = 370 * Vision.widthScale;
			priceLabel.y = (height - priceLabel.height) / 2;
			
			totalPriceLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
//			totalPriceLabel.hAlign = HAlign.CENTER;
			totalPriceLabel.x = 460 * Vision.widthScale;
			totalPriceLabel.y = (height - totalPriceLabel.height) / 2;
			
			merchIdLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
			merchIdLabel.x = 600 * Vision.widthScale;
			merchIdLabel.y = (height - merchIdLabel.height) / 2;
			
			merchNameLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
			merchNameLabel.x = 705 * Vision.widthScale;
			merchNameLabel.y = (height - merchNameLabel.height) / 2;
			
			dealDateLabel = createText(200 * Vision.widthScale,tHeight * Vision.heightScale,
				20 * Vision.heightScale);
			dealDateLabel.x = 820 * Vision.widthScale;
			dealDateLabel.y = (height - dealDateLabel.height) / 2;
			
			createLine();
			
			this.alpha = 0;
		}
		
		//创建下划线
		private function createLine():void
		{
			var w:Number = 925 * Vision.widthScale;
			var quad:Quad = new Quad(w,Math.ceil(2 * Vision.heightScale),0xd8d8d8);
			addChild(quad);
			quad.x = (960 * Vision.widthScale - w) / 2;
			//			quad.y = Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale - quad.height;
			//顶部
		}
		
		private function createText(w:Number,h:Number,fontSize:Number,label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = 0x5c5c5c;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.CENTER;
			labelText.hAlign = HAlign.LEFT;
			labelText.autoScale = false;
			addChild(labelText);
			return labelText;
		}
		
		override protected function commitData():void
		{
			if(_data is FoodDetailsVo){
				nameLabel.text = (_data as FoodDetailsVo).name;
				wieghtLabel.text = (_data as FoodDetailsVo).weight + "";
				priceLabel.text = (_data as FoodDetailsVo).price + "";
				totalPriceLabel.text = ((_data as FoodDetailsVo).weight * 
					(_data as FoodDetailsVo).price).toFixed(2);
				merchIdLabel.text = (_data as FoodDetailsVo).merchId;
				merchNameLabel.text = (_data as FoodDetailsVo).merchName;
				dealDateLabel.text = (_data as FoodDetailsVo).dealDate;
				StarlingLoader.loadImageFile((_data as FoodDetailsVo).icon,true,imageComplete);
			}
		}
		private var image:Image;//存放左侧图片
		private function imageComplete(t:Texture):void
		{
			if(image == null){
				image = new Image(t);
				addChildAt(image,0);
			}else{
				image.texture = t;
//				image.readjustSize();
			}
			image.width = 62 * Vision.widthScale;
			image.height = 45 * Vision.heightScale;
			image.x = 35 * Vision.widthScale;
			image.y = (height - image.height) / 2;
		}
		
		public override function get height():Number{
			return Vision.TRACE_ITEM_HEIGHT * Vision.heightScale;// + 20 *Math.random();
		}
		public override function set index(value:int):void
		{
			if(this._index != value)
			{
				super.index = value;
				if(this.alpha != 1)TweenLite.to(this,.3,{delay:.2 + .1 * value,alpha:1});
			}
		}
	}
}