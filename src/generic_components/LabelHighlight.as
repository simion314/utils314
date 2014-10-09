package generic_components
{
	import core.StringUtils;
	import mx.controls.Label;
	import mx.controls.textClasses.TextRange;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	


	
	
	
	public class LabelHighlight extends Label
	{
		private var _textTohighLight:String;
		private var _highlightColor:*="red";
		private var normalColor:*="black";
		private var highlighted:Boolean;
		public function LabelHighlight()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			updateHighLight();
		}
		
		public function get textTohighLight():String
		{
			return _textTohighLight;
		}

		public function set textTohighLight(value:String):void
		{
			if(value!=_textTohighLight){
				_textTohighLight = value;
				highlighted=false;
				updateHighLight();
			}
		}

		public function updateHighLight():void{
			if(!initialized) return;
			removeHighlight();

			if(_textTohighLight==null||_textTohighLight.length<=0)
			{
			
			}
			else{
				var myText:String=text.toLowerCase();
				var sIndex:int=0;
				
				while(true){
					sIndex=myText.indexOf(_textTohighLight,sIndex);
					if(sIndex<0){
						//trace("no more high for "+text+"text to highlight is "+_textTohighLight);
						break;
					}
				
					var tr:TextRange=new TextRange(this,true,sIndex,sIndex+_textTohighLight.length);
					//tr.fontWeight="bold";
					tr.color=_highlightColor;
					
					//trace("adding high for "+text+"at index "+sIndex+"text to highlight is "+_textTohighLight);
					//move the index
					sIndex+=_textTohighLight.length;
				}
				highlighted=true;
				
			}
		}
		
		public function removeHighlight():void
		{
			var tr:TextRange=new TextRange(this,true,0,text.length);
			//tr.fontWeight="normal";
			tr.color=normalColor;
			highlighted=true;
		}
		
		override public function set text(value:String):void
		{
			if(text!=value)
			{
				var val:String=StringUtils.isDateTime(value)
				if(val){
					super.text = val;
					return;
				}
				super.text = value;
				highlighted=false;
				updateHighLight();
			}
		}
		
		
	}
}