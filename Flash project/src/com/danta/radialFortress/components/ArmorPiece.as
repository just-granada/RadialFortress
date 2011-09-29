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
	import flash.geom.Point;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class ArmorPiece extends Sprite
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
		
		internal const NORMAL:int=0;
		internal const IMPLODE:int=1;
		internal const EXPLODE:int=2;
		internal const max_alpha:Number=0.75;
		
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
		
		public function ArmorPiece(radius:Number,radialThickness:Number=20, angularPosition:Number=0, angularWidth:Number=30, angularVelocity:Number=1, color:uint=0, startingEnergy:int=75)
		{
			this.radius=radius;
			this. radialDepth=radialThickness;
			this._angularPosition=angularPosition;
			this.angularWidth=angularWidth;
			this._angularVelocity=angularVelocity;
			this._color=color;
			this.cacheAsBitmap=true;
			this.startingEnergy=startingEnergy;
			this.currentEnergy=startingEnergy;
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
		
		public var radius:Number;
		internal var radialDepth:Number=20;
		internal var _angularPosition:Number;
		internal var angularWidth:Number;
		internal var _angularVelocity:Number;
		internal var arcDrawn:Boolean=false;
		internal var _color:uint;
		internal var aux_rotation:Number;
		internal var aux_offset:Number;
		internal var startingEnergy:int;
		internal var _currentEnergy:int;
		internal var currentState:int;
		public var radialVelocity:Number=0;
		
		//------------------------------------------------------------------------------
		//
		//  Properties (getters/setters)
		//
		//------------------------------------------------------------------------------
		
		public function get globalAngularPosition():Number
		{
			return ArcHelper.normalize(ArcHelper.toRad(-rotation)+angularPosition);
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
		
		public function get currentEnergy():int
		{
			return _currentEnergy;
		}

		public function set currentEnergy(value:int):void
		{
			_currentEnergy = value;
		}

		public function get angularPosition():Number
		{
			return _angularPosition;
		}

		public function set angularPosition(value:Number):void
		{
			_angularPosition = value;
		}

		public function get angularVelocity():Number
		{
			return _angularVelocity;
		}

		public function set angularVelocity(value:Number):void
		{
			_angularVelocity = value;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			arcDrawn=false;
		}
		
		public function explosionComplete():void
		{
			this._currentEnergy=-1;
			this.currentState=0;
			dispatchEvent(new FortressEvent(FortressEvent.ARMOR_EXPLODED,false,false,{armor:this}));
		}

		public function draw(deltaT:Number):void
		{
			if(!arcDrawn || currentState!=NORMAL)
			{
				this.radius += radialVelocity*deltaT;
				this.graphics.clear();
				this.graphics.beginFill(_color);
				ArcHelper.drawArc(this, radius-radialDepth/2, radius+radialDepth/2, _angularPosition-angularWidth/2, _angularPosition+angularWidth/2);
				this.graphics.endFill();
				this.graphics.beginFill(0,0.3);
				ArcHelper.drawArc(this, radius-radialDepth/2, radius-radialDepth/2+6, _angularPosition-angularWidth/2, _angularPosition+angularWidth/2);
				this.graphics.endFill();
				this.graphics.beginFill(0xffffff,0.3);
				ArcHelper.drawArc(this, radius+radialDepth/2-6, radius+radialDepth/2, _angularPosition-angularWidth/2, _angularPosition+angularWidth/2);
				this.graphics.endFill();
				arcDrawn=true;
				this.alpha=max_alpha;
				
				if(radius < 15)
				{
					currentState=EXPLODE;
					radialVelocity=0;
					TweenLite.killTweensOf(this);
					TweenMax.to(this,2,{radialVelocity:1+Math.random(), tint:0xff3300, onComplete:explosionComplete});
				}
				if(currentState==EXPLODE)
				{
					alpha=1-(radius/200);
				}
			}
			else
			{
				rotation+=(angularVelocity)*deltaT;
			}
		}
		
		public function collidesWith(bullet:ShipBullet):Boolean
		{
			if(Math.abs(bullet.angularPosition-this.globalAngularPosition) < (5*angularWidth/8) && Math.abs(bullet.radialDistance-this.radius)<(this.radialDepth) && currentState==NORMAL)
			{
				trace("bullet hit armor: ",this.name)
				currentEnergy-=50;
				this.alpha = (currentEnergy/startingEnergy)*max_alpha;
				return true;
			}
			
			return false;
		}
		
		public function collidesWithShip(ship:Ship):Boolean
		{
			if(Math.abs(ship.angularPosition-this.globalAngularPosition) < (6*angularWidth/8) && Math.abs(ship.radialDistance-this.radius)<(this.radialDepth))
			{
				return true;
			}
			return false;
		}
		
		public function goBoom():void
		{
			currentState=IMPLODE;
			TweenLite.to(this,0.5+0.5*Math.random(),{radius:0});
		}
		
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