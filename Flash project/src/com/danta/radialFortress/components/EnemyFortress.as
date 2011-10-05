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
	import com.danta.util.ColorHelper;
	
	import flash.display.Sprite;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class EnemyFortress extends Sprite
	{
		//------------------------------------------------------------------------------
		//
		//  Constants
		//
		//------------------------------------------------------------------------------
		
		private const innerColor:uint=0x29477f;
		private const outerColor:uint=0x65e17b;
		
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
		
		public function EnemyFortress(level:int)//(numBelts:int, minRadius:Number, maxRadius:Number, angularSpeed:Number)
		{
			core = new EnemyCore();
			this.addChild(core);
			loadLevelValues(level);
			createBelts(levelData.belt.length(), levelData.@minRadius, levelData.@maxRadius);
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
		
		private var belts:Vector.<ArmorBelt>;
		private var aux_belt:ArmorBelt;
		private var i:int;
		private var beltRadialDepth:Number;
		private var aux_beltIndex:int;
		private var core:EnemyCore;
		private var levelData:XML;
		
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
		
		public function draw(deltaT:Number):void
		{
			core.draw(deltaT);
			for(i=0;i<belts.length;i++)
			{
				belts[i].draw(deltaT);
			}
		}
		
		public function getMaxRadius():Number
		{
			return belts[belts.length-1].getMaxRadius();
		}
		
		public function getMinRadius():Number
		{
			return belts[0].getMinRadius();
		}
		
		public function collidesWith(bullet:ShipBullet):Boolean
		{
			aux_beltIndex=Math.min(Math.max(Math.round((bullet.radialDistance-getMinRadius())/beltRadialDepth),Math.round((bullet.collisionRadialDistances[1]-getMinRadius())/beltRadialDepth),Math.round((bullet.collisionRadialDistances[2]-getMinRadius())/beltRadialDepth)),belts.length-1);
			if(aux_beltIndex>=0)
			{
				return belts[aux_beltIndex].collidesWith(bullet);
			}
			else
			{
				core.takeHit(21);
				dispatchEvent(new FortressEvent(FortressEvent.BULLET_REACHED_CENTER,true,false,{bullet:bullet}));
				return true;
			}
		}
		
		public function collidesWithShip(ship:Ship):Boolean
		{
			/*aux_beltIndex=Math.min(Math.round((ship.radialDistance-getMinRadius())/beltRadialDepth)+1,belts.length-1);
			if(aux_beltIndex>=0)
			{
				if(belts[aux_beltIndex].collidesWithShip(ship))
					return true;
			}
			if(aux_beltIndex-1>0)
			{
				return belts[aux_beltIndex-1].collidesWithShip(ship);
			}*/
			
			for(i=0;i<belts.length;i++)
			{
				if(belts[i].collidesWithShip(ship))
					return true;
			}
			if(ship.radialDistance<getMinRadius())
			{
				ship.takehit(0,ship.radialDistance);
				return true;
			}
			return false;
		}
		
		public function goBoom():void
		{
			for(i=0;i<belts.length;i++)
			{
				belts[i].goBoom();
			}
		}	
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private function createBelts(numBelts:int, minRadius:Number, maxRadius:Number):void
		{
			var sign:int;
			var aux_color:uint;
			var aux_rgb:Object={};
			var ratio:Number;
			
			//angularSpeed=0;
			
			beltRadialDepth=(maxRadius-minRadius)/numBelts;
			belts= new Vector.<ArmorBelt>();
			
			for(i=0;i<numBelts;i++)
			{
				ratio=i/numBelts;
				aux_rgb.r=ColorHelper.toRGB(innerColor).r*(1-ratio) + ColorHelper.toRGB(outerColor).r*(ratio);
				aux_rgb.g=ColorHelper.toRGB(innerColor).g*(1-ratio) + ColorHelper.toRGB(outerColor).g*(ratio);
				aux_rgb.b=ColorHelper.toRGB(innerColor).b*(1-ratio) + ColorHelper.toRGB(outerColor).b*(ratio);
				aux_color=ColorHelper.toHex(aux_rgb);
				sign=(i%2==0)?1:-1;
				aux_belt=new ArmorBelt(minRadius+i*beltRadialDepth,beltRadialDepth-2,aux_color, levelData.belt[i]);
				this.addChildAt(aux_belt,0);
				
				belts.push(aux_belt);
			}
		}
		
		private function loadLevelValues(level:int):void{
			levelData=LevelLoader.getLevelData(level);
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
	}
}