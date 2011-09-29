////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package
{
	import com.danta.radialFortress.components.ArmorBelt;
	import com.danta.radialFortress.components.ArmorPiece;
	import com.danta.radialFortress.components.LevelLoader;
	import com.danta.radialFortress.components.Ship;
	import com.danta.radialFortress.screens.GameScreen;
	import com.danta.util.ArcHelper;
	import com.danta.util.KeyboardHelper;
	import com.danta.util.SoundFX;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.utils.getTimer;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	[SWF(width="800", height="800",frameRate="60")]
	public class RadialFortress extends Sprite
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
		
		public function RadialFortress()
		{
			var i:int;
			var sign:Number;
			KeyboardHelper.initialize(this.stage);
			LevelLoader.initialize();
			SoundFX.initialize();
			var game:GameScreen= new GameScreen();
			this.addChild(game);
			
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
		
		
		//------------------------------------------------------------------------------
		//
		//  Properties (getters/setters)
		//
		//------------------------------------------------------------------------------
		
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
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
	}
}