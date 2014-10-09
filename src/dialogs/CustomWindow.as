package dialogs
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerComponent;
	
	import spark.components.Window;
	
	public class CustomWindow extends Window
	{
		public var canceled:Boolean=false;
		public var prevent_ESC_cacelDialog:Boolean=false;
		public var focuseThisOnCreate:IFocusManagerComponent;
		public function CustomWindow()
		{
			super();
			showStatusBar=false;
			this.addEventListener(KeyboardEvent.KEY_DOWN,onLeyDown);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			this.setFocus();
			if(focuseThisOnCreate){
				this.focusManager.setFocus(focuseThisOnCreate);
			}
			
		}
		
		protected function onLeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.W&&prevent_ESC_cacelDialog==false){
				if(event.commandKey||event.controlKey)
				{
					canceled=true;
					close();
				}
			}
		}
	}
}