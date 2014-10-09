/*
Copyright (c) 2010 Ryan Phelan
    http://www.rphelan.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package generic_components
{
	
import flash.display.Graphics;
import flash.display.MovieClip;

import mx.controls.Image;
import mx.core.UIComponent;

import spark.components.BorderContainer;
import spark.components.Group;

/**
 * 	LoadCanvas displays a loading indicator when isLoading is set to true
 */
public class LoadCanvas extends BorderContainer
{	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 */
	public function LoadCanvas()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 * 	@private
	 * 	Image that is displayed when loading
	 */
	private var _loadImage:Image;
	
	/**
	 * 	@private
	 * 	Sits on top of the contents when loading
	 * 	to create a disabled look
	 */
	private var _fade:UIComponent;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	Set isLoading to true when contents of this Container are 
	 * 	waiting for an update
	 */
	private var _isLoading:Boolean;
	
	[Bindable]
	public function set isLoading( l:Boolean ):void
	{
		_isLoading = l;
		
		invalidateDisplayList();
	}		
	public function get isLoading():Boolean 
	{
		return _isLoading;
	}
	
	/**
	 * 	Source path/class for the loadImage
	 */
	private var _loadImageSource:Object;
	
	[Bindable]
	public function set loadImageSource( obj:Object ):void
	{
		_loadImageSource = obj;
		
		invalidateProperties();
		invalidateDisplayList();
	}		
	public function get loadImageSource():Object 
	{
		return _loadImageSource;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * 	Create the loadImage and fade graphic
	 */
	override protected function createChildren():void
	{
		super.createChildren();
		
		if( !_loadImage )
		{
			_loadImage = new Image();
			addElement( _loadImage );
		}
		
		if( !_fade )
		{
			_fade = new Group();
			addElement( _fade );
		}
	}
	
	/**
	 * Update the loadImage source
	 */
	protected override function commitProperties():void
	{
		super.commitProperties();
		
		if( _loadImage.source != _loadImageSource )
			_loadImage.source = _loadImageSource;
	}
	
	/**
	 * 	Update the size and position of the fade graphic and loadImage
	 */
	protected override function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
	{
		super.updateDisplayList( unscaledWidth, unscaledHeight );

		if( _isLoading && _loadImageSource )
		{
			// size and position the loadImage
			_loadImage.setActualSize( _loadImage.measuredWidth, _loadImage.measuredHeight );
			_loadImage.move( unscaledWidth/2 - _loadImage.width/2, unscaledHeight/2 - _loadImage.height/2 );
			
			// show the fade and loadImage
			setElementIndex( _loadImage, numElements-1 );
			setElementIndex( _fade, numElements-2 );
			_fade.visible = true;
			_loadImage.visible = true;
			if( _loadImage.content is MovieClip )
				MovieClip(_loadImage.content).play();
			
			// fill the fade component with a translucent white
			var g:Graphics = _fade.graphics;				
			g.clear();
			g.beginFill( 0xFFFFFF, .6 );
			g.drawRect( 0, 0, unscaledWidth, unscaledHeight );
			g.endFill();			
		}
		else
		{
			// remove the fade and load image from the display list
			_fade.visible = false;
			_loadImage.visible = false;
			
			if( _loadImage.content is MovieClip )
				MovieClip(_loadImage.content).stop();
		}
	}	
}
}