package generic_components
{
	import core.UI_PreferencesStore;
	
	import mx.containers.VDividedBox;
	
	public class VDivideBoxPersistant extends VDividedBox implements IPersistentComponent
	{
		public function VDivideBoxPersistant()
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
				val+=this.getDividerAt(i).y;
			}
			manager.setValue(name,val);
			
		}
		
		public function loadState(manager:UI_PreferencesStore):void
		{
			var val:String=manager.getValue(name);
			if(!val)return;
			var a:Array=val.split(",");
			var n:int=this.numDividers;
			for (var i:int = 0; i < n; i++) 
			{
				this.getDividerAt(i).y=Number(a[i]);
			}
		}
	}
}