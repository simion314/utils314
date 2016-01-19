package com.pageone.email {
public class EmailToSend {
    private var _to:Vector.<String>;
    private var _bcc:Vector.<String>;
    private var _message:String;
    private var _subject:String;

    public function EmailToSend(subject:String, message:String, to:Vector.<String>, bcc:Vector.<String>) {
//        if (!subject) {
//            throw new Error("Email subject can't be empty!");
//        }
//        if (!message) {
//            throw new Error("Email message can't be empty!");
//        }
//        const tos:Boolean = to && to.length>0;
//        const bcc_s :Boolean = bcc && bcc.length >0;
//        if(!(tos || bcc_s)){
//            throw new Error("Missing at least one email in To or Bcc field") ;
//        }
        this._subject = subject;
        this._message = message;
        this._to = to;
        this._bcc = bcc;
    }

    public function get to():Vector.<String> {
        return _to;
    }

    public function get bcc():Vector.<String> {
        return _bcc;
    }

    public function get message():String {
        return _message;
    }

    public function get subject():String {
        return _subject;
    }
}
}
