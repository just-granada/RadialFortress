////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package com.danta.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class ScrollingBackground extends Sprite
	{
		//------------------------------------------------------------------------------
		//
		//  Constants
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		//------------------------------------------------------------------------------
		//
		//  Static Methods
		//
		//------------------------------------------------------------------------------
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//  Constructor
		//
		////////////////////////////////////////////////////////////////////////////////
		
		public function ScrollingBackground(width:Number, height:Number, bgImageSource:String)
		{
			bgWidth=width;
			bgHeight=height;
			loader=new Loader();
			var ldrContext:LoaderContext = new LoaderContext(false);
			loader.load(new URLRequest(bgImageSource),ldrContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			bgMatrix=new Matrix();
			bgOffset=new Point();
		}
		
		//------------------------------------------------------------------------------
		//
		//  Variables
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private var bgWidth:Number;
		private var bgHeight:Number;
		private var bgBitmapData:BitmapData;
		private var loader:Loader;
		private var _bgOffset:Point;
		private var bgMatrix:Matrix;
		//------------------------------------------------------------------------------
		//
		//  Properties (getters/setters)
		//
		//------------------------------------------------------------------------------
		
		public function get bgOffset():Point
		{
			return _bgOffset;
		}
		
		public function set bgOffset(value:Point):void
		{
			_bgOffset = value;
			bgMatrix=new Matrix();
			bgMatrix.translate(_bgOffset.x, _bgOffset.y);
		}
		
		//------------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------
		//
		//  Methods
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		public function draw():void
		{
			if(bgBitmapData!=null)
			{
				graphics.clear();
				graphics.beginBitmapFill(bgBitmapData,bgMatrix,true,true);
				graphics.drawRect(0,0,bgWidth, bgHeight);
				graphics.endFill();
			}
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
		private function loaderComplete(event:Event):void
		{
			bgBitmapData=(loader.content as Bitmap).bitmapData;
		}
		
	}
}