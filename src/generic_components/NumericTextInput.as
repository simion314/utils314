package generic_components
{
import core.MathAux;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;

import flashx.textLayout.operations.CutOperation;
import flashx.textLayout.operations.DeleteTextOperation;
import flashx.textLayout.operations.FlowOperation;
import flashx.textLayout.operations.PasteOperation;

import mathematics.Parser;

import mx.events.FlexEvent;

import spark.components.TextInput;
import spark.events.TextOperationEvent;


    [Event(name="valueChanged", type="spark.events.TextOperationEvent")]
	public final class NumericTextInput extends TextInput
	{
		public var supportMathExpresions:Boolean=true;
		private static const parser:Parser=new Parser(["x"]);
		public static const VALUE_CHANGED:String="valueChanged";
		//public var numericValue:Numeric=0;
		private var _onlyWholeNumbers:Boolean=false;
		private var _oldValue:Number =0;
		private var _readOnlyBgColor:String="0xb2b2b2";
		//private var _invalidBgColor:String="0xff0000";
		private var _disabledbgColor:String="0xb2b2b2";//"0x7c7c7c";
		private var _bgColor:String="0xffffff";
		private var _mathChars:Array=['+','-','/','*','(',')','^'];
		private var _mustUpdateText:Boolean=false;
		private static var rgx:RegExp = /^\d|\.|-$/;
		private static const roundTo3Digits:Boolean=true;
		public static var delayMsec:uint=300;
		private var _delayed:Boolean=false;
		private var _timer:Timer=null;
		public var incrementStepValue:Number=1;
		private var _textMode:Boolean=false;
		public static const INCHES_INCREMENT_STEP:Number=0.062;
		public function NumericTextInput()
		{
			super();
			this.addEventListener(TextOperationEvent.CHANGE,onTextInput);
			this.addEventListener(TextOperationEvent.CHANGING,onPosibleTextInput);
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyPress);
			this.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			this.doubleClickEnabled=true;
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,makeReadOnly);
		}

		public function get textMode():Boolean
		{
			return _textMode;
		}

		public function set textMode(value:Boolean):void
		{
			_textMode = value;
		}

		private function makeReadOnly(e:Event):void{
			if(this.editable==false)
				editable=false;
		}
		public function get delayed():Boolean
		{
			return _delayed;
		}
		
		public function set delayed(value:Boolean):void
		{
			_delayed = value;
			if(_delayed)
			{
				if(_timer==null){
					_timer=new Timer(delayMsec,1);
					_timer.addEventListener(TimerEvent.TIMER,fireUpdateEvent);
				}
			}
		}
		
		public function onTextInput(event:TextOperationEvent) :void
		{
			if(textMode)
				return;
			var _text:String=this.text;
			_text=stripNonNumeric(_text,this.supportMathExpresions);
			
			
			if(_text==""){
				changeValue(0);
				return;
			}
			
			var num:Number=NumberFromSting(_text);
			if(isNaN(num))
			{
				if(!supportMathExpresions){
					changeValue(0);
				}
				
			}
			else{
				changeValue(num);
			}
		}
		private static function NumberFromSting(str:String):Number{
			return Number(str.replace(",","."));
		}
		private function handleMathExpresion():void{
			var _text:String=this.text.replace(",",".");
			var parsedexpression:Array=parser.parse(_text);
			if(parsedexpression.length==1)
				return;
			if (parser.success) {
				parsedexpression=parser.simplify(parsedexpression); //optional
				var num:Number=parser.eval(parsedexpression, [0]);
				if(onlyWholeNumbers)
					num=Math.floor(num);
				this.text=num.toString();
				this.setStyle("contentBackgroundColor",_bgColor);
				this.selectRange(this.text.length, this.text.length) 
			}
			else{
				num=0;
				//this.setStyle("contentBackgroundColor",_invalidBgColor);
			}
			
			
			changeValue(num);
		}
		public function onKeyPress(event:KeyboardEvent):void {
			if(textMode)
				return;
			if(event.keyCode==Keyboard.UP){
				incrementValue();
				return;
			}
			if(event.keyCode==Keyboard.DOWN){
				decrementValue();
				return;
			}
			if(event.keyCode==Keyboard.ENTER)
			{
				handleMathExpresion();
				return;
			}
		}
		private function incrementValue():void{
			if(this.editable==false)
				return;
			this.value=this.value+incrementStepValue;
			dispatchEvent(new TextOperationEvent(VALUE_CHANGED));	
		}
		private function decrementValue():void{
			if(this.editable==false)
				return;
			var newValue:Number=this.value-incrementStepValue;
			if(newValue<0)
			{
				newValue=0;
			}
				this.value=newValue;
				dispatchEvent(new TextOperationEvent(VALUE_CHANGED));	
		}
		public function get onlyWholeNumbers():Boolean
		{
			return _onlyWholeNumbers;
		}
		
		public function set onlyWholeNumbers(value:Boolean):void
		{
			_onlyWholeNumbers = value;
		}
		
		public override function set editable(value:Boolean):void
		{
			super.editable=value;
			if(value)
				this.setStyle("contentBackgroundColor",_bgColor);
			else
				this.setStyle("contentBackgroundColor",_readOnlyBgColor);
		}
		public override function set enabled(value:Boolean):void
		{
			super.enabled=value;
			if(value)
				this.setStyle("contentBackgroundColor",_bgColor);
			else
			{
				this.setStyle("contentBackgroundColor",_disabledbgColor);
				//this._oldValue=0;//when disabled the input is cleared
			}
		}
		
		public function get readOnlyBgColor():String
		{
			return _readOnlyBgColor;
		}
		
		public function set readOnlyBgColor(value:String):void
		{
			_readOnlyBgColor = value;
		}
		
		private function onPosibleTextInput(event:TextOperationEvent) :void{
			if(textMode)
				return;
			var op:FlowOperation=event.operation;
			if(op is PasteOperation||op is CutOperation||op is DeleteTextOperation)
				callLater(onTextInput,new Array(null));
		}
		private function onFocusOut(event:FocusEvent):void{
			if(textMode)
				return;
			if(supportMathExpresions)
				handleMathExpresion();
		}
		
		private function changeValue(num:Number):void{
			var isNewValue:Boolean=false;
			if(this.value!=num)
			{
				isNewValue=true;
				if(roundTo3Digits)
					this._oldValue=MathAux.roundToDecimal(num);
				else
					this._oldValue=num;
			}
			//update the text even the old value is equal with the new value
			//i need to call this setter to fix the issue when old text was 11 and new text is 11abc
			//after striping the literals the oldvalue==newvalue but the text is diffrent so it must be changed
			if(this._mustUpdateText)
				updateText();
			if(isNewValue){
				if(this.delayed)
					delayChangeValuyeEvent();
				else
					dispatchEvent(new TextOperationEvent(VALUE_CHANGED));	
			}
		}
		private function delayChangeValuyeEvent():void{
			//trace("delay changed trigered");
			this._timer.reset();
			this._timer.start();
		}
		private function fireUpdateEvent(event:Event=null):void{
			//trace("timer  trigered");
			dispatchEvent(new TextOperationEvent(VALUE_CHANGED));
		}
		// This function removes non-numeric characters
		private function stripNonNumeric( string:String ,supportsMathChars:Boolean):String
		{
			var res:String;
			_mustUpdateText=false;
			res=string.replace(",",".");
			var out:String = '';
			var isMathExpresion:Boolean=false;
			for( var i:Number = 0; i < res.length; i++ )
			{
				var char:String=res.charAt(i);
				if(supportsMathChars){
					if(isMathChar(char))
					{
						isMathExpresion=true;
						out+=char;
						continue;
					}
				}
				if( rgx.test( char ) )
				{
					if( !( ( char == '.' && out.indexOf( '.' ) != -1 ) ||
						( char == '-' && out.length != 0 ) ) )
					{
						out += char;
					}
				}
			}
			
			if(onlyWholeNumbers&&!isMathExpresion){
				//drop the decimals
				out=int(Math.round(NumberFromSting(out))).toString();
			}
			if(out.length!=string.length)
				_mustUpdateText=true;
			return out;
		}
		private function isMathChar(char:String):Boolean{
			if(_mathChars.indexOf(char)<0)
				return false;
			return true;
		}
		public function get value():Number{
			return _oldValue;
		}
		protected function updateText(forceUpdate:Boolean=false):void{
			if(_oldValue==0||isNaN(_oldValue)||_oldValue==Infinity)
				this.text="";
			else
			{
				var _text:String=MathAux.roundToDecimal(_oldValue).toString();
				if(!forceUpdate){
					if(_text.length==this.text.length-1)
					{
						if(this.text.indexOf(_text)==0)
						{
							if(this.text.indexOf(".")==text.length-1||this.text.indexOf(",")==text.length-1)
								//then we do not change the current text
								//we make the _text equal to the current one that ends with .
								_text=this.text;
						}			
					}
				}
				this.text=_text;
			}		
			this.selectRange(this.text.length, this.text.length) 
		}
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}
		public function set value(val:Number):void{
			if(roundTo3Digits)
				val=MathAux.roundToDecimal(val);
			if(val!=_oldValue){
				this._oldValue=val;
				updateText(true);
			}
		}
		
	}
}