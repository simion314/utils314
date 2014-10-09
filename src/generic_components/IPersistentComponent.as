package generic_components
{
	import core.UI_PreferencesStore;

	public interface IPersistentComponent
	{
		function saveState(manager:UI_PreferencesStore):void;
		function loadState(manager:UI_PreferencesStore):void;
	}
}