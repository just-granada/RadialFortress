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
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class ShipBullet extends Sprite
	{
		//------------------------------------------------------------------------------
		//
		//  Constants
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		public static var BULLET_SPEED:Number=-0.5;
		
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
		
		public function ShipBullet(angularPosition:Number, radialDistance:Number)
		{
			createBody();
			createCollider();
			this.radialVelocity=BULLET_SPEED;
			this.radialDistance=radialDistance;
			this.angularPosition=angularPosition;
			rotation=ArcHelper.toDeg(-angularPosition);
			this.x=Math.sin(angularPosition)*radialDistance;
			this.y=Math.cos(angularPosition)*radialDistance;
			this.cacheAsBitmap=true;
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
		
		private var _angularPosition:Number;
		private var _radialDistance:Number;
		private var radialVelocity:Number;
		private var lastDeltaT:Number;
		public var collider:Sprite;
		
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
		
		public function get angularPosition():Number
		{
			return _angularPosition;
		}

		public function set angularPosition(value:Number):void
		{
			_angularPosition = value;
		}

		public function get radialDistance():Number
		{
			return _radialDistance;
		}

		public function get collisionRadialDistances():Array
		{
			return [_radialDistance, radialDistance+radialVelocity*2*lastDeltaT, radialDistance+radialVelocity*3*lastDeltaT];
		}
		
		public function set radialDistance(value:Number):void
		{
			_radialDistance = value;
		}

		public function draw(deltaT:uint):void
		{
			radialDistance+=radialVelocity*deltaT;
			this.x=Math.sin(angularPosition)*radialDistance;
			this.y=Math.cos(angularPosition)*radialDistance;
			
			if(radialDistance<=0)
			{
				dispatchEvent(new FortressEvent(FortressEvent.BULLET_REACHED_CENTER,false,false,{bullet:this}));
			}
			lastDeltaT=deltaT;
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private function createBody():void
		{
			graphics.lineStyle(5,0xccccff,0.4);
			graphics.beginFill(0xccccff,0.8);
			graphics.drawRoundRect(-5,0,5,24,4,4);
		}
		
		private function createCollider():void
		{
			collider=new Sprite();
			collider.graphics.beginFill(0,0.1);
			collider.graphics.drawCircle(0,0,1);
			this.addChildAt(collider,0);
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
	}
}