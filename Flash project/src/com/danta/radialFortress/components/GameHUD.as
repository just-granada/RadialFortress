////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package com.danta.radialFortress.components
{
	import com.danta.radialFortress.screens.GameScreen;
	import com.danta.radialfortress.lib.LevelTicker;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class GameHUD extends Sprite
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
		
		public function GameHUD()
		{
			shieldMeter=new ShieldMeter();
			shieldMeter.x=-GameScreen.screenWidth/2+10;
			shieldMeter.y=-GameScreen.screenHeight/2+10;
			this.addChild(shieldMeter);
			
			scoreTicker=new ScoreHUD();
			scoreTicker.x=GameScreen.screenWidth/2-150;
			scoreTicker.y=-GameScreen.screenHeight/2+10;
			this.addChild(scoreTicker);
			
			scoreTicker.txt_score.text="0000";
				
			levelTicker=new LevelTicker();
			levelTicker.x=-levelTicker.width/2;
			levelTicker.y=-GameScreen.screenHeight/2+10;
			this.addChild(levelTicker);
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
		
		private var lbl_level:TextField;
		public var shieldMeter:ShieldMeter;
		public var scoreTicker:ScoreHUD;
		public var levelTicker:LevelTicker;
		
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