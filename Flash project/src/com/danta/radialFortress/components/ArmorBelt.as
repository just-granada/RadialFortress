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
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class ArmorBelt extends Sprite
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
		
		public function ArmorBelt(radius:Number, radialDepth:Number, color:uint=0, beltData:XML=null)
		{
			this._radius=radius;
			this.radialDepth=radialDepth;
			this.angularVelocity=beltData.@angularVelocity;
			this._numPieces=beltData.@numPieces;
			this._numCannons=beltData.cannon.length();
			this._color=color;
			
			pieces=new Vector.<ArmorPiece>();
			pieceWidth=2*Math.PI/_numPieces;
			this.beltData=beltData;
			createArmorPieces();
			
			this.addEventListener(FortressEvent.BULLET_HIT_ARMOR, bulletHitArmor);
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
		
		private var pieces:Vector.<ArmorPiece>;
		private var _radius:Number;
		private var radialDepth:Number;
		private var angularVelocity:Number;
		private var _numPieces:int;
		private var _numCannons:int;
		private var _color:uint;
		private var pieceWidth:Number;
		private var i:int;
		private var aux_point:Point=new Point();
		private var aux_vector:Vector.<ArmorPiece>;
		private var cannonPosModifier:int;
		private var beltData:XML;
		
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
		
		public function get numCannons():int
		{
			return _numCannons;
		}

		public function set numCannons(value:int):void
		{
			_numCannons = value;
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
		}

		public function draw(deltaT:Number):void
		{
			for(i=0;i<pieces.length;i++)
			{
				pieces[i].draw(deltaT);
				if(pieces[i] is CannonPiece)
				{
					(pieces[i] as CannonPiece).seesShip();
				}
			}
		}
		
		public function getMaxRadius():Number
		{
			return _radius+radialDepth/2;
		}
		
		public function getMinRadius():Number
		{
			return _radius-radialDepth/2;
		}
		
		public function collidesWith(bullet:ShipBullet):Boolean
		{
			
			for(i=0;i<pieces.length;i++)
			{
				if(pieces[i].collidesWith(bullet))
				{
					dispatchEvent(new FortressEvent(FortressEvent.BULLET_HIT_ARMOR,true,false,{bullet:bullet, armor:pieces[i]}));
					return true;
				}
			}
			return false;
		}
		
		public function collidesWithShip(ship:Ship):Boolean
		{
			for(i=0;i<pieces.length;i++)
			{
				if(pieces[i].collidesWithShip(ship))
				{
					ship.takehit(ship.angularPosition-pieces[i].globalAngularPosition, ship.radialDistance-pieces[i].radius);
					trace("SHIP_HIT!");
					return true;
				}
			}
			return false;
		}
		
		public function goBoom():void
		{
			for(i=0;i<pieces.length;i++)
			{
				pieces[i].goBoom();
			}
		}	
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private function createArmorPieces():void
		{
			var piece:ArmorPiece;
			
			for(i=0;i<_numPieces;i++)
			{
				piece=null;
				if(hasCannonInIndex(i))
					piece=new CannonPiece(_radius,radialDepth,i*pieceWidth,pieceWidth-ArcHelper.toRad(1),angularVelocity,_color);
				else if(hasMetalInIndex(i))
					piece=new HardArmorPiece(_radius,radialDepth,i*pieceWidth,pieceWidth-ArcHelper.toRad(1),angularVelocity,_color);
				else if(beltData.@type=="belt")
					piece=new ArmorPiece(_radius,radialDepth,i*pieceWidth,pieceWidth-ArcHelper.toRad(0.5),angularVelocity,_color);
				
				if(piece!=null)
				{
					piece.addEventListener(FortressEvent.ARMOR_EXPLODED, onArmorExploded);
					this.addChild(piece);
					pieces.push(piece);	
				}
			}
		}
		
		private function destroyArmorPiece(piece:ArmorPiece):void
		{
			aux_vector=new Vector.<ArmorPiece>();
			for(i=0;i<pieces.length;i++)
			{
				if(pieces[i]!=piece)
					aux_vector.push(pieces[i]);
			}
			if(piece.parent == this)
				this.removeChild(piece);
			pieces=aux_vector;
		}
		
		private function hasCannonInIndex(index:int):Boolean
		{
			return (beltData.cannon.(int(@index)==index).length()>0);
		}
		
		private function hasMetalInIndex(index:int):Boolean
		{
			return (beltData.metal.(int(@index)==index).length()>0);
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
		private function bulletHitArmor(event:FortressEvent):void
		{
			if(event.data.armor.currentEnergy<=0)
				destroyArmorPiece(event.data.armor);
		}
		
		private function onArmorExploded(event:FortressEvent):void
		{	
			destroyArmorPiece(event.data.armor);					 
		}
	}
}