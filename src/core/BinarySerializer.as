/**
 * Created by IntelliJ IDEA.
 * User: simi
 * Date: 2/9/12
 * Time: 6:24 PM
 * To change this template use File | Settings | File Templates.
 */
package core {

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;

public class BinarySerializer {
    public function BinarySerializer() {
    }
    public static function serialize(o:Object):ByteArray{
		var ba:ByteArray=new ByteArray();
		ba.writeObject(o);
		return ba;
	}
//	public static function test():void{
//		registerClassAlias("testc1",TestC);
//		registerClassAlias("recta",Rectangle);
//		var s:TestC=new TestC();
//		s.rect=new Rectangle(1,2,3,4);
//		var a:Array=new Array();
//		a.push(s);
//		save(a,"test.dat");
//
//		var o:Object=load("test.dat");
//		var x:Array=o as Array ;
//	s=x[0] as TestC;
//	}
	public static function load(file:File):Object{
		
		// Create a file stream to write stuff to the file.
		var stream:FileStream = new FileStream();

		// Open the file stream.
		stream.open( file, FileMode.READ );
		var data:ByteArray=new ByteArray();
		stream.readBytes(data);
		stream.close();
		data.position=0;
		var o:Object=data.readObject();
		return o;
	}
	public static function save(docPreset:Object, file:File):void{

		
		// Create a file stream to write stuff to the file.
		var stream:FileStream = new FileStream();

		// Open the file stream.
		stream.open( file, FileMode.WRITE );

		stream.writeBytes(serialize(docPreset));

		//save the export options also

		stream.close();

		// Clean up.
		file = null;
		stream = null;
	}
}
}
