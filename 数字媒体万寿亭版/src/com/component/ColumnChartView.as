package com.component
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.utils.StarlingConvert;
	import com.vo.ImageVo;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.utils.setTimeout;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ColumnChartView extends Sprite
	{
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		public function ColumnChartView(w:Number,h:Number){
			actualWidth = w;
			actualHeight = h;//交互区域大小
		}
		public static const TYPE_COLUMN:String = '柱形图';
		public static const TYPE_LINE:String = '线形图';
		
		private var _dataProvider:Object;
		private var _xField:String;//横向内容标记
		private var _yField:String;//纵向内容标记
		private var _columns:int = 6;//10;//标尺纵向节点数
		private var _minnum:Number = .5;//最小刻度值
		private var _columnHight:Number = 30;//间隔高度
		
		private static var drawView:MovieClip = new MovieClip();
		
		private var container:Sprite;
		private var myTips:Sprite;//显示tips
		
		private var _type:String = TYPE_LINE;
		/** 设置图表类型 柱形还是线性 **/
		public function set type(value:String):void
		{
			_type = value;
		}
		private var _backGroundColor:uint = 0xe5e5e5;
		public function get backGroundColor():uint
		{
			return _backGroundColor;
		}
		public function set backGroundColor(value:uint):void
		{
			_backGroundColor = value;
			if(back != null)back.color = value;
		}
		private var _avgLabel:String = "均值";//设置均值的显示文本
		public function set avgLabel(value:String):void
		{
			_avgLabel = value;
		}
		/** 设置图标*/
		private var _icon:Object;
		public function set icon(value:Object):void
		{
			_icon = value;
		}
		private var _title:String = '标题';//标题
		public function set title(value:String):void
		{
			_title = value;
			if(titleLabel != null)titleLabel.text = value;
		}
		private var _mesureUnit:String = '计算单位';//
		public function set mesureUnit(value:String):void
		{
			_mesureUnit = value;
			if(mesureLabel != null)mesureLabel.text = _mesureUnit;
		}
		public function set columns(value:int):void
		{
			_columns = value;
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		/* 开始画线 */
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				setTimeout(dataChanged,100);
			}
			//			dataChanged();
		}
		/**
		 *  @private
		 */
		public function set xField(value:String):void
		{
			_xField = value;
		}
		/**
		 *  @private
		 */
		public function set yField(value:String):void
		{
			_yField = value;
		}
		/* 开始计算尺寸和标尺比例 */
		private function dataChanged():void
		{
			if(this.stage == null || _xField == null || _yField == null || _dataProvider == null){
				return;
			}
			//			clearChild(this,container,myTips);
			clearChild(container);
			initFace();
			sortNode();
			drawLine();
			showText();
			drawGraphic();
			//			centerContainer();
		}
		
		private function centerContainer():void
		{
			//			trace("宽度:" + container.width);
			Vision.centerDpo(container,actualWidth,actualHeight);
		}
		private var paddingLeft:Number = 85 * Vision.widthScale;//左距离
		private var paddingBottom:Number = 60 * Vision.heightScale;//底部距离
		
		private var nodeList:Vector.<Number>;//纵向节点值列表
		private var avgNode:Number;//平均价格刻度
		private var maxValue:Number;
		/* 排列节点 */
		private function sortNode():void
		{
			var mValue:Number = getMaxValue();
			var inner:Number = mValue / _columns;//当前刻度值
			var last:int = 1;
			if(mValue > _minnum * _columns){//最大值也小于最小刻度
				if(inner < _minnum){
					inner = _minnum;//选择为最小刻度值
				}else{
					inner = Math.ceil(inner);
				}
			}else{
				inner = Math.ceil(inner * 100);
				last = 100;
			}
			maxValue = inner * _columns / last;
			if(nodeList == null)nodeList = new Vector.<Number>();
			nodeList.length = 0;
			for (var i:int = 0; i < _columns + 1; i++) 
			{
				nodeList.push(i * inner / last);//存入每个刻度值
			}
			avgNode = (nodeList[0] + nodeList[_columns]) / 2;//平均值刻度
		}
		
		/* 获取纵向最大值 */
		private function getMaxValue():Number{
			var maxValue:Number = 0;
			for (var j:int = 0; j < _dataProvider.length; j++) 
			{
				var item:Object = _dataProvider[j];
				var value:Number = item[_yField];
				if(value > maxValue){
					maxValue = value;
				}
			}
			return maxValue;
		}
		
		private var _lineColor:uint = 0x666666;
		private var _backColor:uint = 0x40c2dc;
		public function set backColor(value:uint):void
		{
			_backColor = value;
		}
		/* 对每个刻度进行画线 */
		private function drawLine():void
		{
			var _lineW:Number = actualWidth - paddingLeft * 1.5;
			var minHeight:Number = (actualHeight - titleBack.height - paddingBottom * 2)/(_columns + 1);
			if(minHeight < _columnHight){
				_columnHight = minHeight;
			}
			var _lineH:Number = (_columns + 1) * _columnHight;
			
			_columnWidth = _lineW / _dataProvider.length;
			
			var baseX:Number = paddingLeft;
			var baseY:Number = actualHeight - titleBack.height - paddingBottom;
			//			drawView.graphics.clear();
			//			drawView.graphics.lineStyle(Math.ceil(1.5 * Vision.heightScale),_lineColor);
			//			drawView.graphics.moveTo(baseX,baseY);
			//			drawView.graphics.lineTo(baseX,baseY - _lineH);
			
			//坐标竖线
//			var lineQuad:Quad = new Quad(Math.ceil(1 * Vision.normalScale),_lineH,_lineColor);
//			lineQuad.x = baseX;
//			lineQuad.y = baseY - _lineH;
//			lineQuad.pivotX = lineQuad.width / 2;
//			container.addChild(lineQuad);
			//			drawView.graphics.moveTo(baseX,baseY);
			//			drawView.graphics.lineTo(baseX + _lineW,baseY);
			//			drawView.graphics.endFill();
			
			var lineQuad:Quad = new Quad(_lineW,Math.ceil(1 * Vision.normalScale),_lineColor);
			lineQuad.x = baseX;
			lineQuad.y = baseY;
			lineQuad.pivotY = lineQuad.height / 2;
			container.addChild(lineQuad);
			
			//			drawView.graphics.lineStyle(Math.ceil(.5 * Vision.heightScale),_lineColor,.3);
			
			//			drawNode(drawView.graphics,baseX,baseY,_lineColor);
			//			drawNode(drawView.graphics,baseX,baseY - _lineH,_lineColor);
			//			drawNode(drawView.graphics,baseX + _lineW,baseY,_lineColor);
			
			//坐标竖线绘制点
//			var nodeImage1:Image = createNode(baseX,baseY,_lineColor);
//			container.addChild(nodeImage1);
//			var nodeImage2:Image = createNode(baseX,baseY - _lineH,_lineColor);
//			container.addChild(nodeImage2);
//			var nodeImage3:Image = createNode(baseX + _lineW,baseY,_lineColor);
//			container.addChild(nodeImage3);
			
			for (var i:int = 0; i < nodeList.length; i++) 
			{
				//				drawView.graphics.moveTo(baseX,baseY - _columnHight * i);
				//				drawView.graphics.lineTo(baseX + _lineW,baseY - _columnHight * i);
				lineQuad = new Quad(_lineW,Math.ceil(1 * Vision.normalScale),_lineColor);
				lineQuad.x = baseX;
				lineQuad.y = baseY - _columnHight * i;
				lineQuad.pivotY = lineQuad.height / 2;
				TweenLite.from(lineQuad,.5,{width:1});
				container.addChild(lineQuad);
			}
			
			lineQuad = new Quad(_lineW,Math.ceil(1 * Vision.normalScale),0);
			lineQuad.x = baseX;
			lineQuad.y = baseY - _columnHight * (nodeList.length - 1)  / 2;
			lineQuad.pivotY = lineQuad.height / 2;
			container.addChild(lineQuad);//均价
			avgButton.y = lineQuad.y - avgButton.height / 2;
			avgButton.x = baseX - avgButton.width - 5 * Vision.widthScale;
			
			//			var ivo:ImageVo = StaringConvert.convertBmd(drawView);
			//			var backImage:Image = createImage(ivo.texture);
			//			backImage.x = ivo.offSetX;
			//			backImage.y = ivo.offSetY;
			//			container.addChild(backImage);
		}
		//		private static var imageList:Vector.<Image> = new Vector.<Image>();
		private static function createImage(t:Texture):Image{
			//			if(imageList.length > 0){
			//				var image:Image = imageList.pop();
			//				image.texture = t;
			//				image.readjustSize();
			//				return image;
			//			}
			var image:Image = new Image(t);
			return image;
		}
		private static var textList:Vector.<TextField> = new Vector.<TextField>();
		private static function createText(w:Number,h:Number,text:String = ""):TextField{
			if(textList.length > 0){
				var textField:TextField = textList.pop();
				textField.width = w;
				textField.height = h;
				textField.text = text;
				textField.bold = false;
				return textField;
			}
			textField = new TextField(w,h,text);
			return textField;
		}
		private static function recyleText(t:TextField):void{
			t.rotation = 0;
			textList.push(t);
		}
		//		private static function recyle(image:Image):void{
		//			imageList.push(image);
		//		}
		private function createButton(w:Number,h:Number,label:String,color:uint = 0x717b72):Sprite{
			var sp:Sprite = new Sprite();	
			var back:Image = new Image(Vision.createRoundRect(w,h,color));
			sp.addChild(back);
			var	textFiled:TextField = createText(w,h,label);
			textFiled.fontSize = 10 * Vision.normalScale;
			textFiled.color = 0xFFFFFF;
			sp.addChild(textFiled);
//			textFiled.autoScale = true;//自动伸缩布局
			return sp;
		}
		
		private function drawNode(g:Graphics,x:Number,y:Number,color:uint = 0):void{
			g.beginFill(color);
			g.drawCircle(x,y,2);
			g.endFill();
		}
		//		private static var testImage:Image = new Image(Texture.empty(1,1));
		private function createNode(x:Number,y:Number,color:uint = 0):Image{
			var image:Image = Vision.createCircle(color,5 * Vision.heightScale);
			image.x = x;
			image.y = y;
			return image;
		}
		private var _columnWidth:Number = 30;
		
		private function showText():void
		{
			var baseX:Number = paddingLeft;
			var baseY:Number = actualHeight - titleBack.height - paddingBottom;
			for (var i:int = 0; i < nodeList.length; i++) 
			{
				var label:TextField = createText(80 * Vision.widthScale,25 * Vision.heightScale,
					nodeList[i].toString());
				//				label.vAlign = VAlign.TOP;
				label.hAlign = HAlign.RIGHT;
				label.fontSize = 15 * Vision.heightScale;
				label.color = _lineColor;
				label.x = baseX - label.width - 5 * Vision.widthScale;
				label.y = baseY - _columnHight * i - label.height / 2;
				container.addChild(label);
			}
			var rta:Number = Math.PI / 180;
			var txtY:Number = (titleBack.y + baseY) / 2;
			for (var j:int = 0; j < _dataProvider.length; j++) 
			{
				var item:Object = _dataProvider[j];
				var value:* = item[_xField];
				label = createText(120 * Vision.widthScale,25 * Vision.heightScale,value);
				label.hAlign = HAlign.LEFT;
				label.vAlign = VAlign.CENTER;
				label.fontSize = 15 * Vision.heightScale;
				label.color = _lineColor;
//				label.rotation = 15 * rta;
				label.x = baseX + _columnWidth * j;// + 10 * Vision.widthScale; + _columnWidth / 4;// - label.width / 2;
				label.y = txtY - label.height / 2;
				//				label.pivotX = label.width / 2;
				//				label.pivotY = label.height / 2;
				container.addChild(label);
			}
		}
		private var back:Quad;//背景
		private var titleLabel:TextField;
		private var mesureLabel:TextField;
		private var avgButton:Sprite;
		private function initFace():void
		{
			if(container == null){
				back = new Quad(actualWidth,actualHeight,_backGroundColor);
				addChild(back);
				container = new Sprite();
				addChild(container);
				titleBack = new Quad(actualWidth,40 * Vision.heightScale,0x001100);
				addChild(titleBack);
				titleBack.y = actualHeight - titleBack.height;
				
				titleLabel = createText(actualWidth,50 * Vision.heightScale,_title);
				titleLabel.hAlign = HAlign.LEFT;
				titleLabel.fontSize = 28 * Vision.normalScale;
				titleLabel.color = 0x666666;
				titleLabel.bold = true;
				titleLabel.autoScale = false;
				titleLabel.x = paddingLeft - 27 * Vision.widthScale;
				titleLabel.y = paddingBottom - titleLabel.height;// - 5 * Vision.heightScale;//actualHeight - titleBack.height / 2 - titleLabel.height / 2;
				addChild(titleLabel);
				
				mesureLabel = createText(200 * Vision.widthScale,18 * Vision.heightScale,_mesureUnit);
				addChild(mesureLabel);
				mesureLabel.fontSize = 12 * Vision.heightScale;
				mesureLabel.x = paddingLeft - mesureLabel.width / 2;
				mesureLabel.y = paddingBottom;// - mesureLabel.height;// - 5 * Vision.heightScale;
				mesureLabel.color = _lineColor;
				
				avgButton = createButton(35 * Vision.widthScale,20 * Vision.heightScale,_avgLabel);
				addChild(avgButton);
			}
		}
		/* 绘制图形 */
		private function drawGraphic():void
		{
			if(_type == TYPE_COLUMN){
				//				drawZhu();
			}else{
				drawXian();
			}
		}
		private static var lineShape:Shape;
		private static var backShape:Shape;
		/* 线性图表 */
		private var titleBack:Quad;

		private var backImage:Image;
		private function drawXian():void
		{
			if(lineShape == null){
				lineShape = new Shape();
				drawView.addChild(lineShape);
			}
			if(backShape == null){
				backShape = new Shape();
				drawView.addChild(backShape);
			}
			var baseX:Number = paddingLeft;
			var baseY:Number = actualHeight - titleBack.height - paddingBottom;
			lineShape.graphics.clear();
			lineShape.graphics.lineStyle(Math.ceil(1 * Vision.normalScale),_backColor);
			backShape.graphics.clear();
			backShape.graphics.beginFill(_backColor,.5);
			backShape.graphics.moveTo(baseX,baseY);
			for (var j:int = 0; j < _dataProvider.length; j++) 
			{
				var item:Object = _dataProvider[j];
				var value:* = item[_yField];
				var y:Number = -value / maxValue * _columns * _columnHight;
				if(j == 0){
					lineShape.graphics.moveTo(baseX,baseY + y);
					backShape.graphics.lineTo(baseX,baseY + y);
				}
				var x:Number = _columnWidth * j + 10 * Vision.widthScale + _columnWidth / 4;
				lineShape.graphics.lineTo(baseX + x,baseY + y);
				backShape.graphics.lineTo(baseX + x,baseY + y);
				var nodeImage:Image = createNode(baseX + x,baseY + y,_backColor);
				container.addChild(nodeImage);
				TweenLite.from(nodeImage,.5,{delay:.05 * j,y:baseY});
			}
			var _lineW:Number = actualWidth - paddingLeft * 1.5;
			lineShape.graphics.lineTo(baseX + _lineW,baseY + y);
			backShape.graphics.lineTo(baseX + _lineW,baseY + y);
			backShape.graphics.lineTo(baseX + _lineW,baseY);
			backShape.graphics.endFill();
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this,.05 * j,{onComplete:showBack});
			//			ivo = StaringConvert.convertBmd(lineShape);
			//			var lineImage:Image = createImage(ivo.texture);
			//			lineImage.x = ivo.offSetX;
			//			lineImage.y = ivo.offSetY;
			//			container.addChildAt(lineImage,0);
			
			//			TweenLite.from(lineImage,.5,{delay:.1 * j,alpha:0});
		}
		
		private function showBack():void{
			var ivo:ImageVo = StarlingConvert.convertBmd(drawView);
			if(backImage == null){
				backImage = new Image(ivo.texture);
				backImage.smoothing = TextureSmoothing.BILINEAR;
			}else{
				backImage.texture.dispose();//释放掉之前的纹理
				backImage.texture = ivo.texture;
				backImage.readjustSize();
			}
//			backImage = createImage(ivo.texture);
			backImage.x = ivo.offSetX;
			backImage.y = ivo.offSetY;
			container.addChildAt(backImage,0);
			TweenLite.from(backImage,.5,{alpha:0});
		}
		
		/* 柱形图 */
		//		private function drawZhu():void
		//		{
		//			for (var j:int = 0; j < _dataProvider.length; j++) 
		//			{
		//				var item:Object = _dataProvider[j];
		//				var value:* = item[_yField];
		//				var uc:UIComponent = new UIComponent();
		//				uc.graphics.beginFill(_backColor);
		//				var h:Number = value / maxValue * _columns * _columnHight;
		//				uc.graphics.drawRect(-_columnWidth / 4,0,_columnWidth / 2,-h);
		//				uc.graphics.endFill();
		//				uc.height = h;
		//				uc.x = drawView.x + _columnWidth * j + 10  + _columnWidth / 4;
		//				uc.y = drawView.y;
		//				addElement(uc);
		//				uc.filters = [new DropShadowFilter(2,45,0x888888)];
		//				TweenLite.from(uc,.5,{delay:j * .1,scaleY:0});
		//				uc.name = 'uc_' + j;
		//			}
		//		}
		
		//		private function onMouseOver(e:MouseEvent):void
		//		{
		//			if(e.target.name.split('_')[0] == 'uc'){
		//				var uc:UIComponent = e.target as UIComponent;
		//				var index:int = uc.name.split('_')[1];
		//				showTips(uc.x,uc.y - uc.height,_dataProvider[index][_xField],
		//					_dataProvider[index][_yField]);
		//			}
		//		}
		//		
		//		private function showTips(x:Number,y:Number,fieldX:*,fieldY:*):void{
		//			myTips.x = x;
		//			myTips.y = y;
		//			tipFieldX.text = fieldX;
		//			tipFieldY.text = fieldY;
		//			drawConCle(myTips.graphics);
		//			TweenLite.to(myTips,.2,{alpha:1});
		//			setElementIndex(myTips,numChildren - 1);
		//		}
		
		private function drawConCle(g:Graphics):void{
			g.clear();
			g.lineStyle(1.5,_backColor);
			g.beginFill(0xFFFFFF);
			g.drawCircle(0,0,6);
			g.endFill();
			g.beginFill(_backColor);
			g.drawCircle(0,0,3);
			g.endFill();
		}
		
		//		private function onMouseOut(e:MouseEvent):void
		//		{
		//			if(e.target.name.split('_')[0] == 'uc'){
		//				TweenLite.to(myTips,.2,{alpha:0});
		//			}
		//		}
		/* args除了哪些不要删除 */
		private function clearChild(parent:DisplayObjectContainer,...args):void{
			if(parent == null)return;
			while(parent.numChildren > 0){
				var child:DisplayObject = parent.getChildAt(parent.numChildren - 1);
				parent.removeChild(child);
				if(child is Image){
					child.dispose();
				}else if(child is TextField){
					child.dispose();
//					recyleText(child as TextField);
				}
			}
			//			parent.removeChildren();
			for each (var ele:DisplayObject in args) 
			{
				if(ele != null)parent.addChild(ele);
			}
		}
		
	}
}