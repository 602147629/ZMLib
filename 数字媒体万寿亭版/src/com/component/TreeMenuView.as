package com.component
{
	import com.manager.Vision;
	
	import feathers.events.ItemEvent;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 用来导航的关系树组件
	 */	
	public class TreeMenuView extends Sprite
	{
		private var actualWidth:Number;//绝对大小 没有进行缩放
		private var actualHeight:Number;
		/**
		 * 本版本未做销毁机制
		 * @param w
		 * @param h
		 */		
		public function TreeMenuView(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
		}
//		private var _labelFieldList:Array;//显示文字关键字 根据家族成员深度排列
//		public function get labelFieldList():Array
//		{
//			return _labelFieldList;
//		}
//		public function set labelFieldList(value:Array):void
//		{
//			_labelFieldList = value;
//		}
//		private var _itemFiledList:Array;//子集条目列表打开关键字
//		public function get itemFiledList():Array
//		{
//			return _itemFiledList;
//		}
//		public function set itemFiledList(value:Array):void
//		{
//			_itemFiledList = value;
//		}
		//		private var _dataFiledList:Array;//显示重要用户数据关键字
		//		public function get dataFiledList():Array
		//		{
		//			return _dataFiledList;
		//		}
		//		public function set dataFiledList(value:Array):void
		//		{
		//			_dataFiledList = value;
		//		}
		private var _itemColor:uint = 0x50b5e1;//设置条目颜色
		public function get itemColor():uint
		{
			return _itemColor;
		}
		public function set itemColor(value:uint):void
		{
			_itemColor = value;
		}
		private var _labelField:String = "label";
		public function get labelField():String
		{
			return _labelField;
		}
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		private var _itemFiled:String = "itemFiled";
		public function get itemFiled():String
		{
			return _itemFiled;
		}
		private var _selectItem:Object;
		public function get selectItem():Object
		{
			return _selectItem;
		}
		public function set selectItem(value:Object):void
		{
			_selectItem = value;
		}
		/**
		 * 规定每个item的关键字 必须都一致
		 * @param value
		 */		
		public function set itemFiled(value:String):void
		{
			_itemFiled = value;
		}
		private var _backGroundColor:uint = 0xabddf6;
		public function get backGroundColor():uint
		{
			return _backGroundColor;
		}
		public function set backGroundColor(value:uint):void
		{
			_backGroundColor = value;
			if(back != null)back.color = value;
		}
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				showView();
			}
		}
