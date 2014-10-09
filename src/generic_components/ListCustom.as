package generic_components
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import mx.core.DragSource;
	import mx.core.IFactory;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.List;

	[Event(name="dragDropComplete", type="flash.events.Event")]
	
	public class ListCustom extends List
	{
		private var _typedStr:String="";
		private var _lastTime:int;
		private var _textTohighLight:String="";
		public static const DRAG_DROP_COMPLETED:String="dragDropComplete";
		
		
		
		override protected function dragEnterHandler(event:DragEvent):void
		{
			if(event.relatedObject != this)
			{
				event.preventDefault();
				return;
			}
			super.dragEnterHandler(event);
		}
		
		
		
		override protected function dragCompleteHandler(event:DragEvent):void
		{//prevent Cltr/Cmd click copy
			
			if(event.action != DragManager.MOVE)
			{
				event.preventDefault();
				return;
			}
			if(event.relatedObject != this)
			{
				event.preventDefault();
				return;
			}
			super.dragCompleteHandler(event);
		}
		
		
		public function ListCustom()
		{
			super();
			//addEventListener(KeyboardEvent.KEY_DOWN, interceptKey,true);
		}
		
		override protected function dragDropHandler(event:DragEvent):void
		{
			// TODO Auto Generated method stub
			super.dragDropHandler(event);
			callLater(function():void{dispatchEvent(new Event(DRAG_DROP_COMPLETED))});
		}
		
		
		public function get textTohighLight():String
		{
			return _textTohighLight;
		}

		public function set textTohighLight(value:String):void
		{
			
			_textTohighLight = value;
			invalidateList();
		}
		public function invalidateList():void
		{
			var _itemRenderer:IFactory = itemRenderer;
			itemRenderer = null;
			itemRenderer = _itemRenderer;
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
				}else{
					
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