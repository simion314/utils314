package core
{
import crypto.Simplecrypt;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public   class Logger
{
	public static var timeStamp:Boolean=false;
	private  static  var stream:FileStream;
	//private static var _init:Boolean=false;
	private static const encrypt:Boolean=true;
	public  static function init():Boolean
	{
		var file:File;
		file=File.applicationStorageDirectory.resolvePath("log.txt");
		
		stream = new FileStream();
		stream.open( file, FileMode.WRITE );
		
		return true;
	}
	public static function  write(s:String):void{
		if(!stream) return;
		if(timeStamp)
			s=new Date().toLocaleTimeString()+" : "+s;
		var delimitor:String="\n";
		trace(s);
		if(encrypt)
		{
			
			var lines:Array=s.split(File.lineEnding);
			var res:String="";
			for each (var line:String	 in lines) 
			{
				line=trim(line);
				var enc:String=Simplecrypt.encrypt(line,"gcbe{about}314");
				var dec:String=Simplecrypt.decrypt(enc,"gcbe{about}314");
				if(dec!=line){
					throw new Error("log enc err");
				}
				res+=enc;
				res+=delimitor;
			}
			s=res;
		}
		
		stream.writeUTFBytes(s);
		stream.writeUTFBytes(delimitor);
		
		//			stream.writeUTFBytes(s);
		//			stream.writeUTFBytes("{}");
		
		function trim(s:String):String {
			return s ? s.replace(/^\s+|\s+$/gs, '') : "";
		}
	}
	
	public static function close():void{
		stream.close();
	}
	
	public static function getContent():String
	{
		var data:String;
		if(stream){
			try
			{
				close();
				var file:File;
				file=File.applicationStorageDirectory.resolvePath("GCBE_DEBUG.txt");
				
				stream = new FileStream();
				stream.open( file, FileMode.READ );
				data=stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				//reopen the logger
				init();
			} 
			catch(error:Error) 
			{
				data+="Error reading log "+error;
			}
		}else{
			data="Logger is off";
		}
		return data;
	}
}
}