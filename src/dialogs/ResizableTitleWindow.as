package dialogs
{

import core.TimerUtil;

import flash.desktop.NativeApplication;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import mx.core.UIComponent;
import mx.core.WindowedApplication;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.PopUpManager;

import spark.components.TitleWindow;

/**
 *  ResizableTitleWindow is a TitleWindow with
 *  a resize handle.
 */
public class ResizableTitleWindow extends TitleWindow
{
	public var canceled:Boolean=true;
	public var prevent_ESC_cacelDialog:Boolean=false;
	public function set isSave(value:Boolean):void{
		canceled=!value;
	}
	public function get isSave():Boolean{
		return !canceled;
	}
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 */
	public function ResizableTitleWindow()
	{
		super();
		minWidth=minHeight=120;
		this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComlete);
		this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
		this.addEventListener("close",close);
		this.setStyle("skinClass", ResizableTitleWindowSkin);
		
	}
	private function onCreationComlete(e:Event):void{
		centerWindow();
	}
	protected function onKeyDownHandler(event:KeyboardEvent):void {
		if ( event.keyCode == Keyboard.ESCAPE&&prevent_ESC_cacelDialog==false)
		{
			this.canceled=true;
			this.close();
		}	
	}
	public function close(e:*=null):void{
		PopUpManager.removePopUp(this);
		if(this.closeHandler!=null)
			closeHandler();
	}
	public static function showDialog(parent:DisplayObject,closeHandler:Function=null,modal:Boolean=true):ResizableTitleWindow{
		var rtw:ResizableTitleWindow = new ResizableTitleWindow();
		rtw.showDialog(parent,closeHandler,modal);
		return rtw;
	}
	public  function showDialog(parent:DisplayObject,closeHandler:Function=null,modal:Boolean=true):void{
		this.closeHandler=closeHandler;
		PopUpManager.addPopUp(this, parent, modal);		
	}
	public function show(parent:DisplayObject):void {
		if(parent==null){
			parent=NativeApplication.nativeApplication.activeWindow.stage.getChildAt(0);
		}
		PopUpManager.addPopUp(this, parent, true);
		PopUpManager.centerPopUp(this);
		PopUpManager.bringToFront(this);
		//TimerUtil.callLater(1000,bringToFront,this,null);
	}
	private function bringToFront():void{
		PopUpManager.bringToFront(this);
	}
	private function centerWindow():void {
		var x:Number;
		var y:Number;
		if (owner != null && owner.width > this.width && owner.height > this.height) {
			var ownerX:int=owner.x;
			var ownerY:int=owner.y;
			if(owner.y==0&&owner.x==0&&!(owner is WindowedApplication ))
			{
				var globalCoords:Point = owner.localToGlobal(new Point(0,0));	
				ownerX=globalCoords.x;
				ownerY=globalCoords.y;
			}
			x = ownerX + (this.owner.width - this.width) / 2;
			y = ownerY + (this.owner.height - this.height) / 2;
		}
		else {
			var win:DisplayObject = null;
			try {
				win = NativeApplication.nativeApplication.activeWindow.stage;
			}
			catch (error:Error) {
				win = null;
			}
			if (!win)
				return;
				//win = StageReference.instance;
			
			x = (win.width - this.width) / 2;
			y = (win.height - this.height) / 2;
			
		}
		
		this.move(x, y);
	}
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var clickOffset:Point;
	
	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  Resize Handle
	//---------------------------------- 
	
	[SkinPart("false")]
	
	/**
	 *  The skin part that defines the area where
	 *  the user may drag to resize the window.
	 */
	public var resizeHandle:UIComponent;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: UIComponent, SkinnableComponent
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	override protected function partAdded(partName:String, instance:Object) : void
	{
		super.partAdded(partName, instance);
		
		if (instance == resizeHandle)
		{
			resizeHandle.addEventListener(MouseEvent.MOUSE_DOWN, resizeHandle_mouseDownHandler);
		}
	}
	
	/**
	 *  @private
	 */
	override protected function partRemoved(partName:String, instance:Object):void
	{
		if (instance == resizeHandle)
		{
			resizeHandle.removeEventListener(MouseEvent.MOUSE_DOWN, resizeHandle_mouseDownHandler);
		}
		
		super.partRemoved(partName, instance);
	}
	
	//--------------------------------------------------------------------------
	// 
	// Event Handlers
	//
	//--------------------------------------------------------------------------
	
	private var prevWidth:Number;
	private var prevHeight:Number;
	private  var closeHandler:Function;
	
	protected function resizeHandle_mouseDownHandler(event:MouseEvent):void
	{
		if (enabled && isPopUp && !clickOffset)
		{        
			clickOffset = new Point(event.stageX, event.stageY);
			prevWidth = width;
			prevHeight = height;
			
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			
			sbRoot.addEventListener(
				MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
			sbRoot.addEventListener(
				MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
			sbRoot.addEventListener(
				SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler)
		}
	}
	
	/**
	 *  @private
	 */
	protected function resizeHandle_mouseMoveHandler(event:MouseEvent):void
	{
		// during a resize, only the TitleWindow should get mouse move events
		// we don't check the target since this is on the systemManager and the target
		// changes a lot -- but this listener only exists during a resize.
		event.stopImmediatePropagation();
		
		if (!clickOffset)
		{
			return;
		}
		var w:Number=prevWidth + (event.stageX - clickOffset.x);
		var h:Number= prevHeight + (event.stageY - clickOffset.y);
		if(w>=minWidth&&w<=maxWidth)
		width = w;
		if(h>=minHeight&&h<=maxHeight)
			height = h;
		
		event.updateAfterEvent();
	}
	
	/**
	 *  @private
	 */
	protected function resizeHandle_mouseUpHandler(event:Event):void
	{
		clickOffset = null;
		prevWidth = NaN;
		prevHeight = NaN;
		
		var sbRoot:DisplayObject = systemManager.getSandboxRoot();
		
		sbRoot.removeEventListener(
			MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
		sbRoot.removeEventListener(
			MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
		sbRoot.removeEventListener(
			SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler);
	}
}
}

