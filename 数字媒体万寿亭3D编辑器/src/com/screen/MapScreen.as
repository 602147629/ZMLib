package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.GameModel;
	import com.rendener.AgreeButton;
	import com.view.DoorEditView;
	import com.view.FloorEditView;
	import com.view.Game3DView;
	import com.view.GameAreaView;
	import com.view.TipsAlert;
	import com.vo.FloorInfoVo;
	import com.vo.LinkInfoVo;
	import com.vo.MeshInfoVo;
	import com.vo.PointVo;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MapScreen extends Screen implements IMember
	{
		private var container:Sprite;
		private var buttonList:List;//纵向选择类型列表
		private var doorView:DoorEditView;
		private var floorView:FloorEditView;
		
		override protected function initialize():void
		{
			container = new Sprite();
			addChild(container);
			container.addEventListener(TouchEvent.TOUCH,onTouch);
			
			createList();
			
			createDoor();
			createFloor();
		}
		
		private function createFloor():void
		{
			floorView = new FloorEditView();
			floorView.x = 10;
			floorView.y = 120;
		}
		
		private function createDoor():void
		{
			doorView = new DoorEditView();
			doorView.x = 10;
			doorView.y = 120;
		}
		
		private var floorId:String;
		private function showFloor():void{
			Game3DView.getInstance().showFloorInfo();
			floorView.show(editFloor,deleteFloor,saveFloor,cancelFloor);
			container.addChild(floorView);
			Game3DView.getInstance().addFloorClick(onFloorMesh);
			floorId = null;
		}
		private function hideFloor():void{
			Game3DView.getInstance().hideFloorInfo();
			floorView.hide();
			floorId = linkId = null;
			Game3DView.getInstance().addFloorClick(null);
		}
		
		private var linkId:String;
		private function showLinks():void{
			Game3DView.getInstance().showLinkInfo();
			floorView.show(editLink,deleteLink,saveLink,cancelLink);
			container.addChild(floorView);
			Game3DView.getInstance().addFloorClick(onLinkMesh);
			linkId = null;
		}
		
		private function cancelLink():void
		{
			floorView.showDefault();
			Game3DView.getInstance().resetLink();//坐标重新回到原来位置上
		}
		
		private function saveLink():void
		{
			var lvo:LinkInfoVo = GameModel.getLinkInfo(linkId,linkArea);
			if(lvo != null){
				var lp:PointVo = Game3DView.getInstance().floorPoint;
				if(lp == null){
					TipsAlert.show(Vision.stage,"没移动没有保存定位数据");
				}else{
					lvo.addFloorPos(lp.x,lp.z,lp.area);//更新通道坐标
				}
				var linkPos:PointVo = lvo.postion;
				if(floorView.floorId == ''){
					TipsAlert.show(Vision.stage,"楼道id不能为空");
				}else{
					lvo.id = floorView.floorId;
					GameModel.updateLinkInfo(lvo.id,linkPos.x,linkPos.z,linkArea);//更新id默认最大值
				}
				floorView.showDefault();
//				Game3DView.getInstance().doMapSearch(linkPos.x,linkPos.z,linkPos.area);
				//不需要显示寻路
				Game3DView.getInstance().resetLink();
			}
		}
		
		private function deleteLink():void
		{
			if(linkId == null){
				TipsAlert.show(Vision.stage,"没有选中任何通道数据，无法删除");
				return;
			}
			GameModel.removeLink(linkId,linkArea);
			Game3DView.getInstance().removeLink(linkId,linkArea);
			floorView.data = null;
			linkId = null;
		}
		
		private function editLink():void
		{
			if(linkId == null){
				TipsAlert.show(Vision.stage,"没有选中任何关节点数据，无法编辑");
				return;
			}
			floorView.showSubmit();
			Game3DView.getInstance().editLinkInfo(linkId,linkArea);
		}
		
		private function onFloorMesh(nameId:String):void
		{
			floorId = nameId;
			var fvo:FloorInfoVo = GameModel.getFloorInfo(nameId);
			floorView.showDefault();
			floorView.data = fvo;//显示楼道数据
			if(fvo != null && fvo.postion != null){
				var floorPos:PointVo = fvo.postion;
				Game3DView.getInstance().doMapSearch(floorPos.x,floorPos.z,floorPos.area);
				//显示寻路
			}
		}
		
		private var linkArea:int;
		private function onLinkMesh(id:String,area:int):void{
			linkId = id;
			linkArea = area;
			var lvo:LinkInfoVo = GameModel.getLinkInfo(id,area);
			floorView.showDefault();
			floorView.data = lvo;//显示楼道数据
		}
		
		private function cancelFloor():void
		{
			floorView.showDefault();
			Game3DView.getInstance().resetFloor();//坐标重新回到原来位置上
		}
		
		private function saveFloor():void
		{
			var fvo:FloorInfoVo = GameModel.getFloorInfo(floorId);
			if(fvo != null){
				var fp:PointVo = Game3DView.getInstance().floorPoint;
				if(fp == null){
					TipsAlert.show(Vision.stage,"没有移动没有保存定位数据");
				}else{
					fvo.addFloorPos(fp.x,fp.z,fp.area);//更新通道坐标
				}
				if(floorView.floorId == ''){
					TipsAlert.show(Vision.stage,"楼道id不能为空");
				}else{
					fvo.id = floorView.floorId;
					GameModel.updateFloorId(fvo.id);//更新id默认最大值
				}
				floorView.showDefault();
				var floorPos:PointVo = fvo.postion;
				Game3DView.getInstance().doMapSearch(floorPos.x,floorPos.z,floorPos.area);
				//显示寻路
				Game3DView.getInstance().resetFloor();
			}
		}
		
		private function deleteFloor():void
		{
			if(floorId == null){
				TipsAlert.show(Vision.stage,"没有选中任何通道数据，无法删除");
				return;
			}
			GameModel.removeFloor(floorId);
			Game3DView.getInstance().removeFloor(floorId);
			floorView.data = null;
			floorId = null;
		}
		
		private function editFloor():void
		{
			if(floorId == null){
				TipsAlert.show(Vision.stage,"没有选中任何通道数据，无法编辑");
				return;
			}
			floorView.showSubmit();
			Game3DView.getInstance().editFloorInfo(floorId);
		}
		
		private function showDoor():void{
			Game3DView.getInstance().hideNodePlane();
			doorView.show(editDoor,deleteDoor,saveDoor,cancelDoor);
			container.addChild(doorView);
			Game3DView.getInstance().addMeshClick(onDoorMesh);
		}
		
		private function hideDoor():void{
			Game3DView.getInstance().showNodePlane();
			doorView.hide();
			Game3DView.getInstance().addMeshClick(null);
			meshName = null;
		}
		/**
		 * 保存门的数据
		 */		
		private function saveDoor():void{
			var ivo:MeshInfoVo = GameModel.getMeshInfo(meshName);
			if(ivo != null){
				var newPos:PointVo = Game3DView.getInstance().doorPoint;
				if(newPos == null){
					TipsAlert.show(Vision.stage,"对不起，请先点击场景设置门坐标");
					return;
				}
				ivo.addDoorPos(newPos.x,newPos.z,newPos.area);
				doorView.showDefault();
				Game3DView.getInstance().hideNodePlane();
				Game3DView.getInstance().resetDoor();//坐标重新回到原来位置上
				Game3DView.getInstance().doMapSearch(newPos.x,newPos.z,newPos.area);
				//显示寻路
			}
		}
		
		private function resumeDoor():void{
			doorView.showDefault();//重新更新视图
			Game3DView.getInstance().hideNodePlane();
		}
		
		private function cancelDoor():void
		{
			resumeDoor();
			Game3DView.getInstance().resetDoor();//坐标重新回到原来位置上
		}
		
		private function deleteDoor():void
		{
			if(meshName == null){
				TipsAlert.show(Vision.stage,"未点击任何商铺！！！");
				return;
			}
			TipsAlert.show(Vision.stage,"门数据暂时不能删除");
		}
		
		private function editDoor():void
		{
			if(meshName == null){
				TipsAlert.show(Vision.stage,"未点击任何商铺！！！");
				return;
			}
			doorView.showSubmit();//显示保存功能
			Game3DView.getInstance().showNodePlane();//显示交互层
		}
		
		private function createList():void
		{
			buttonList = new List();
			buttonList.itemRendererType = AgreeButton;
			var layout:HorizontalLayout = new HorizontalLayout();//布局
			layout.horizontalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			var gap:Number = 2;
			layout.gap = gap * Vision.widthScale;
			buttonList.layout = layout;
			buttonList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			buttonList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//纵向滑动
			container.addChild(buttonList);
			
			var itemWidth:Number = 62;
			var itemHeight:Number = 30;
			buttonList.height = itemHeight;
			buttonList.width = (itemWidth + gap) * GameModel.MAP_DATA.length;
			
			for each (var obj:Object in GameModel.MAP_DATA) 
			{
				obj.width = itemWidth;
				obj.height = itemHeight;
				obj.defaultColor = 0x373f42;
				obj.fontSize = 20;
			}
			buttonList.dataProvider = new ListCollection(GameModel.MAP_DATA);
			buttonList.addEventListener(Event.CHANGE,onChange);
			
			//对齐容器坐标
			buttonList.x = (Vision.senceWidth - buttonList.width) / 2;
			buttonList.y = Vision.senceHeight - itemHeight - 10 - owner.y;
		}
		
		private function onChange(e:Event):void
		{
			var tid:int = buttonList.selectedItem.typeID;
			if(tid != GameModel.MAP_TYPE_DOOR){
				hideDoor();
			}else{
				showDoor();
			}
			hideFloor();
			if(tid == GameModel.MAP_TYPE_FLOOR){
				showFloor();
			}else if(tid == GameModel.MAP_TYPE_LINK){
				showLinks();
			}
			Game3DView.getInstance().setMapType(tid);
		}
		private var meshName:String;
		/**
		 * 商铺数据
		 */		
		private function onDoorMesh(nameId:String):void
		{
			meshName = nameId;
			var ivo:MeshInfoVo = GameModel.getMeshInfo(meshName);
			doorView.data = ivo;//显示商铺数据
			if(ivo != null && ivo.doorPos != null){
				var doorPos:PointVo = ivo.doorPos;
				Game3DView.getInstance().doMapSearch(doorPos.x,doorPos.z,doorPos.area);
				//显示寻路
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null){
				if(touch.phase == TouchPhase.BEGAN){
					switch(e.currentTarget){
						case container:
							Game3DView.getInstance().enabled = false;
							e.stopPropagation();
							Vision.staringStage.addEventListener(TouchEvent.TOUCH,onTouch);
							break;
						case Vision.staringStage:
							Game3DView.getInstance().enabled = true;
							Vision.staringStage.removeEventListener(TouchEvent.TOUCH,onTouch);
							break;
					}
				}else if(touch.phase == TouchPhase.ENDED){
					switch(e.currentTarget){
						case Vision.staringStage:
							Game3DView.getInstance().enabled = true;
							Vision.staringStage.removeEventListener(TouchEvent.TOUCH,onTouch);
							break;
					}
				}
			}
		}
		
		private function onRemove(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			Game3DView.getInstance().hideMap();
			GameAreaView.getInstance().hide();
		}	
		
		public function setRemoteParams(id:int,typeID:String):void
		{
			Game3DView.getInstance().showMap();
			addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			buttonList.selectedIndex = 0;//默认选中第一项
			GameAreaView.getInstance().show();
		}
		
		public function set memberData(obj:Object):void
		{
		}
		
		
		
		
		
	}
}