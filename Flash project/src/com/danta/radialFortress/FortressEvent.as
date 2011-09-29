////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package com.danta.radialFortress
{
	import flash.events.Event;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class FortressEvent extends Event
	{
		//------------------------------------------------------------------------------
		//
		//  Constants
		//
		//------------------------------------------------------------------------------
		
		//--------------------------------------
		//  Public
		//--------------------------------------
		
		public static const SHIP_SHOT:String="shipShot";
		public static const CANNON_SHOT:String="cannonShot";
		public static const BULLET_REACHED_CENTER:String="BulletReachedCenter";
		public static const BULLET_HIT_ARMOR:String="BulletHitArmor";
		public static const CORE_DESTROYED:String="CoreDestroyed";
		public static const ARMOR_EXPLODED:String="armorExploded";
		public static const SHIP_HIT:String="shipHit";
		public static const SHIP_DESTROYED:String="shipDestroyed";
		public static const TRY_AGAIN:String="tryAgain";
		public static const NEXT_LEVEL:String="nextLevel";
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private var _data:Object;
		
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
		
		public function FortressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			this._data=data;
			super(type, bubbles, cancelable);
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
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
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