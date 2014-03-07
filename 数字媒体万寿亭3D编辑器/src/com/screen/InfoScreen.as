package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.GameModel;
	import com.rendener.AgreeButton;
	import com.view.Game3DView;
	import com.view.TipsAlert;
	import com.vo.MeshInfoVo;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	/**
	 * 商户信息编辑
	 */	
	public class InfoScreen extends Screen implements IMember
	{
		//编号:输入框  种类:  门口坐标:(暂定)
//		{id:24,label:"蔬菜",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
//		{id:25,label:"肉类",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
//		{id:26,label:"水产",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
//		{id:27,label:"粮油",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD},
//		{id:28,label:"干货",view:FoodScreen,typeID:FarmDataBase.DATA_FOOD}
		private var container:Sprite;
		private var nameInput:TextInput;//文本输入框
		private var kindList:List;//纵向选择类型列表
		private var deleteButton:Button;//删除数据
		private var submitButton:Button;//保存
		
		override protected function initialize():void
		{
			container = new Sprite();
			addChild(container);
			container.x = 20;
			container.y = 50;
			container.addEventListener(TouchEvent.TOUCH,onTouch);
			
			var back:Quad = new Quad(100,500);
			container.addChild(back);
			
			var label:TextField = new TextField(50,50,"编号");
			label.fontSize = 20;
			label.autoScale = false;
			label.hAlign = HAlign.LEFT;
			container.addChild(label);
			
			nameInput = new TextInput();
			container.addChild(nameInput);
			nameInput.textEditorProperties.fontSize = 20;
			nameInput.textEditorProperties.color = 0xFFFF00;
			nameInput.textEditorProperties.vAlign = VAlign.CENTER;
			nameInput.width = 50;
			nameInput.height = 50;
			nameInput.x = 50;
			var tBack:Quad = new Quad(50,50,0);
			tBack.alpha = .5;
			nameInput.backgroundSkin = tBack;
			
			createList();
			createButtonInfo();
		}
		
		private function createButtonInfo():void
		{
			submitButton = createButton("保存");
			container.addChild(submitButton);
			submitButton.x = (100 - 80) / 2;
			submitButton.y = 420;
			submitButton.addEventListener(TouchEvent.TOUCH,onTouch);
			
			deleteButton = createButton("删除");
			container.addChild(deleteButton);
			deleteButton.x = (100 - 80) / 2;
			deleteButton.y = 460;
			deleteButton.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				switch(e.currentTarget){
					case deleteButton:
						deleteData();
						break;
					case submitButton:
						submit();
						break;
					case container:
//						trace("点中容器");
						Game3DView.getInstance().enabled = false;
						e.stopPropagation();
						Vision.staringStage.addEventListener(TouchEvent.TOUCH,onTouch);
						break;
					case Vision.staringStage:
						Game3DView.getInstance().enabled = true;
						Vision.staringStage.removeEventListener(TouchEvent.TOUCH,onTouch);
						break;
				}
			}
		}
		
		private function deleteData():void
		{
			if(nameInput.text == ""){
				TipsAlert.show(Vision.stage,"请输入商铺编号");
				return;
			}
			if(kindList.selectedItem != null){
			}else{
				TipsAlert.show(Vision.stage,"请选择商铺种类");
			}
			GameModel.removeMeshInfo(meshName);
			Game3DView.getInstance().resetMesh(meshName);
		}
		
		private function createList():void
		{
			kindList = new List();
			kindList.itemRendererType = AgreeButton;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 2;
			layout.gap = gap * Vision.heightScale;
			kindList.layout = layout;
			kindList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			kindList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			//纵向滑动
			container.addChild(kindList);
			
			var itemWidth:Number = 62;
			var itemHeight:Number = 30;
			kindList.y = 60;
			kindList.x = (100 - itemWidth) / 2;
			kindList.width = itemWidth;
			kindList.height = (itemHeight + gap) * 10;//GameModel.KIND_DATA.length;
			
			for each (var obj:Object in GameModel.KIND_DATA) 
			{
				obj.width = itemWidth;
				obj.height = itemHeight;
				obj.defaultColor = 0x373f42;
				obj.fontSize = 20;
			}
			kindList.dataProvider = new ListCollection(GameModel.KIND_DATA);
//			kindList.addEventListener(Event.CHANGE,onKindChange);
		}
		private var meshName:String;
		/**
		 * 商铺深度值
		 */		
		private function onClickMesh(nameId:String):void
		{
			meshName = nameId;
			var ivo:MeshInfoVo = GameModel.getMeshInfo(nameId);
			if(ivo != null){
				nameInput.text = ivo.number;//商铺编号
				kindList.selectedItem = getSelectItem(ivo.attribute);
			}else{
				clear();
			}
		}
		
		private function clear():void{
			nameInput.text = "";
			kindList.selectedIndex = -1;
		}
		//保存数据
		private function submit():void
		{
			if(nameInput.text == ""){
				TipsAlert.show(Vision.stage,"请输入商铺编号");
				return;
			}
			if(kindList.selectedItem != null){
				var ivo:MeshInfoVo = 
					GameModel.updateMeshInfo(meshName,nameInput.text,kindList.selectedItem.attribute);
				Game3DView.getInstance().updateMesh(ivo,kindList.selectedItem.selectColor);
			}else{
				TipsAlert.show(Vision.stage,"请选择商铺种类");
			}
		}
		
		public static function getSelectColor(attribute:int):uint{
			var obj:Object = getSelectItem(attribute);
			if(obj == null)return 1;
			return obj.selectColor;
		}
		
		private static function getSelectItem(attribute:int):Object
		{
			for each (var kObj:Object in GameModel.KIND_DATA) 
			{
				if(attribute == kObj.attribute){
					return kObj;
				}
			}
			return null;
		}
		
		public function setRemoteParams(id:int, typeID:String):void
		{
			Game3DView.getInstance().addMeshClick(onClickMesh);
			Game3DView.getInstance().hideNodePlane();
			clear();
		}
		
		public function set memberData(obj:Object):void
		{
		}
		
		private function createButton(label:String = null):Button{
			var upTx:Image = new Image(Vision.createRoundRect(80,30,0x5d5d5d));
			var downTx:Image = new Image(Vision.createRoundRect(80,30,0x5d5d5d));
			downTx.color = 0x8d8d8d;
			var tf:TextField = new TextField(upTx.width,upTx.height,label);
			tf.color = 0xFFFFFF;
			tf.fontSize = 20;
			var btn:Button = new Button();
			btn.upSkin = btn.hoverSkin = upTx;
			btn.downSkin = downTx;
			btn.addChild(tf);
			return btn;
		}
		
		
	}
}