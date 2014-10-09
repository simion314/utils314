package generic_components
{
	import core.UI_PreferencesStore;
	
	import mx.containers.HDividedBox;
	
	public class HDividerPersistent extends HDividedBox implements IPersistentComponent
	{
		public function HDividerPersistent()
		{
			super();
		}
		public function saveState(manager:UI_PreferencesStore):void
		{
			var n:int=this.numDividers;
			var val:String;
			for (var i:int = 0; i < n; i++) 
			{
				if(val)val+=",";
				else val="";
				val+=this.getDividerAt(i).x;
			}
			manager.setValue(id,val);
			
		}
		
		public function loadState(manager:UI_PreferencesStore):void
		{
			var val:String=manager.getValue(id);
			if(!val)return;
			var a:Array=val.split(",");
			var n:int=this.numDividers;
			for (var i:int = 0; i < n; i++) 
			{
				this.getDividerAt(i).x=Number(a[i]);
				trace("loading div id "+id+" "+a[i]);
			}
		}
	}
}