package core
{
import flash.events.TimerEvent;
import flash.utils.Timer;

public class TimerUtil
{
	public function TimerUtil()
	{
	}
	public static function callLater(delay:Number,handler:Function,thisH:*,params:Array):void{
		var timer:Timer=new Timer(delay,1);
		timer.addEventListener(TimerEvent.TIMER,myHandler);
		timer.start();
		function myHandler(event:*):void{
			timer.removeEventListener(TimerEvent.TIMER,myHandler);
			timer.stop();
			timer=null;
			handler.apply(thisH,params);
		}
	}
}
}