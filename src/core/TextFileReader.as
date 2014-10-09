package core
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.utils.StringUtil;
	
	public class TextFileReader
	{
		public static function getTextFileContents(f:File):String{
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.READ);
			var text:String=fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return text;
		}
		public static function getNonEmptyLinesFromFile(f:File):Array{
			var text:String=getTextFileContents(f);
			var lines:Array=text.split("\n");
			var res:Array=[];
			for each (var line:String in lines) 
			{
				line=StringUtil.trim(line);
				
				if(line!="")
					res.push(line);
			}	
			return res;
		}
	}
}