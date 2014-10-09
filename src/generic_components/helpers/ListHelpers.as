package generic_components.helpers
{
import mx.core.IFactory;

import spark.components.List;

public class ListHelpers
{
	public function ListHelpers()
	{
	}
	public static function invalidateListRenderer(myList:List):void{
		var _itemRenderer:IFactory = myList.itemRenderer;
		myList.itemRenderer = null;
		myList.itemRenderer = _itemRenderer;
	}
}
}