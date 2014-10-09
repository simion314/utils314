/**
 * Created by Geronimo on 10/9/14.
 */
package core {
public class StringBuffer {
    public function  StringBuffer(string:String=""){
        add(string);
    }
    private var buffer:Array = new Array();

    public function add(str:String):void {
        for (var i:Number = 0; i < str.length; i++) {
            buffer.push(str.charCodeAt(i));
        }
    }
    public function addChar(char:Number):void {
        buffer.push(char);
    }

    public function toString():String {
        return String.fromCharCode.apply(this, buffer);
    }
}
}
