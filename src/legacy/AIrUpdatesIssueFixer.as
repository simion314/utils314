/**
 * Created by Geronimo on 10/28/14.
 */
package legacy {
import adobe.utils.ProductManager;

import flash.filesystem.File;
import flash.system.Capabilities;

import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;

import spark.components.WindowedApplication;

public class AIrUpdatesIssueFixer {

    public static function fromNewToOldPath(file:File):File{
        if (Capabilities.os.indexOf("Mac") < 0) {
            return null;
        }
        if (file.nativePath.indexOf("/Application Support") < 0)
            return null;
        var oldPath:String = file.nativePath.replace("Application Support", "Preferences");
        var oldFile:File = new File(oldPath);
        return oldFile;
    }
    public static function performAppStorageFolderPathChangeFix(continueInit:Function, migrationRestartRequired:String, performMigrationQuestionMessage:String = null):Boolean {
        if (Capabilities.os.indexOf("Mac") < 0) {
            return false;
        }
        var newDir:File = File.applicationStorageDirectory;
        if(newDir.parent.nativePath.indexOf("/Application Support")<0)
            return false;
        var oldPath:String = newDir.nativePath.replace("Application Support", "Preferences");
        var oldDir:File = new File(oldPath);
        if (oldDir.exists == false) {
            return false;
        }

        Alert.show(performMigrationQuestionMessage, "Migration needed", Alert.YES | Alert.NO, null, alertListener, null, Alert.NO);
        return true;

        function alertListener(eventObj:CloseEvent):void {
            if (eventObj.detail == Alert.YES) {
                moveFolder(oldDir, newDir);
                continueInit();
            }
        }

        function moveFolder(oldDir:File, newDir:File):void {
            try {
                var newDirBack:File = new File(newDir.nativePath + "_backup");
                if (newDir.exists)
                    newDir.moveTo(newDirBack, true);
                oldDir.copyTo(newDir, true);
                oldDir.moveTo(oldDir.parent.resolvePath("backup"), true);
                Alert.show(migrationRestartRequired, "Information", 4, null, onClose);
                function onClose(e:*):void {
                    reboot();
                }
            }
            catch (e:Error) {
                Alert.show("Error migrating data files!\n Details: " + e.message);
            }
        }
    }

    private static function reboot():void {
        //THIS IS NOT WORKING

        //requires allowBrowserInvocation to be set to ture in app descriptor
        var app:WindowedApplication = WindowedApplication(FlexGlobals.topLevelApplication);
//        var mgr:ProductManager = new ProductManager("airappinstaller");
//        mgr.launch("-launch " + app.nativeApplication.applicationID + " " + app.nativeApplication.publisherID);
//
        app.close();
    }
}
}
