package core.net
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	
	public class DownloadEvent extends Event
	{
		public static const DOWNLOAD_COMPLETE:String = "DownloadComplete";
		
		public var url:String;
		public var file:File;
		
		public function DownloadEvent(type:String, url:String, file:File)
		{
			super(type, true);
			this.url = url;
			this.file = file;
		}
		
		override public function toString():String{
			return super.toString() + ": "+ url + " -> "+file.url;
		}
	}
}