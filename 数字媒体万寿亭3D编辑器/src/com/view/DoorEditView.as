package com.view
{
	import com.utils.StarlingConvert;
	import com.vo.MeshInfoVo;
	
	import feathers.controls.Button;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * 门属性编辑面板
	 */	
	public class DoorEditView extends Sprite
	{
		private var nameLabel:TextField;//文本输入框
		private var posLabel:TextField;//坐标输入框
		
		private var editButton:Button;//编辑数据
		private var deleteButton:Button;//删除数据
		
		private var submitButton:Button;//保存
		private var cancelButton:Button;//取消
		private var back:Quad;//显示背景
		
		public function DoorEditView()
		{
			initFace();
		}
		
		private var editFunc:Function;
		private var deleteFunc:Function;
		private var submitFunc:Function;
		private var cancelFunc:Function;
		public function show(editFunc:Function,deleteFunc:Function,
							 submitFunc:Function,cancelFunc:Function):void{
			this.editFunc = editFunc;
			this.deleteFunc = deleteFunc;
			this.submitFunc = submitFunc;
			this.cancelFunc = cancelFunc;
			showDefault();
			clearInfo();
		}
		
		private function clearInfo():void
		{
			nameLabel.text = posLabel.text = "";//不显示
		}
		
		private var _data:MeshInfoVo;
		public function get data():MeshInfoVo
		{
			return _data;
		}
		public function set data(value:MeshInfoVo):void{
			_data = value;
			if(value != null){
				nameLabel.text = "编号:" + value.number;//商铺编号
				if(value.doorPos != null){//显示坐标
					posLabel.text = "x:" + value.doorPos.x + ",z:" + value.doorPos.z;
				}
			}
		}
		
		public function hide():void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
		}
		
		public function showDefault():void{
			editButton.visible = deleteButton.visible = true;
			submitButton.visible = cancelButton.visible = false;
		}
		
		public function showSubmit():void{
			editButton.visible = deleteButton.visible = false;
			submitButton.visible = cancelButton.visible = true;
		}
		
		private function initFace():void
		{
			var w:Number = 120;
			var eh:Number = 30;
			back = new Quad(w,160,0xCC8404);
			addChild(back);
			
			nameLabel = StarlingConvert.createText(w,eh);
			addChild(nameLabel);
			posLabel = StarlingConvert.createText(w,eh);
			posLabel.y = eh;
			addChild(posLabel);
			
			editButton = StarlingConvert.createButton("编辑");
			addChild(editButton);
			
			deleteButton = StarlingConvert.createButton("删除");
			addChild(deleteButton);
			
			submitButton = StarlingConvert.createButton("保存");
			addChild(submitButton);
			
			cancelButton = StarlingConvert.createButton("取消");
			addChild(cancelButton);
			
			submitButton.y = editButton.y = 2 * (eh + 10);
			cancelButton.y = deleteButton.y = 3 * (eh + 10);
			
			submitButton.x = editButton.x = deleteButton.x = cancelButton.x = 
				(w - 80) / 2;
			
			editButton.addEventListener(TouchEvent.TOUCH,onTouch);
			submitButton.addEventListener(TouchEvent.TOUCH,onTouch);
			deleteButton.addEventListener(TouchEvent.TOUCH,onTouch);
			cancelButton.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				switch(e.currentTarget){
					case editButton:
						if(editFunc != null)editFunc();
						break;
					case deleteButton:
						if(deleteFunc != null)deleteFunc();
						break;
					case submitButton:
						if(submitFunc != null)submitFunc();
						break;
					case cancelButton:
						if(cancelFunc != null)cancelFunc();
						break;
				}
			}
		}
	}
}