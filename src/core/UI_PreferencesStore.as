package core
{
	import flash.events.Event;
	
	import generic_components.IPersistentComponent;

	public class UI_PreferencesStore extends PreferenceStore
	{
		private static  var _instance:UI_PreferencesStore=null;
		private var _components:Vector.<IPersistentComponent>=new Vector.<IPersistentComponent>();
		public function addComponent(cmp:IPersistentComponent):void{
			_components.push(cmp);
			try
			{
				cmp.loadState(this);
			} 
			catch(err:Error) 
			{
				Logger.write("error loading component state "+cmp+" "+err.message);
			}
		}
		public function UI_PreferencesStore(file:String=null)
		{
			if(file==null||file=="")
				file="ui_preferences.obj";
		
			super(file);
			load();
		
		}
		public function saveAll(o:*=null):void{
			for (var i:int = 0; i < _components.length; i++) 
			{
				try
				{
					_components[i].saveState(this);
				} 
				catch(error:Error) 
				{
					trace("error saving state "+error);
				}
			}
			
		}
		public static  function get Instance():UI_PreferencesStore{
			if(_instance==null)
				_instance=new UI_PreferencesStore();
			return _instance;
			
	}
}
}