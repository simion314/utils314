package core.net
{
		import core.Logger;
		
		import flash.events.DataEvent;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.events.OutputProgressEvent;
		import flash.events.ProgressEvent;
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.net.URLRequest;
		import flash.net.URLStream;
		import flash.utils.ByteArray;
		
		public class Downloader extends EventDispatcher
		{
			[Event(name="DownloadComplete", type="com.tatstyappz.net.DownloadEvent")]
			
			private var file:File;
			private var fileStream:FileStream;
			private var url:String;
			private var urlStream:URLStream;
			
			private var waitingForDataToWrite:Boolean = false;
			
			public function Downloader()
			{
				urlStream = new URLStream();
				
				urlStream.addEventListener(Event.OPEN, onOpenEvent);
				urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressEvent); 
				urlStream.addEventListener(Event.COMPLETE, onCompleteEvent);
				urlStream.addEventListener(IOErrorEvent.IO_ERROR, onError);
				
				fileStream = new FileStream();
				fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler)
				
			}
			
			public function download(formUrl:String, toFile:File):void {
				this.url = formUrl;
				this.file = toFile;
				try
				{
					fileStream.open(file, FileMode.WRITE);
					urlStream.load(new URLRequest(url));
				} 
				catch(error:Error) 
				{
					Logger.write("Error downloading file "+error.toString());
				}
				
			}
			
			private function onOpenEvent(event:Event):void {
				waitingForDataToWrite = false;
				
				dispatchEvent(event.clone());
			}
			
			private function onProgressEvent(event:ProgressEvent):void {
				if(waitingForDataToWrite){
					writeToDisk();
					dispatchEvent(event.clone());
				}
			}
			
			private function writeToDisk():void {
				var fileData:ByteArray = new ByteArray();
				urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
				fileStream.writeBytes(fileData,0,fileData.length);
				waitingForDataToWrite = false;
				dispatchEvent(new DataEvent(DataEvent.DATA));
			}
			
			private function writeProgressHandler(evt:OutputProgressEvent):void{
				waitingForDataToWrite = true;
			}
			
			private function onCompleteEvent(event:Event):void {
				if(urlStream.bytesAvailable>0)
					writeToDisk();
				removeListeners();
				fileStream.close();
				
				
				dispatchEvent(event.clone());
				// dispatch additional DownloadEvent
				dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_COMPLETE, url, file));
			}
			private function onError(e:Event):void{
				removeListeners();
			}
			private function removeListeners():void{
				urlStream.removeEventListener(Event.OPEN, onOpenEvent);
				urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent); 
				urlStream.removeEventListener(Event.COMPLETE, onCompleteEvent);
				urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler);
				Logger.write("error downloading file IO Error");
				try{	
					fileStream.close();
				}
				catch(e:Error){
					
				}
				try{
					fileStream.close();
				}
				catch(e:Error){
					this.file.deleteFile();
				}
				
			}
		}
	}