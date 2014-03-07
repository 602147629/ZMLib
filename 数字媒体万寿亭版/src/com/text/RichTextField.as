package com.text
{
	import com.manager.Vision;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;
	
	public class RichTextField extends TextField
	{
		public function RichTextField(width:int, height:int, text:String = "", fontName:String="Verdana", fontSize:Number=12, color:uint=0, bold:Boolean=false)
		{
			super(width, height, text, fontName, fontSize, color, bold);
			if(richTextArea == null)createRichText();
		}
		/** @inheritDoc */
		//		public override function render(support:RenderSupport, parentAlpha:Number):void
		//		{
		//			super.render(support, parentAlpha);
		//		}
		protected static var richTextArea:RichTextArea;
		protected static var richContainer:flash.display.Sprite;
		protected static function createRichText():void{
			richTextArea = new RichTextArea(1,1);
			richTextArea.textField.wordWrap = true;
			richTextArea.textField.multiline = true;
			richTextArea.textField.autoSize = TextFieldAutoSize.LEFT;
			richTextArea.mouseChildren = richTextArea.mouseEnabled = false;
//			richTextArea.leading = 15;
			richTextArea.leading = 15;// * Vision.normalScale;
			richContainer = new flash.display.Sprite();
			richTextArea.sizeFunc = sizeFunc;
		}
		//微软雅黑字号转换公式
		private static function sizeFunc(size:int):int{
			return (size - 5) / 11 * 10;
		}
		
		private var _richScale:Number;
		public function get richScale():Number
		{
			return _richScale;
		}
		
		override public function set text(value:String):void
		{
			if (value == null) value = "";
			mText = value;
			mRequiresRedraw = true;
		}
		
		public function set richScale(value:Number):void
		{
			_richScale = value;
		}
		private var _configXML:XML;
		public function set configXML($xml:XML):void
		{
			_configXML = $xml;
			richTextArea.configXML = _configXML;
		}
		public function get configXML():XML
		{
			return _configXML;
		}
		//		private var isShow:Boolean;
		private var imageContainer:starling.display.Sprite;
		protected override function createRenderedContents():void
		{
			//			if(isShow){
			//				return;
			//			}
			//			isShow = true;
			if(mText == ""){
				return;
			}
			var richVector:Vector.<BitmapData> = getBmdList(mText);
			if(richVector != null){//直接显示了
				showRichVector(richVector);
				return;
			}
			if (mQuadBatch)
			{
				mQuadBatch.removeFromParent(true); 
				mQuadBatch = null; 
			}
			if (mTextBounds == null) 
				mTextBounds = new Rectangle();
			var scale:Number  = Starling.contentScaleFactor;
			var width:Number  = mHitArea.width  * scale;
			var height:Number = mHitArea.height * scale;
			
			var richWidth:Number = width / _richScale;
			richTextArea.scaleX = richTextArea.scaleY = 1;//恢复比例
			richTextArea.resizeTo(richWidth,height);
			richTextArea.addEventListener(flash.events.Event.COMPLETE,onTextComplete);
			if(TextField.registerName != ""){
				richTextArea.textField.embedFonts = true;
				richTextArea.fontName = TextField.registerName;
				richTextArea.richText = "<font face='" + TextField.registerName + "' color='#" + mColor.toString(16) + "' size='" + mFontSize + "' >" + mText + "</font>"
			}else{
				richTextArea.textField.embedFonts = false;
				richTextArea.richText = "<font color='#" + mColor.toString(16) + "' size='" + mFontSize + "' >" + mText + "</font>"
			}
		}
		
		private function showRichVector(richVector:Vector.<BitmapData>):void
		{
			initImageContainer();
			var scale:Number  = Starling.contentScaleFactor;
			//切片最多个数
			for (var i:int = 0; i < richVector.length; i++) 
			{
				var bitmapData:BitmapData = richVector[i];
				try{
					var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale);
					//添加子实例
					var image:Image = createImage(texture);
					//				image.smoothing = TextureSmoothing.TRILINEAR;
					//				image.touchable = false;
					imageContainer.addChild(image);
					image.y = i * MAX_IMAGE_HEIGHT;
				}catch(e:Error){
					trace("纹理限制错误:" + e);
					trace(mText);
				}
			}
			this.height = image.y + bitmapData.height;
			mRequiresRedraw = false;
			
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}
		
		private function onTextComplete(e:flash.events.Event):void
		{
			richTextArea.removeEventListener(flash.events.Event.COMPLETE,onTextComplete);
			
			richTextArea.scaleX = richTextArea.scaleY = _richScale;//原始比例
			richContainer.addChild(richTextArea);
			var height:Number = 0;
			this.height = height = richContainer.height;
			mRequiresRedraw = false;
			
			//此处要开始截取像素值
			//			Vision.stage.addChild(richContainer);
			//			richContainer.x = Vision.senceWidth / 2;
			//			richContainer.y = Vision.senceHeight / 2;
			//			richTextArea.y = - 3000;
			//			richTextArea.richText = "";
			
			createImageList();
			
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}
		
		
		private function initImageContainer():void{
			if(imageContainer == null){
				imageContainer = new starling.display.Sprite();
				imageContainer.touchable = false;
				addChild(imageContainer);
			}
			while(imageContainer.numChildren > 0){
				var child:DisplayObject = imageContainer.getChildAt(imageContainer.numChildren - 1);
				imageContainer.removeChild(child);
				if(child is Image){
					recyleImage(child as Image);
				}
			}
		}
		
		private static const MAX_IMAGE_HEIGHT:Number = 2048;//不超过2048
		private function createImageList():void
		{
			initImageContainer();
			var scale:Number  = Starling.contentScaleFactor;
			var count:int = Math.ceil(richContainer.height / MAX_IMAGE_HEIGHT);
			//切片最多个数
			var w:Number = richContainer.width;
			for (var i:int = 0; i < count; i++) 
			{
				if(i == count - 1){//最后一个
					var h:Number = richContainer.height % MAX_IMAGE_HEIGHT;
				}else{
					h = MAX_IMAGE_HEIGHT;//最大值
				}
				var bitmapData:BitmapData = new BitmapData(w,h,true,0x00000000);//AssetManager.getSourceBd(w,h);
				saveBd(mText,bitmapData);
				bitmapData.draw(richContainer,new Matrix(1,0,0,1,0,-i * MAX_IMAGE_HEIGHT));
				try{
					var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale);
					//添加子实例
					var image:Image = createImage(texture);
					//				image.smoothing = TextureSmoothing.TRILINEAR;
					//				image.touchable = false;
					imageContainer.addChild(image);
					image.y = i * MAX_IMAGE_HEIGHT;
				}catch(e:Error){
					trace("纹理限制错误:" + e);
					trace(mText);
				}
			}
			//			var bitmapData:BitmapData = AssetManager.getSourceBd(richContainer.width, 
			//				richContainer.height);
			//			bitmapData.draw(richContainer);
			//			var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale);
			//			if (mImage == null) 
			//			{
			//				mImage = new Image(texture);
			//				mImage.touchable = false;
			//				addChild(mImage);
			//			}
			//			else 
			//			{ 
			//				mImage.texture.dispose();
			//				mImage.texture = texture; 
			//				mImage.readjustSize(); 
			//			}
		}
		
//		private var _autoRealease:Boolean;//界面淡出自动释放
//		public function 
		
		private static function getBmdList(key:String):Vector.<BitmapData>{
			return richBdDic[key];
		}
		
		private static var richBdDic:Dictionary = new Dictionary(true);
		//key:mText value:Vector.<BitmapData>
		private static function saveBd(key:String,bd:BitmapData):void{
			if(richBdDic[key] === undefined){
				richVector = richBdDic[key] = new Vector.<BitmapData>();
			}else{
				var richVector:Vector.<BitmapData> = richBdDic[key];
			}
			richVector.push(bd);
		}
		
		private static var imageList:Vector.<Image> = new Vector.<Image>();
		private static function createImage(t:Texture):Image{
			if(imageList.length > 0){
				var image:Image = imageList.pop();
				image.texture.dispose();
				image.texture = t;
				image.readjustSize();
				return image;
			}
			image = new Image(t);
			image.addEventListener(starling.events.Event.REMOVED_FROM_STAGE,onRemove);
			return image;
		}
		
		private static function onRemove(e:starling.events.Event):void
		{
			var image:Image = e.currentTarget as Image;
			image.texture.dispose();
		}
		private static function recyleImage(image:Image):void{
			imageList.push(image);
		}
		
	}
}