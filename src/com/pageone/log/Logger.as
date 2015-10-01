package com.pageone.log {

import flash.events.ErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class Logger {
    public function Logger() {

    }


    private static var f:File;
    private static var e:File;
    private static var stream:FileStream;
    private static var estream:FileStream;
    private static var initialized:Boolean = false;

    public static function initialize(appName:String,appVersion:String,extraDebug:Boolean, extlogfile:String):void {
        f = File.applicationStorageDirectory.resolvePath("log/log.txt");
        stream = new FileStream();
        if (f.exists && f.size > 1024 * 1024 / 5) {
            //var f2:File=new File(prefix + "/log/log-old.txt");
            var f2:File = f.parent.resolvePath("log-old.txt");
            //var str2:FileStream=new FileStream();
            //str2.open(f2, FileMode.WRITE);
            f.moveTo(f2, true);
            if (f.exists)
                f.deleteFile();

        }
        stream.open(f, FileMode.APPEND);
        writeLine("---------------------------------------------------------------");
        writeLine("App start: " + appName + " - " + new Date().toLocaleString());
        writeLine("version " + appVersion);

        if (extraDebug.toString() == "true") {
            e = new File(extlogfile);
            estream = new FileStream();
            estream.open(e, FileMode.APPEND);
        }
        initialized = true;
    }

    public static function clear():void {
        stream.close();
        f.deleteFile();
        stream.open(f, FileMode.APPEND);
    }

    public static function clearExt():void {
        estream.close();
        e.deleteFile();
        estream.open(e, FileMode.APPEND);
    }


    public static function initExt(extlogging:Boolean, extlogfile:String):void {
        if (estream) {
            estream.close();
        }
        if (extlogging.toString() == "true") {
            e = new File(extlogfile);
            estream = new FileStream();
            estream.open(e, FileMode.APPEND);
        }
        else
            estream=null;
    }

    public static function writeExt(data:String):void {
        if (!estream) {
            return;
        }
        try {
            data = data.split("\n").join(File.lineEnding);
            estream.writeUTFBytes(new Date().toLocaleString());
            estream.writeUTFBytes(File.lineEnding);
            estream.writeUTFBytes(data);
            estream.writeUTFBytes(File.lineEnding);
        } catch (e:Error) {
        }
    }

    public static function logError(message:String, error:Error):void {
        writeLine(message + " " + error + " " + error.getStackTrace());
    }

    public static function writeLine(s:String):void {
        try {
            trace(s + "\n");
            stream.writeUTFBytes(s);
            stream.writeUTFBytes(File.lineEnding);
        } catch (e:Error) {
            trace("in logger writeLine "+e);
        }
    }

    public static function writeError(msg:String, e:Error):void {
        var err:String = e.toString() + " " + e.getStackTrace();
        writeTimeLine(msg + " " + err);
    }

    public static function writeErrorEvent(msg:String, e:ErrorEvent):void {
        var err:String = e.toString() + " " + e.toString();
        writeTimeLine(msg + " " + err);
    }
    public static function writeTimeLine(s:String):void {
        try {
            stream.writeUTFBytes(new Date().toLocaleString() + ": " + s);
            stream.writeUTFBytes(File.lineEnding);
        } catch (e:Error) {
        }
    }

    public static function write(s:String):void {
        try {
            stream.writeUTFBytes(s);
        } catch (e:Error) {
        }
    }

    public static function close():void {
        writeLine("App close: " + new Date().toLocaleString());
        stream.close();
    }
}
}
