package feathers.display
{
	import com.greensock.TweenLite;
	
	import starling.events.Event;

	public class FadeItemRenderer extends BasicItemRenderer
	{
		public function FadeItemRenderer()
		{
			super();
			this.alpha = 0;//默认透明
		}
		
		private function checkTweenShow():void
		{
			if(this.owner != null && this.owner.isScrolling){
				resume();
			}
		}
		
		private function resume():void
		{
			this.alpha = 1;
			TweenLite.killTweensOf(this);
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			if(dataInvalid)
			{
				this.commitData();
				checkTweenShow();
			}
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			if(dataInvalid || sizeInvalid)
			{
				this.layout();
			}
		}
		
		override protected function addToStageHandler(event:Event):void
		{
			if(this.owner != null && this.owner.verticalScrollPosition == 0
				&& this.owner.horizontalScrollPosition == 0){//在原始位置
				tweenShow();
			}else{
				resume();
			}
			super.addToStageHandler(event);
		}
		
		private function tweenShow():void
		{
			if(this.alpha != 1)TweenLite.to(this,.3,{delay:.2 + .1 * this._index,alpha:1});
		}
		
		override protected function removedFromStageHandler(event:Event):void
		{
			super.removedFromStageHandler(event);
			this.alpha = 0;
			//			this._index = -1;
		}
		
		public override function set index(value:int):void
		{
			if(this._index != value)
			{
				super.index = value;
				tweenShow();
			}
		}
		
	}
}