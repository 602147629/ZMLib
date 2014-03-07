package com.rendener
{
	import com.manager.Vision;
	import com.utils.StarlingLoader;
	import com.vo.PersonVo;
	
	import flash.display.Bitmap;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 市场管理员
	 * @author Administrator
	 */	
	public class ManagerRender extends BasicItemRenderer
	{
		private var iconImage:Image;//存放左侧图片
		private var nameLabel:TextField;//名字(264,24)
		private var occupLabel:TextField;//职位(264,107)
		private var idLabel:TextField;//编号(264,131)
		
		override protected function initialize():void
		{
			nameLabel = createText(150 * Vision.widthScale,45 * Vision.heightScale,
				25 * Vision.normalScale,0xFFFFFF);
			nameLabel.x = (width - nameLabel.width) / 2;
			nameLabel.y = 167 * Vision.heightScale;
			nameLabel.bold = true;
			
			occupLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale,0xFFFFFF);
			occupLabel.x = (width - occupLabel.width) / 2;
			occupLabel.y = 220 * Vision.heightScale;
			
			idLabel = createText(150 * Vision.widthScale,30 * Vision.heightScale,
				20 * Vision.normalScale,0xFFFFFF);
			idLabel.x = (width - idLabel.width) / 2;
			idLabel.y = 236 * Vision.heightScale;
			
			createLine();
		}
		
		//创建下划线
		private function createLine():void
		{
//			var w:Number = 480 * Vision.widthScale;
			var quad:Quad = new Quad(width,Math.ceil(1 * Vision.heightScale),0xFFFFFF);
			addChild(quad);
			quad.y = height - quad.height;
			quad.x = (width - quad.width) / 2;
		}
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x50b5e0,
									label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.TOP;
			labelText.hAlign = HAlign.CENTER;
			labelText.autoScale = false;
			addChild(labelText);
			return labelText;
		}
		
		override protected function commitData():void
		{
			if(_data is PersonVo){
				//				StarlingLoader.loadFile((_data as PersonVo).icon,loadImage);
				StarlingLoader.loadImageFile((_data as PersonVo).icon,false,loadImage);
				nameLabel.text = (_data as PersonVo).name;
				occupLabel.text = (_data as PersonVo).occup;
//				idLabel.text = (_data as PersonVo).number;//"00" + _index;//"00" + _index;//
			}
		}
		
		private function loadImage(bmp:Bitmap/*,t:Texture*/):void
		{
			bmp.scaleX = Vision.widthScale;
			bmp.scaleY = Vision.heightScale;
			if(iconImage == null){
				//				iconImage = new Image(Vision.drawRoundMask(bmp,40 * Vision.normalScale,0x50b5e0,
				//					5 * Vision.normalScale));
				iconImage = new Image(Vision.drawRectMask(bmp,150 * Vision.widthScale,
					150 * Vision.heightScale,10,1.5 * Vision.normalScale,0xb0e5f7));
				addChild(iconImage);
				iconImage.smoothing = TextureSmoothing.BILINEAR;
				iconImage.x = (width - iconImage.width) / 2;
				iconImage.y = 20 * Vision.heightScale;
			}else{
				iconImage.texture = Vision.drawRectMask(bmp,150 * Vision.widthScale,
					150 * Vision.heightScale,10,1.5 * Vision.normalScale,0xb0e5f7);
				iconImage.readjustSize();
			}
		}
		
		public override function get height():Number{
			return Vision.MANAGE_ITEM_HEIGHT * Vision.heightScale;
		}
		public override function get width():Number{
			return Vision.MANAGE_ITEM_WIDTH * Vision.widthScale;
		}
		
	}
}