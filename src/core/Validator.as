/**
 * Created by IntelliJ IDEA.
 * User: simi
 * Date: 2/7/12
 * Time: 12:49 PM
 * To change this template use File | Settings | File Templates.
 */
package core {
public class Validator {
    public function Validator() {
    }

    public static function validateEmail(emailAddress:String):Boolean {
        var emailExpression:RegExp = /^[\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
        if (emailAddress.match(emailExpression) == null) {
            return false;
        }
        else {
            return true;
        }
    }
}
}
