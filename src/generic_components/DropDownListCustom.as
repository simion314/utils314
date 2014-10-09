package generic_components
{
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import spark.components.DropDownList;
	
	public class DropDownListCustom extends DropDownList
	{
		private var _typedStr:String="";
		private var _lastTime:int;
		public function DropDownListCustom()
		{
			super();
		}
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			
			if ((event.keyCode >= 65 && event.keyCode<=90) || 
				(event.keyCode >= 48 && event.keyCode<=57) ||
				(event.keyCode >= 100 && event.keyCode<=122)
				&&dataProvider&&dataProvider.length>0
			){
				var currenTime:int=flash.utils.getTimer();
				if(currenTime-this._lastTime>1000){
					_typedStr=String.fromCharCode(event.charCode);
				}else
					_typedStr+=String.fromCharCode(event.charCode);
				this._lastTime=currenTime;
				
				var itemIndex:int = findItem( this.selectedIndex);
				if (itemIndex != -1){
					this.selectedIndex = itemIndex;
					this.ensureIndexIsVisible(itemIndex);
					event.preventDefault();
				}
			}
			else	
				super.keyDownHandler(event);
		}
		
		
		private function findItem(start:int ): int {
			if(start<0) start=0;
			for(var i:int=start;i<this.dataProvider.length;i++){
				var item:*=dataProvider.getItemAt(i);
				var label:String=itemToLabel(item).toLowerCase();
				if(label.indexOf(_typedStr)==0)
					return i;
			}
			var index:int;
			if(start>0)
			{
				index= findItem(0);
				if(index>=0)
					return index;
			}
			if(_typedStr.length>1)
			{
				_typedStr=_typedStr.charAt(_typedStr.length-1);
				index= findItem(0);
				if(index>=0)
					return index;
			}
			this.selectedIndex=-1;
			_typedStr="";
			return -1;
		}
	}
}