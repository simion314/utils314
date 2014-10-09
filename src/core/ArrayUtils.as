package core
{
public class ArrayUtils
{
	public function ArrayUtils()
	{
	}
	public static function exists(arr:Array,lamda:Function):*{
		if(lamda==null) throw new ArgumentError("lamda is null");
		if(arr ==null) throw new ArgumentError("array is null"); 
		for each (var o:* in arr) 
		{
			if(lamda(o)==true)
				return o;
		}
		return null;
	}
	public static function gapForeach(arr:Array,handler:Function,onDone:Function,delay:int=100):void{
		if(!arr||arr.length==0)
			return;
		var iparForeachndex:int=0;
		var index:int=0;
		applyH();
		function applyH():void{
			handler(arr[index]);
			index++;
			if(index==arr.length)
			{
				if(onDone!=null)
					onDone();
			}
			else
				TimerUtil.callLater(delay,applyH,null,null);
		}
	}
}
}