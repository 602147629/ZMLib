package com.view
{
	import com.component.ImageFadeView;
	import com.greensock.TweenLite;
	import com.manager.Vision;
	
	import starling.display.Quad;
	import starling.display.Sprite;

	public class LicenseView
	{
		private static var licenseView:LicenseView;
		public static function getInstance():LicenseView{
			if(licenseView == null)licenseView = new LicenseView();
			return licenseView;
		}
		
		public function show():void{
			initFace();
			tweenShow();
		}
		public function hide():void{
			if(container != null){
				tweenHide();
			}
		}
		private function tweenShow():void
		{
			TweenLite.to(container,.3,{alpha:1});
		}
		private function tweenHide():void
		{
			TweenLite.to(container,.3,{alpha:0,onComplete:tweenHideOver});
		}
		private function tweenHideOver():void{
			Vision.removeView(Vision.MAIN,container);
		}
		public function set dataProvider(value:Object):void
		{
			imageView.dataProvider = value;
		}
		private var container:Sprite;
		private var imageView:ImageFadeView;
		private function initFace():void
		{
			if(container == null){
				container = new Sprite();
				
				var back:Quad = new Quad(1035 * Vision.widthScale,770 * Vision.heightScale,0xCCCCCC);
				container.addChild(back);
				back.x = (Vision.senceWidth - back.width) / 2;
				back.y = (Vision.admanageHeight + 40) * Vision.heightScale;
				
				var w:Number = 1000;
				var h:Number = 685;
				imageView = new ImageFadeView(w * Vision.widthScale,h * Vision.heightScale);
				imageView.x = back.x + back.width / 2 - imageView.width / 2;
				imageView.y = back.y + back.height / 2 - imageView.height / 2;
				imageView.hideTitle = true;
				imageView.dragEnabled = true;//可以用手势拖动
				container.addChild(imageView);
				
				container.alpha = 0;
			}
			Vision.addView(Vision.MAIN,container);
		}
		
	}
}