package com.utils
{
	import com.manager.Vision;
	import com.vo.ImageVo;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class StarlingConvert
	{
//		public static function convertButton(dpo:SimpleButton):Button{
//			if(dpo.parent != null)dpo.parent.removeChild(dpo);
//			var bounds:Rectangle = dpo.getBounds(null);
//			var upTx:Texture = convertBmd(dpo.upState).texture;
//			var downTx:Texture = convertBmd(dpo.downState).texture;
//			var btn:Button = new Button(upTx,'',downTx);
//			btn.x = dpo.x;
//			btn.y = dpo.y;
//			btn.scaleX = dpo.scaleX;
//			btn.scaleY = dpo.scaleY;
//			btn.pivotX = -bounds.x;
//			btn.pivotY = -bounds.y;
//			return btn;
//		}
		
		public static function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x5c5c5c,
									label:String = ""):starling.text.TextField{
			var labelText:starling.text.TextField = new starling.text.TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.vAlign = VAlign.CENTER;
			labelText.hAlign = HAlign.CENTER;
			return labelText;
		}
		
		/**
		 * 将目标转换成Star影片
		 * @param mc
		 * @return 
		 */		
//		public static function convertMc(mc:MovieClip,touchable:Boolean = true):StaringClip{
//			if(mc.parent != null)mc.parent.removeChild(mc);
//			var sc:StaringClip = StaringClip.convert(mc);
//			sc.touchable = touchable;
//			return sc;
//		}
		/**
		 * 将目标转换成Star文本
		 * @param mc
		 * @return 
		 */	
		public static function convertTxt(txt:flash.text.TextField,touchable:Boolean = true):
			starling.text.TextField{
			if(txt.parent != null)txt.parent.removeChild(txt);
			var tf:starling.text.TextField = new starling.text.TextField(txt.width,txt.height,txt.text);
			tf.color = txt.textColor;
			tf.fontSize = Number(txt.defaultTextFormat.size);
			tf.touchable = touchable;
			tf.x = txt.x;
			tf.y = txt.y;
			tf.scaleX = txt.scaleX;
			tf.scaleY = txt.scaleY;
			return tf;
		}
		
		public static function convertTextInput(txt:flash.text.TextField):StageTextTextEditor{
			if(txt.parent != null)txt.parent.removeChild(txt);
			var tf:StageTextTextEditor = new StageTextTextEditor();
			tf.fontFamily = txt.defaultTextFormat.font;
			tf.fontSize = Number(txt.defaultTextFormat.size);
			tf.color = txt.textColor;
			tf.x = txt.x;
			tf.y = txt.y;
			tf.width = txt.width;
			tf.height = txt.height;
			tf.scaleX = txt.scaleX;
			tf.scaleY = txt.scaleY;
			tf.maxChars = txt.maxChars;
//			tf.textAlign = 
			return tf;
		}
		
		/**
		 * 将目标转换成Star容器
		 * @param mc
		 * @return 
		 */
		public static function convertSp(dpo:DisplayObject,touchable:Boolean = true):Sprite{
			if(dpo.parent != null)dpo.parent.removeChild(dpo);
			var image:Image = convertBmp(dpo,false);
			var sp:Sprite = new Sprite();
			sp.addChildAt(image,0);
			sp.touchable = touchable;
			sp.x = dpo.x;
			sp.y = dpo.y;
			sp.scaleX = dpo.scaleX;
			sp.scaleY = dpo.scaleY;
			return sp;
		}
//		private static var bmpDic:Dictionary = new Dictionary(true);
		/**
		 * 将目标转换成Star图片
		 * @param dpo
		 * @return 
		 */		
		public static function convertBmp(dpo:DisplayObject,touchable:Boolean = true):Image{
			if(dpo.parent != null)dpo.parent.removeChild(dpo);
			var vo:ImageVo = convertBmd(dpo);
			var image:Image = new Image(vo.texture);
			image.x = dpo.x;
			image.y = dpo.y;
			image.pivotX = -vo.offSetX;
			image.pivotY = -vo.offSetY;
			image.touchable = touchable;
			return image;
		}
		public static function convertBmd(dpo:flash.display.DisplayObject):ImageVo{
			//			var className:String = getQualifiedClassName(dpo);
			//			if(bmpDic[className] !== undefined){
			//				var vo:ImageVo = bmpDic[className];
			//			}else{
			var vo:ImageVo /*= bmpDic[className]*/ = new ImageVo();
			var bounds:Rectangle = dpo.getBounds(null);
			vo.offSetX = bounds.x * dpo.scaleX;
			vo.offSetY = bounds.y * dpo.scaleY;
			var matrix:Matrix = new Matrix(1,0,0,1,-vo.offSetX,-vo.offSetY);
			var bitmapData:BitmapData = /*new BitmapData(Math.ceil(dpo.width),Math.ceil(dpo.height),
				true,0x00000000);*/
				AssetManager.getSourceBd(dpo.width,dpo.height);
			bitmapData.lock();
			bitmapData.draw(dpo,matrix);
			bitmapData.unlock();
			vo.texture = Texture.fromBitmapData(bitmapData);
//			bitmapData.dispose();
			//			}
			return vo;
		}
		
		
	}
}
