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
	import com.danta.util.KeyboardHelper;
	import com.danta.util.SoundFX;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import mx.core.BitmapAsset;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class Ship extends Sprite
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
		
		private static const MAX_ANGULAR_SPEED:Number=0.002;
		private static const ANGULAR_ACCELERATION:Number=0.0002;
		private static const MAX_RADIAL_SPEED:Number=0.3;
		private static const RADIAL_ACCELERATION:Number=0.03;
		private static const GUN_COOLDOWN:uint=200;
		private static const INVUL_TIME:uint=1000;
		private static const CORE_RADIUS:Number=15;
		private static var NORMAL:int=0;
		private static var DEAD:int=1;
		private static var instance:Ship;
		public static const MAX_HEALTH:int=8;
		
		//------------------------------------------------------------------------------
		//
		//  Static Methods
		//
		//------------------------------------------------------------------------------
		
		public static function getInstance():Ship
		{
			return instance;
		}
			
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//  Constructor
		//
		////////////////////////////////////////////////////////////////////////////////
		
		public function Ship()
		{
			this.addChild(shipAsset);
			shipAsset.x=-shipAsset.width/2;
			shipAsset.y=-shipAsset.height/2;
			shipAsset.cacheAsBitmap=true;
			shipAsset.smoothing=true;
			_currentEnergy=MAX_HEALTH;
			
			shipCore=new Sprite;
			shipCore.graphics.beginFill(0,0.1);
			shipCore.graphics.drawCircle(0,3,CORE_RADIUS);
			this.addChildAt(shipCore,0);
			instance=this;
			lastHitTime=getTimer()+500;
			angularPosition=0.01;
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
		
		[Embed(source="assets/ship.png")]
		private var shipAssetClass:Class;
		private var shipAsset:BitmapAsset = BitmapAsset(new shipAssetClass());
		
		private var _angularPosition:Number=0;
		private var _radialDistance:Number=300;
		private var angularVelocity:Number=0;
		private var radialVelocity:Number=0;
		private var _center:Point;
		private var lastShotTime:uint;
		private var lastHitTime:uint=0;
		private var _currentEnergy:int;
		public var shipCore:Sprite;
		private var currentState:int=NORMAL;
		
		//------------------------------------------------------------------------------
		//
		//  Properties (getters/setters)
		//
		//------------------------------------------------------------------------------
		
		public function get currentEnergy():int
		{
			return _currentEnergy;
		}

		public function set currentEnergy(value:int):void
		{
			_currentEnergy = value;
		}

		public function get radialDistance():Number
		{
			return _radialDistance;
		}
		
		public function set radialDistance(value:Number):void
		{
			_radialDistance = value;
		}
		
		public function get angularPosition():Number
		{
			return _angularPosition;
		}
		
		public function set angularPosition(value:Number):void
		{
			_angularPosition = value;
		}
		
		public function get center():Point
		{
			return _center;
		}
		
		public function set center(value:Point):void
		{
			_center = value;
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
		
		
		public function draw(deltaT:Number):void
		{
			if(currentState==NORMAL)
			{
				manageKeyboard();
				_angularPosition+=(angularVelocity/(radialDistance*0.005))*deltaT;
				if(_angularPosition<0)
					_angularPosition=2*Math.PI-_angularPosition;
				else if(_angularPosition>2*Math.PI)
					_angularPosition=_angularPosition-2*Math.PI;
				_radialDistance+=radialVelocity*deltaT;
				if(_radialDistance<=15)
				{
					radialDistance=15;
					radialVelocity=0;
				}
				this.x=_center.x+Math.sin(_angularPosition)*_radialDistance;
				this.y=_center.y+Math.cos(_angularPosition)*_radialDistance;
				this.rotation=-ArcHelper.toDeg(_angularPosition);	
			}
		}
		
		public function takehit(xDir:Number, yDir:Number):void
		{
			SoundFX.play("shipHit");
			angularVelocity+=xDir/400;
			radialVelocity+=yDir/200;
			if(getTimer()-lastHitTime > INVUL_TIME && currentState==NORMAL)
			{
				this._currentEnergy--;
				TweenMax.to(this,0.1,{yoyo:true, tint:0xffaa99, repeat:5});
				dispatchEvent(new FortressEvent(FortressEvent.SHIP_HIT,true));
				lastHitTime=getTimer();
				if(this._currentEnergy<=0)
				{
					dispatchEvent(new FortressEvent(FortressEvent.SHIP_DESTROYED,true));
					goBoom();
				}
			}
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private function manageKeyboard():void
		{
			if(KeyboardHelper.isDown(Keyboard.RIGHT))
			{
				angularVelocity=Math.min(angularVelocity+ANGULAR_ACCELERATION,MAX_ANGULAR_SPEED);				
			}
			else if(KeyboardHelper.isDown(Keyboard.LEFT))
			{
				angularVelocity=Math.max(angularVelocity-ANGULAR_ACCELERATION,-MAX_ANGULAR_SPEED);
			}
			else
			{	
				angularVelocity*=0.94;
				if(Math.abs(angularVelocity)<0.00001) 
					angularVelocity=0;
			}
			if(KeyboardHelper.isDown(Keyboard.UP))
			{
				radialVelocity=Math.max(radialVelocity-RADIAL_ACCELERATION,-MAX_RADIAL_SPEED);
			}
			else if(KeyboardHelper.isDown(Keyboard.DOWN))
			{
				radialVelocity=Math.min(radialVelocity+RADIAL_ACCELERATION,MAX_RADIAL_SPEED);
			}
			else
			{	
				radialVelocity*=0.8;
				if(Math.abs(radialVelocity)<0.1) 
					radialVelocity=0;
			}
			
			if(KeyboardHelper.isDown(Keyboard.SPACE))
			{
				shoot();
			}
		}
		
		private function shoot():void
		{
			if(getTimer()-lastShotTime > GUN_COOLDOWN)
			{
				dispatchEvent(new FortressEvent(FortressEvent.SHIP_SHOT))
				lastShotTime=getTimer();
			}
		}
		
		private function goBoom():void
		{
			currentState=DEAD;
			TweenMax.to(shipAsset, 1.5,{alpha:0, blurFilter:{blurX:10, blurY:10, quality:3}})
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
	}
}