//		private var depth:int;//子集深度
		private var treeList:Array = [];//树形列表Vector.<Vector.<TreeVo>>
		//
		private function showView():void
		{
			createTree(_dataProvider,0);
			initFace();
			showTree();
			showLine();
			centerContainer();
			if(_selectItem != null)select(_selectItem);
		}		
		
		private function centerContainer():void
		{
//			trace("宽度:" + container.width);
			Vision.centerDpo(container,actualWidth,actualHeight);
			if(container.width > actualWidth || container.height > actualHeight){
				//等比例缩放
				var sx:Number = actualWidth / container.width;
				var sy:Number = actualHeight / container.height;
				var scale:Number = sx > sy ? sy : sx;
//				var rect:Rectangle = container.getBounds(container);
				
//				container.pivotX = rect.x + rect.width / 2;
//				container.pivotY = rect.y + rect.height / 2;
				testSp.scaleX = testSp.scaleY = scale;
//				container.pivotX = container.pivotY = 0;
			}else{
				testSp.scaleX = testSp.scaleY = 1;
			}
//			trace("宽度:" + container.width);
		}
		private var container:Sprite;//父容器
		private var testSp:Sprite;
		private var itemLayer:Sprite;//条目荣期
		private var lineLayer:Sprite;//画线的容器
		private var back:Quad;//背景
		private function initFace():void
		{
			if(container == null){
				back = new Quad(actualWidth,actualHeight,_backGroundColor);
				addChild(back);
				testSp = new Sprite();
				addChild(testSp);
				testSp.pivotX = actualWidth / 2;
				testSp.pivotY = actualHeight / 2;
				testSp.x = actualWidth / 2;
				testSp.y = actualHeight / 2;
				container = new Sprite();
				testSp.addChild(container);
				itemLayer = new Sprite();
				container.addChild(itemLayer);
				lineLayer = new Sprite();
				container.addChild(lineLayer);
				lineLayer.touchable = false;
			}
		}
		/**
		 * 递归存入子集
		 */		
		private function createTree(_dataList:Object,index:int,parent:TreeVo = null):void
		{
//			if(index > depth)depth = index;//最大深度索引值
			if(treeList[index] == null)treeList[index] = new Vector.<Vector.<TreeVo>>();
			var tvo:TreeVo = addTree(treeList[index],_dataList,parent);
			for each (var obj:Object in _dataList[_itemFiled])
			{
				createTree(obj,index + 1,tvo);
			}
		}		
		
		private function addTree(tVector:Vector.<Vector.<TreeVo>>,data:Object,parent:TreeVo):TreeVo
		{
			if(tVector == null){
				tVector = new Vector.<Vector.<TreeVo>>();
			}
			var tvo:TreeVo = new TreeVo();
			tvo.parent = parent;
			tvo.source = data;
			checkTreeList(tVector,tvo);
			if(parent != null)
			parent.addChild(tvo);//更新子集
			return tvo;
		}
		
		private function checkTreeList(tVector:Vector.<Vector.<TreeVo>>,tvo:TreeVo):void
		{
			if(tVector.length == 0){
				tVector.push(new <TreeVo>[tvo]);
			}else{
				var isPush:Boolean = false;//没有存放
				for each (var tList:Vector.<TreeVo> in tVector) 
				{
					if(tList[0].parent == tvo.parent){
						tList.push(tvo);//父节点一样就存起来
						isPush = true;
						break;
					}
				}
				if(!isPush)tVector.push(new <TreeVo>[tvo]);//没存就新建一个存起来
			}
		}
		
		private var treeGap:int = 80;//纵向间隔
		/**
		 * 显示树的元素
		 */		
		private function showTree():void
		{
			//			for (var i:int = treeList.length - 1; i >= 0; i--) 
			//			{
			//				//从最低层开始 边排列边重新布局子元素
			//				var tVector:Vector.<Vector.<TreeVo>> = treeList[i];
			//			}
			var dIndex:int = 0;//倒序的索引
			var depth:int = treeList.length - 1;//找出最后一个先添加
			var tVector:Vector.<Vector.<TreeVo>> = treeList[depth];
			//访问最后一个
			var count:int = 0;//65 + i * 5,60
			for each (var tList:Vector.<TreeVo> in tVector) 
			{
				for each (var tvo:TreeVo in tList) 
				{
					var bar:TreeBar = createBar(tvo,(85 + dIndex * 10) * Vision.widthScale);
					bar.y = depth * (bar.height + treeGap * Vision.heightScale);
					bar.x = count ++ * (bar.width + (dIndex + 1) * 10 * Vision.widthScale);
				}
			}
			showTreeNode(tVector,--depth);
		}
		
		private function createBar(tvo:TreeVo,w:Number):TreeBar{
			var bar:TreeBar = TreeBar.create(w,60 * Vision.heightScale,_itemColor);
			itemLayer.addChild(bar);
			bar.data = tvo;
			//极左右居中
			bar.label = tvo.source[_labelField];//显示文本
			tvo.bar = bar;
			bar.addEventListener(TouchEvent.TOUCH,onTreeTouch);
			return bar;
		}
		private function onTreeTouch(e:TouchEvent):void
		{
			var treeBar:TreeBar = e.currentTarget as TreeBar;
			var touch:Touch = e.getTouch(treeBar);
			if(treeBar != null && touch != null){//点击事件
				if(touch.phase == TouchPhase.BEGAN){
					//记住必须闪烁一下!!!!
					Vision.fadeInOut(treeBar,.5,1,.3,2);
					select(treeBar.data.source,treeBar);
				}
			}
		}
		
		private function select(source:Object,bar:TreeBar = null):void{
			var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
			ie.item = bar;
			ie.selectedItem = source;
			//					trace(treeBar.data.source[_labelField]);
			dispatchEvent(ie);
		}
		
		//找出父节点后继续添加元件 更新排版
		private function showTreeNode(tVector:Vector.<Vector.<TreeVo>>,depth:int):void
		{
			var dIndex:int = treeList.length - 1 - depth;
			//index应该递减 找上层结构
			var barWidth:Number = (85 + dIndex * 10) * Vision.widthScale;
			for each (var tList:Vector.<TreeVo> in tVector) 
			{
				var tvo:TreeVo = tList[0].parent;//找出父节点
				if(tvo == null)continue;
				var bar:TreeBar = createBar(tvo,barWidth);
				bar.y = depth * (bar.height + treeGap * Vision.heightScale);
				bar.x = (tList[tList.length - 1].bar.x + tList[0].bar.x) / 2;
				//极左右居中
			}
			//寻找上层结构每个父节点(询问还有几个父节点未存储)
			var tdVector:Vector.<Vector.<TreeVo>> = treeList[depth];//这一层结构的节点列表
			var count:int = 0;
			var hasBarList:Vector.<TreeVo> = new Vector.<TreeVo>();
			var lineList:Vector.<TreeVo> = new Vector.<TreeVo>();//线性列表
			for each (tList in tdVector) 
			{
				for each (tvo in tList) 
				{
					tvo.index = count++;//记录索引值
					if(tvo.bar != null){
						hasBarList.push(tvo);
					}
					lineList.push(tvo);
				}
			}
			var hGap:Number = 10 * Vision.widthScale;
			//计算这一行需要的横向间隔
//			var maxDis:Number = 0;//选择最佳错开间隔
			var nowDic:Dictionary = new Dictionary(true);
			var dirtX:Number = 0;//间隔差
			for (var j:int = 0; j < hasBarList.length - 1; j++) 
			{
				var preTvo:TreeVo = hasBarList[j];
				var nowTvo:TreeVo = hasBarList[j + 1];
				//寻找前后节点关系 选择最佳错开间隔
				var dis:Number = nowTvo.bar.x - preTvo.bar.x;//计算距离
				var interIndex:int = nowTvo.index - preTvo.index;
//				if(interIndex <= 0)interIndex = 1;
				var interDis:Number = dis / interIndex;//每隔距离
				if(interDis < barWidth + hGap){//不符合
					dirtX += (barWidth + hGap - interDis) * interIndex;
					//增加移动距离
					interDis = barWidth + hGap;
				}
				nowDic[nowTvo] = dirtX;//记录该节点需要挪动的距离
				//暂时记录坐标 一块更新
				for (var i:int = preTvo.index + 1; i < nowTvo.index; i++) 
				{
					tvo = lineList[i];
					bar = createBar(tvo,barWidth);
					bar.y = depth * (bar.height + treeGap * Vision.heightScale) ;
					var changeX:Number = j == 0 ? 0 : dirtX;
					bar.x = changeX + preTvo.bar.x + interDis * (i - preTvo.index);//
				}
//				//提前添加节点
//				if(maxDis < interDis){
//					maxDis = interDis;
//				}
			}
			//遍历hasBarList计算错开间隔
//			if(maxDis < barWidth + hGap){//不符合 重新排
//				maxDis = barWidth + hGap;
//			}
			var baseX:Number = 0;
			var hasBar:Boolean = false;
			var needX:Number = 0;
			var fTvo:TreeVo = hasBarList[0];
			for each (tvo in lineList) 
			{
				if(tvo.bar == null){
					//第一个没有 只能从第一个开始排
					bar = createBar(tvo,barWidth);
					bar.y = depth * (bar.height + treeGap * Vision.heightScale) ;
					bar.x = baseX + barWidth + hGap;
					if(!hasBar){
						if(tvo.index == 0){//第一个
							needX += bar.x + barWidth + hGap - fTvo.bar.x;
						}else{
							needX += barWidth + hGap;//不是第一个就加一个组件长度
						}
					}
				}else{
					hasBar = true;
					if(tvo.index != 0){
						//重新布局坐标或子坐标
						bar = tvo.bar;
						if(nowDic[tvo] !== undefined){
							dirtX = nowDic[tvo];//baseX + tvo.index * maxDis - bar.x;
							bar.x += needX + dirtX;
							checkBar(tvo,needX + dirtX);
						}else if(needX != 0){//第一个有变动
							bar.x += needX;
							checkBar(tvo,needX);
						}
					}
				}
				baseX = tvo.bar.x;
			}
			if(depth - 1 >= 0){
				showTreeNode(tdVector,--depth);//找上一层
			}
		}
		/**
		 * 检查是否更新子实例坐标
		 * @param tvo
		 */		
		private function checkBar(tvo:TreeVo, dirtX:Number):void
		{
			if(dirtX > 1){//变化 > 1 像素 更新子集
				for each (var t:TreeVo in tvo.childs) 
				{
					t.bar.x += dirtX;
					checkBar(t,dirtX);//继续检查子集的子集更新坐标
				}
			}
		}
		/**
		 * 遍历所有的树形节点开始画线
		 */		
		private function showLine():void
		{
			var iHeight:Number = treeGap * Vision.heightScale / 2 + 2 * Vision.heightScale;
			var lineStyle:int = 4;
			for each (var tVector:Vector.<Vector.<TreeVo>> in treeList) 
			{
				for each (var tList:Vector.<TreeVo> in tVector) 
				{
					for each (var tvo:TreeVo in tList) 
					{//如果有父节点 向上画一根
						//如果有子节点 向下画一根
						var bar:TreeBar = tvo.bar;
						if(tvo.parent != null){
							var quad:Quad = createLine(lineStyle * Vision.heightScale,iHeight);
							quad.x = bar.x - quad.width / 2;
							quad.y = bar.y - bar.height / 2 - quad.height;
						}
						if(tvo.childs != null){
							quad = createLine(lineStyle * Vision.heightScale,iHeight);
							quad.x = bar.x - quad.width / 2;
							quad.y = bar.y + bar.height / 2;// + 2 * Vision.heightScale;
						}
					}
					//横向画一根
					if(tList.length > 0){
						var baseX:Number = tList[0].bar.x;//初始坐标
						var baseY:Number = tList[0].bar.y - tList[0].bar.height / 2 - iHeight;
						var dis:Number = tList[tList.length - 1].bar.x - baseX;
						quad = createLine(dis,lineStyle * Vision.heightScale);
						quad.x = baseX - lineStyle * Vision.heightScale / 2;
						quad.y = baseY - quad.height / 2;
					}
				}
			}
		}
		
		private function createLine(w:Number,h:Number):Quad{
			w = Math.ceil(w);
			h = Math.ceil(h);
			var quad:Quad = new Quad(w,h,_itemColor);
//			quad.pivotX = w / 2;
//			quad.pivotY = h / 2;
			lineLayer.addChild(quad);
			return quad;
		}
		
	}
}
import com.manager.Vision;

