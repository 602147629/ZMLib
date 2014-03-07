package com.rendener
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.PowerLoader;
	import com.utils.StarlingLoader;
	import com.vo.NormalItemVo;
	
	import flash.display.Bitmap;
	
	import feathers.display.BasicItemRenderer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class NormalItemRendener extends BasicItemRenderer
	{
		private var image:Image;//存放左侧图片
		private var title:TextField;//标题
		private var info:TextField;//信息
		private var timeLabel:TextField;//日期
		
		private var imageContaner:Sprite;
		
//		override protected function removedFromStageHandler(event:Event):void
//		{
//			super.removedFromStageHandler(event);
//			this.alpha = 0;
//			this._index = -1;
//		}
		
		override protected function initialize():void
		{
			imageContaner = new Sprite();
			addChild(imageContaner);
			imageContaner.x = 38 * Vision.widthScale;
//			imageContaner.y = (height - image.height) / 2;//20 * Vision.heightScale;
			
			title = new TextField(700 * Vision.widthScale,50 * Vision.heightScale,"");
			addChild(title);
			
			title.x = 300 * Vision.widthScale;
			title.y = 15 * Vision.heightScale;
			title.fontSize = 28 * Vision.normalScale;
			title.hAlign = HAlign.LEFT;
			title.vAlign = VAlign.TOP;
//			title.bold = true;
			title.color = 0x5d5d5d;
			
			timeLabel = new TextField(180 * Vision.widthScale,20 * Vision.heightScale,"");
			timeLabel.fontSize = 12 * Vision.normalScale;
			timeLabel.hAlign = HAlign.LEFT;
			timeLabel.x = title.x;
			timeLabel.y = 62 * Vision.heightScale;
			timeLabel.color = 0xbebebe;
			addChild(timeLabel);
			
			info = new TextField(650 * Vision.widthScale,110 * Vision.heightScale,"");
			info.autoScale = false;
			info.x = title.x;
			info.y = 92 * Vision.heightScale;
			info.fontSize = 18 * Vision.normalScale;
			info.color = 0xbebebe;
//			info.autoSize = true;
			info.hAlign = HAlign.LEFT;
			info.vAlign = VAlign.TOP;
			info.leading = 5 * Vision.normalScale;
			info.turncateToFit = true;//自动裁剪末尾为...
			addChild(info);
			//29
			
			createLine();
			createIcon();
			
			this.alpha = 0;
		}
		//创建向右图标
		private function createIcon():void
		{
			StarlingLoader.loadImageFile("assets/other/arrow01.png",true,iconComplete);
		}
		
		private function iconComplete(t:Texture):void
		{
			var icon:Image = new Image(t);
			addChild(icon);
			icon.x = 1011 * Vision.widthScale;
			icon.y = (Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale - icon.height) / 2;//纵向居中
		}
		//创建下划线
		private function createLine():void
		{
			var w:Number = 1005 * Vision.widthScale;
			var quad:Quad = new Quad(w,Math.ceil(1 * Vision.normalScale),0xe5e5e5);
			addChild(quad);
			quad.y = Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale - quad.height;
			quad.x = (Vision.senceWidth - quad.width) / 2;
		}
		
		override protected function commitData():void{
			title.text = (_data as NormalItemVo).title;
			info.text = (_data as NormalItemVo).des;//(_data as NormalItemVo).des.slice(0,100) + "...";
			if(image != null)image.texture = Vision.TEXTURE_EMPTY;
//			StarlingLoader.loadFile((_data as NormalItemVo).icon,imageComplete);
			StarlingLoader.loadImageFile((_data as NormalItemVo).icon,false,imageComplete);
			StarlingLoader.loadImageFile("assets/other/imageShade.png",true,shadeComplete);
			//加载目标素材
			var date:Date = (_data as NormalItemVo).time;
			if(date != null){
				timeLabel.text = date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日";
			}
			if(this.owner != null && this.owner.isScrolling){
				this.alpha = 1;
				TweenLite.killTweensOf(this);
			}
		}
		
		private var shade:Image;
		private function shadeComplete(t:Texture):void
		{
			if(shade == null){
				shade = new Image(t);
				shade.smoothing = TextureSmoothing.BILINEAR;
				imageContaner.addChildAt(shade,0);
			}else{
				shade.texture = t;
				shade.readjustSize();
			}
			shade.scaleX = Vision.widthScale;
			shade.scaleY = Vision.heightScale;
			shade.x = -6 * Vision.widthScale;
			shade.y = (height - shade.height) / 2 + 4 * Vision.heightScale;//20 * Vision.heightScale;
		}
		//assets/other/imageShade.png
		private function imageComplete(bmp:Bitmap/*,t:Texture*/):void
		{
			var w:Number = 240 * Vision.widthScale;
			var h:Number = 150 * Vision.heightScale;
			bmp.scaleX = Vision.widthScale;
			bmp.scaleY = Vision.heightScale;
			var t:Texture = Vision.drawRectMask(bmp,w,h);
			if(image == null){
				image = new Image(t);
				imageContaner.addChild(image);
			}else{
				image.texture = t;
				image.readjustSize();
			}
			image.y = (height - image.height) / 2;//20 * Vision.heightScale;
//			image.scaleX = Vision.widthScale;
//			image.scaleY = Vision.heightScale;
			
		}
		
		public override function get height():Number{
			return Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale;
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