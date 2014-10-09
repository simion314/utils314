package generic_components.events
{
	import flash.events.Event;
	
	public class RemoveItemEvent extends Event
	{
		public var data:*;
		public static const REMOVE_ITEM_CLICK:String="REMOVE_ITEM_CLICK";
		public static const ITEM_CLICK:String="ITEM_CLICK";
		public function RemoveItemEvent(type:String, _data:*,bubbles:Boolean=true, cancelable:Boolean=false)
		{
			this.data=_data;
			super(type, bubbles, cancelable);
		}
	}
}