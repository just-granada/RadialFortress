////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package com.danta.radialFortress.components
{
	import com.danta.radialFortress.FortressEvent;
	import com.danta.util.ArcHelper;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import mx.core.BitmapAsset;
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class CannonPiece extends ArmorPiece
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
		
		private static const VISION_RANGE:Number = 0.1;
		private static const GUN_COOLDOWN:uint=800;
		
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
		
		public function CannonPiece(radius:Number, radialThickness:Number=20, angularPosition:Number=0, angularWidth:Number=30, angularVelocity:Number=1, color:uint=0, startingEnergy:int=75)
		{
			super(radius, radialThickness, angularPosition, angularWidth, angularVelocity, color, startingEnergy);
			cannonContainer=new Sprite();
			this.addChild(cannonContainer);
			cannonContainer.addChild(cannonAsset);
			cannonContainer.rotation=180-ArcHelper.toDeg(angularPosition);
			cannonAsset.x=-cannonAsset.width/2;
			cannonAsset.y=-2*cannonAsset.height/3;
			lastShotTime=getTimer()+2000;
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
		
		[Embed(source="assets/CannonPiece.png")]
		private var cannonAssetClass:Class;
		private var cannonAsset:BitmapAsset = BitmapAsset(new cannonAssetClass());
		private var cannonContainer:Sprite;
		private var lastShotTime:uint;
		
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
		
		override public function draw(deltaT:Number):void
		{
			if(!arcDrawn || currentState!=NORMAL)
			{
				cannonContainer.x = radius*Math.sin(angularPosition);
				cannonContainer.y = radius*Math.cos(angularPosition);
			}
			
			super.draw(deltaT);
		}
		
		
		//------------------------------------------------------------------------------
		//
		//  Methods
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		public function seesShip():Boolean
		{
			if(Math.abs(this.globalAngularPosition - Ship.getInstance().angularPosition) < VISION_RANGE)
			{
				shoot();
				return true;
			}
			return false;
			}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private function shoot():void
		{
			if(getTimer()-lastShotTime > GUN_COOLDOWN)
			{
				dispatchEvent(new FortressEvent(FortressEvent.CANNON_SHOT,true, false, {cannon:this}));
				lastShotTime=getTimer();
			}
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
	}
}