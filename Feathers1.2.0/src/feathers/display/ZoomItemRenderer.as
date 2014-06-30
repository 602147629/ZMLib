package feathers.display
{
	import com.greensock.TweenLite;
	
	import starling.events.Event;

	public class ZoomItemRenderer extends BasicItemRenderer
	{
		public function ZoomItemRenderer()
		{
			super();
		}
		
		protected var normalHeight:Number = 0;
		protected var isOpen:Boolean;//未打开
		protected var duration:Number = .5;//滚动时间
		protected var targetHeight:Number = 0;//目标的高度
		override protected function touchEnd():void{
			if(this.owner != null && this.owner.isScrolling)return;//滑动中不算
			if(!isOpen){
//				var targetHeight:Number = normalHeight + this.index * 10 + 50;
//				if(this.y - this.owner.verticalScrollPosition < 0){//小到顶了
//					TweenLite.to(this.owner,duration,{verticalScrollPosition:this.y});
//					//					this.owner.verticalScrollPosition = this.y;
//				}
				tweenShow();
			}else{
				tweenHide();
			}
		}
		
		private function tweenShow():void
		{
			isOpen = true;
			TweenLite.to(this,duration,{baseHeight:targetHeight,onUpdate:onTimer});
			open();
		}
		
		private function onTimer():void
		{
			this.owner.redraw();
			if(isOpen){//展开状态
				addEventListener(Event.ENTER_FRAME,onNext);
			}else{
				removeEventListener(Event.ENTER_FRAME,onNext);
			}
		}
		
		private function onNext():void
		{
			removeEventListener(Event.ENTER_FRAME,onNext);
			if(this.y + _baseHeight - this.owner.verticalScrollPosition > this.owner.height){
				//					TweenLite.to(this.owner,.1,{verticalScrollPosition:this.y + _baseHeight - this.owner.height});
				this.owner.verticalScrollPosition = this.y + _baseHeight - this.owner.height;
			}
		}
		
		override public function set isSelected(value:Boolean):void
		{
			super.isSelected = value;
			if(!value){
				if(baseHeight != normalHeight){
					tweenHide();
				}
			}
		}
		
		private function tweenHide():void
		{
			isOpen = false;
			TweenLite.to(this,.5,{baseHeight:normalHeight,onUpdate:onTimer});
			close();
		}
		
		protected function open():void
		{
			
		}
		
		protected function close():void
		{
			
		}
		
		protected var _baseHeight:Number = 0;
		public function get baseHeight():Number
		{
			return _baseHeight;
		}
		public function set baseHeight(value:Number):void
		{
			if(isNaN(value)){
				_baseHeight = normalHeight;
			}else{
				_baseHeight = value;
			}
		}
		
		public override function get height():Number{
			return _baseHeight;
		}
	}
}