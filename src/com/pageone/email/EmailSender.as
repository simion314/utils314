/**
 * Created by Geronimo on 1/7/16.
 */
package com.pageone.email {
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.navigateToURL;

public class EmailSender {
    public function EmailSender() {

    }

    public static function sendEmail(email:EmailToSend, sendMode:String):void {
        switch (sendMode) {
            case SendingMode.GMAIL:
            {
                return gmail(email);
            }
            case SendingMode.MAILTO:
            {
                return mailto(email);
            }
            default:
            {
                throw new Error("Unknown sending mode " + sendMode);
            }
        }
    }

    public static function mailto(email:EmailToSend):void {
        var uv:URLVariables = new URLVariables();
        uv['subject'] = email.subject;
        uv["body"] = email.message;
        var to:String = "";
        if (email.to && email.to.length > 0) {
            to = email.to.join(",");
        }
        if (email.bcc && email.bcc.length > 0) {
            uv['bcc'] = email.bcc.join(",");
        }
        var url:String = "mailto:" + to;
        var urlReq:URLRequest = new URLRequest(url);
        urlReq.data = uv;
        navigateToURL(urlReq);
    }

    public static function gmail(email:EmailToSend):void {
        var url:String = "https://mail.google.com/mail/";
        var uv:URLVariables = new URLVariables();
        uv['view'] = "cm";
        uv['compose'] = 1;
        uv['fs'] = 1;
        uv['su'] = email.subject;
        uv["body"] = email.message;
        if (email.to && email.to.length > 0) {
            uv['to'] = email.to.join(",");
        }
        if (email.bcc && email.bcc.length > 0) {
            uv['bcc'] = email.bcc.join(",");
        }
        var urlReq:URLRequest = new URLRequest(url);
        urlReq.data = uv;
        navigateToURL(urlReq);
    }
}
}
