package com.view
{
	import com.component.AutoScrollText;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.model.FarmRemoteData;
	import com.utils.CacheUtils;
	import com.utils.StarlingLoader;
	import com.vo.AdmanageVo;
	
	import flash.display.DisplayObject;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.bytearray.video.SimpleStageVideo;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class VideoWindow
	{
		private static var videoWindow:VideoWindow;
		public static function getInstance():VideoWindow{
			if(videoWindow == null)videoWindow = new VideoWindow();
			return videoWindow;
		}
		
		public function show():void{
			initFace();
			initData();
		}
		private static var admanageList:Vector.<AdmanageVo>;
		private function initData():void
		{
			if(admanageList == null){
				admanageList = FarmDataBase.getAdmanageList();
			}
			//			var temp:Array = [];
			//			for each (var avo:AdmanageVo in admanageList) 
			//			{
			//				if(avo.mode == AdmanageVo.MODE_VIDEO){
			//					temp.push(avo);
			//				}
			//			}
			if(admanageList.length > 0)
				playSource();
		}
		private var sourceIndex:int;
		private function playSource():void
		{
			var avo:AdmanageVo = admanageList[sourceIndex];
			source = avo.sourceUrl;
			if(avo.mode == AdmanageVo.MODE_VIDEO){
				playVideo(source);
			}else{
				playImage(source);
			}
			if(scrollText != null)scrollText.text = avo.content;
		}
		private var container:Sprite;
		private var back:Quad;
		private var image:Image;
		private static var videoClass:Class = SimpleStageVideo;
		//		private static var _videoType:int;
		public static function set videoType(value:int):void
		{
			if(value == 1){
				videoClass = SimpleStageVideo;
			}else{
				videoClass = Video;
			}
		}
		
		private var video:Object;
		//		private var video:Video;
		//		private var sv:SimpleVideoPlayer;
		private function initFace():void
		{
			if(container == null){
				container = new Sprite();
				
				back = new Quad(Vision.senceWidth,Vision.admanageHeight * Vision.heightScale,0);
				container.addChild(back);
				//(30,20) //1080 570
				var leftPadding:Number = /*3*/0 * Vision.widthScale;
				var topPadding:Number = /*20*/0 * Vision.heightScale;
				
				var w:Number = back.width - leftPadding * 2;
				var h:Number = back.height - topPadding * 2;
				
				image = new Image(Vision.TEXTURE_EMPTY);
				
				image.x = leftPadding;
				image.y = topPadding;
				image.width = w;
				image.height = Vision.VIDEO_HEIGHT * Vision.heightScale;
//				container.addChild(image);
				
				initNet();
				
				//				video = new SimpleStageVideo(w, h);
				//				video = new Video(1104,622);
				//				video = new Video(960, 528);
				video = new videoClass(w, Vision.VIDEO_HEIGHT * Vision.heightScale);
				//				video.x = leftPadding;
				video.y = topPadding;
				video.attachNetStream( _ns );
				
				createExplain();
			}
			Vision.addView(Vision.UI,container);
		}
		
		private var scrollText:AutoScrollText;
		private function createExplain():void
		{
			var w:Number = Vision.senceWidth;
			var h:Number = Vision.EXPLAIN_HEIGHT * Vision.heightScale;
			//			var back:Quad = new Quad(w,h,0);
			//			container.addChild(back);
			
			scrollText = new AutoScrollText(w,h);
			container.addChild(scrollText);
			scrollText.y = Vision.VIDEO_HEIGHT * Vision.heightScale;
			scrollText.fontSize = 36 * Vision.normalScale;
			scrollText.textColor = 0xF5BF21;
			scrollText.minGap = 250 * Vision.widthScale;
			scrollText.scrollSpeed = 5 * Vision.normalScale;
//						scrollText.text = "测试哈哈哈哈哈哈";
//						TimerManager.setIntervalOut(5000,onChange);
		}
		private function onChange():void
		{
			var label:String = "想测试吗？";
			for(var i:int = Math.random() * 20 ; i < 30 ; i ++){
				label += "哈";
			}
			scrollText.text = label;
		}
		
		private function playImage(sourceUrl:String):void
		{
			StarlingLoader.loadImageFile(sourceUrl,true,loadImage);
			showImage();
			if(video != null)video.visible = false;
			startTime();
		}
		
		private function showImage():void
		{
			container.addChild(image);
			if(video is DisplayObject && video.parent == Vision.stage){
				Vision.stage.removeChild(video as DisplayObject);
			}
		}
		
		private function loadImage(t:Texture):void
		{
			image.texture = t;
		}
		private var preTime:Number;
		/**
		 * 开始计时
		 */		
		public function startTime():void{
			preTime = getTimer();
			Vision.stage.addEventListener(Event.ENTER_FRAME,onLoop);
		}
		private static const DELAY_TIME:Number = 6000;//一分钟
		private function onLoop(e:Event):void
		{
			if(getTimer() - preTime > DELAY_TIME){
				Vision.stage.removeEventListener(Event.ENTER_FRAME,onLoop);
				showNext();
			}
		}
		
		private function showNext():void
		{
			if(++sourceIndex > admanageList.length - 1){
				sourceIndex = 0;
			}
			playSource();
		}
		private var source:String;
		public function playVideo(address:String = null):void{
			trace(address);
			CacheUtils.loadByteAndSave(address,FarmRemoteData.address,videoComplete,address);
		}
		
		private function videoComplete(byte:ByteArray,address:String):void
		{
			showVideo();
			var filePath:String = address.slice(FarmRemoteData.address.length);
			var f:File = CacheUtils.fileSavePath;
			f = f.resolvePath(filePath);
			if(f.exists){//表示存在
				//				var sourceUrl:String = f.nativePath;
				var sourceUrl:String = f.url;
				_ns.play(/*"content:/" + */sourceUrl);
				//				var sList:Array = sourceUrl.split("\\");
				//				sourceUrl = sList.join("/");
			}
		}
		
		private function showVideo():void
		{
			if(video is DisplayObject){
				Vision.stage.addChild(video as DisplayObject);
			}
			if(image.parent == container){
				container.removeChild(image);
			}
		}
		//		private function onMetaData(data:Object):void
		//		{
		//			video = new Video(data.width,data.height);
		//			//						addChild(video);
		//			video.attachNetStream(videoStream);
		//			
		////			var tf:TextField = new TextField();
		////			tf.border = true;
		////			tf.background = true;
		//			Vision.stage.addChild(video);
		//			var _duration:Number = data.duration;
		//			trace(_duration);
		////			connectNormal();
		//		}
		private var videoStream:NetStream;
		private function connectNormal():void
		{
			video.attachNetStream(videoStream);
		}
		
		//		private function connect():void{
		//			var ip:String = "192.168.1.130";
		//			FmsNet.start(ip,onConnect,onClose);
		//		}
		//		private function onClose():void
		//		{
		//			FmsNet.restart();//重连
		//		}
		//		private var setMyFMSID:String = "123";
		//		private function onConnect():void
		//		{
		//			var ns:NetStream = FmsNet.receive(setMyFMSID);
		//			//			ns.checkPolicyFile = true;
		//			video.attachNetStream(ns);
		//			Vision.stage.addChild(video);
		//		}
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _nsClient:Object;
		private function initNet():void
		{
			_nsClient = {};
			//			_nsClient["onCuePoint"] = metaDataHandler;
			_nsClient["onMetaData"] = metaDataHandler;
			//			_nsClient["onBWDone"] = onBWDone;
			//			_nsClient["close"] = streamClose;
			
			_nc = new NetConnection();
			_nc.client = _nsClient;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, 		netStatusHandler, false, 0, true);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, 			ioErrorHandler, false, 0, true);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 		asyncErrorHandler, false, 0, true);
			_nc.connect(null);
			
			// NetStream
			_ns = new NetStream(_nc);
			_ns.checkPolicyFile = true;
			
			var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();  
			h264Settings.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_5_1);  
			h264Settings.setMode(960, 528, 20);  
			h264Settings.setQuality(0, 80); 
			
			_ns.videoStreamSettings = h264Settings;
			_ns.client = _nsClient;
			_ns.addEventListener(NetStatusEvent.NET_STATUS, 	netStatusHandler, false, 0, true);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 	asyncErrorHandler, false, 0, true);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, 		ioErrorHandler, false, 0, true);
		}
		private function asyncErrorHandler(event:AsyncErrorEvent): void
		{
		}
		private function metaDataHandler(data:Object = null):void
		{
			trace("视频数据宽度:" + data.width,"视频数据高度:" + data.height);
			//			video.width = data.width;
			//			video.height = data.height;
			//			if(video == null){
			//				video = new videoClass(data.width, data.height);
			//				//				video = new Video(1104,622);
			//				if(video is DisplayObject){
			//					Vision.root.addChild(video as DisplayObject);
			////					Vision.stage.
			//				}
			//			}
			//			video.attachNetStream( _ns );
			video.visible = true;
		}
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			trace("An IOerror occured: "+e.text);
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			trace("A security error occured: "+e.text+" Remember that the FLV must be in the same security sandbox as your SWF.");
		}
		private function onBWDone():void
		{
			//			trace("onBWDone");
		}
		private function streamClose():void
		{
			trace("The stream was closed. Incorrect URL?");
		}
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
			switch (e.info["code"]) {
				case "NetStream.Play.Stop": 
					//this.dispatchEvent( new VideoEvent(VideoEvent.STOP,_netStream, file) ); 
					trace(source + "播放结束,可以播放下一首");
					showNext();
					break;
				case "NetStream.Play.Play":
					//this.dispatchEvent( new VideoEvent(VideoEvent.PLAY,_netStream, file) );
					break;
				case "NetStream.Play.StreamNotFound":
					trace("The file "+ source +" was not found", e);
					break;
				case "NetConnection.Connect.Success":
					trace("Connected to stream", e);
					break;
			}
		}
	}
}