import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

class TreeVo{
	public var index:int;//记录索引值
	public var parent:TreeVo;//父节点
	public var source:Object;//源生对应的数据
	public var bar:TreeBar;//访问bar的实例
	public var childs:Vector.<TreeVo>;//存放所有的子集
	
	public function addChild(c:TreeVo):void{
		if(childs == null)childs = new Vector.<TreeVo>();
		childs.push(c);
	}
	
}
class TreeBar extends Sprite{
	public static function create(w:Number,h:Number,color:uint = 0):TreeBar{
		var t:TreeBar = new TreeBar();
		t.initFace(w,h,color);
		t.pivotX = w / 2;
		t.pivotY = h / 2;
		//让锚点居中
		return t;
	}
	private var back:Quad;
	private var textField:TextField;
	private function initFace(w:Number,h:Number,color:uint = 0):void{
		back = new Quad(w,h,color);
		addChild(back);
		initLabel(w,h);
	}
	private function initLabel(w:Number,h:Number):void
	{
		textField = new TextField(w,h,"");
		textField.autoScale = true;
		textField.hAlign = HAlign.CENTER;
		textField.vAlign = VAlign.CENTER;
		textField.fontSize = 25 * Vision.heightScale;
		//		textField.y = (h - textField.height) / 2;
		addChild(textField);
		textField.color = 0xFFFFFF;
	}	
	public function get color():uint
	{
		return back.color;
	}
	public function set color(value:uint):void
	{
		back.color = value;
	}
	private var _label:String;
	public function get label():String
	{
		return _label;
	}
	public function set label(value:String):void
	{
		_label = value;
		textField.text = value;
	}
	private var _data:TreeVo;//存储对应的数据vo
	public function get data():TreeVo
	{
		return _data;
	}
	public function set data(value:TreeVo):void
	{
		_data = value;
	}
	
}