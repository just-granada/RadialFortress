////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package com.danta.radialFortress.screens
{
	import com.danta.radialFortress.FortressEvent;
	import com.danta.radialFortress.components.GameHUD;
	import com.danta.radialFortress.components.GameWorld;
	import com.danta.util.ScrollingBackground;
	import com.greensock.TweenMax;
	
	import flash.debugger.enterDebugger;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class GameScreen extends Sprite
	{
		//------------------------------------------------------------------------------
		//
		//  Constants
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		public static var screenWidth:Number = 800;
		public static var screenHeight:Number = 800;
		
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
		
		public function GameScreen()
		{
			createBackground();
			gameWorldContainer= new GameWorld();
			gameWorldContainer.loadLevel(0);
			gameMask=new Sprite();
			this.addChild(gameWorldContainer);
			this.addChild(gameMask);
			createMask();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			gameWorldContainer.addEventListener(FortressEvent.SHIP_DESTROYED, onShipDestroyed);
			gameWorldContainer.addEventListener(FortressEvent.CORE_DESTROYED, onCoreDestroyed);
			createHUD();
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
		
		private var gameWorldContainer:GameWorld;
		private var gameMask:Sprite;
		private var background:ScrollingBackground;
		private var gameWorldPosition:Point;
		private var lastFrameTime:uint;
		private var deltaT:Number;
		private var gameOver:GameOverScreen;
		private var levelBeat:LevelBeatScreen;
		private var currentLevel:int=0;
		private var gameHUD:GameHUD;
		
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
		
		private function createMask():void
		{
			gameMask.graphics.beginFill(0);
			gameMask.graphics.drawRect(0,0,screenWidth, screenHeight);
			gameWorldContainer.mask=gameMask;
		}
		
		private function createBackground():void
		{
			background=new ScrollingBackground(screenWidth, screenHeight, "assets/spaceBG.png");
			this.addChild(background);
		}
		
		private function repositionViewport():void
		{
			gameWorldContainer.x=gameWorldContainer.x*0.9+((screenWidth/2)-(4*gameWorldContainer.getShipPosition().x/5))*0.1;
			gameWorldContainer.y=gameWorldContainer.y*0.9+((screenHeight/2)-(4*gameWorldContainer.getShipPosition().y/5))*0.1;
			background.bgOffset=(new Point(gameWorldContainer.x/10, gameWorldContainer.y/10))
			//gameWorldContainer.scaleX=Math.min(1.2,(Math.max(0.2,gameWorldContainer.scaleY=1-gameWorldContainer.getShipPosition().length/1000)));
		//	trace(Math.sqrt(gameWorldContainer.getShipPosition().length),gameWorldContainer.scaleX)
		}
		
		private function createHUD():void
		{
			gameHUD = new GameHUD();
			this.addChild(gameHUD);
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
		private function onEnterFrame(event:Event):void
		{
			if(lastFrameTime==0)
				lastFrameTime=getTimer();
			deltaT=getTimer()-lastFrameTime;
			gameWorldContainer.draw(deltaT);
			background.draw();
			repositionViewport();
			lastFrameTime=getTimer();
		}
		
		private function onShipDestroyed(event:FortressEvent):void
		{
			gameOver=new GameOverScreen();
			gameOver.x = screenWidth/2;
			gameOver.y = screenHeight/2;
			gameOver.addEventListener(FortressEvent.TRY_AGAIN, onTryAgain);
			this.addChild(gameOver);
		}
		
		private function onCoreDestroyed(event:FortressEvent):void
		{
			levelBeat=new LevelBeatScreen();
			levelBeat.x = screenWidth/2;
			levelBeat.y = screenHeight/2;
			levelBeat.addEventListener(FortressEvent.NEXT_LEVEL, onNextLevel);
			this.addChild(levelBeat);
		}
		
		private function onNextLevel(event:FortressEvent):void
		{
			currentLevel++;
			gameWorldContainer.loadLevel(currentLevel);
			this.removeChild(levelBeat);
			levelBeat.removeEventListener(FortressEvent.NEXT_LEVEL, onNextLevel);
			levelBeat=null;
		}
		
		private function onTryAgain(event:Event):void
		{
			currentLevel=0; 
			gameWorldContainer.loadLevel(currentLevel);
			this.removeChild(gameOver);
			gameOver.removeEventListener(FortressEvent.TRY_AGAIN, onTryAgain);
			gameOver=null;
		}
		
		
	}
}