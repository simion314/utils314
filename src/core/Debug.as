package core
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Debug
	{
		public function Debug()
		{
		}
		public static function get debugFile():File{
			return File.applicationDirectory.resolvePath('META-INF/AIR/debug');
		}
		public static function get debugEnabled():Boolean{
			return debugFile.exists;
		}
		public static function set debugEnabled(value:Boolean):void{
			if(value){
				if(debugEnabled)
					return;
				var stream:FileStream=new FileStream();
				try{
					stream.open(debugFile,FileMode.WRITE);
					stream.writeUTFBytes("//for debuging ,deleting this will make the app a little faster but bug reports will be missing importaant information");
					stream.close();
				}
				catch(e:Error){
					Logger.write("Unable to create the debug file to flag AIR to run app in debug mode");
					return;
				}
				Logger.write("debug mode enabled, application needsrestarting ");
			}
			else
			{
				if(!debugEnabled)
					return;
				try
				{
					debugFile.deleteFile();
				}
				catch(e:Error){
					Logger.write("Unable to delete the debug file to flag AIR to not run app in debug mode");
					return;
				}
				Logger.write("debug mode disabled, application needsrestarting ");
				
			}
		}
	}
}