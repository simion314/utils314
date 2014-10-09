/**
 * Created by Geronimo on 9/22/14.
 */
package core.net {
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.xml.XMLNodeType;

public class HtmlUtil314 {
    private static const removePP:RegExp=/[\\r\\n\\t]/gi;
    public static function htmlEscape(str:String, prettyPrint:Boolean=true):String {
        var str:String=XML(new XMLNode(XMLNodeType.TEXT_NODE, str)).toXMLString();
        if(!prettyPrint) {
            str=str.replace(removePP, "");
        }
        return str;
    }

    public static function htmlUnescape(str:String):String {
        return new XMLDocument(str).firstChild.nodeValue;
    }

    private static const removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");
    public static function stripHtmlTags(myString:String):String{
        return myString.replace(removeHtmlRegExp, "");
    }
}
}
