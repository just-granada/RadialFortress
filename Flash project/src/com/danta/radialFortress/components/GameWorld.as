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
	import com.danta.util.SoundFX;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.utils.setTimeout;
	
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class GameWorld extends Sprite
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
		
		public function GameWorld()
		{
			//createEnemyFortress();
			//createShip();
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
		
		private var fortress:EnemyFortress;
		private var lastFrameTime:uint;
		private var deltaT:uint;
		private var i:int;
		private var ship:Ship;
		private var aux_shipBullet:ShipBullet;
		private var aux_cannonBullet:EnemyBullet;
		private var shipBullets:Array=[];
		private var enemyBullets:Array=[];
		private var aux_array:Array;
		public var bulletTimeMultiplyer:Number=1;
		private var aux_point:Point;
		private var levelLoaded:Boolean;
		private var maxBullets:int=10;
		
		//------------------------------------------------------------------------------
		//
		//  Properties (getters/setters)
		//
		//------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------
		//
		//  Overriden methods
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
			if(levelLoaded)
			{
				deltaT=deltaT/bulletTimeMultiplyer;
				detectCollisions();
				fortress.draw(deltaT);
				
				for(i=0;i<shipBullets.length;i++)
				{
					shipBullets[i].draw(deltaT);
				}
				for(i=0;i<enemyBullets.length;i++)
				{
					enemyBullets[i].draw(deltaT);
				}
				ship.draw(deltaT);
			}
		}
		
		public function getShipPosition():Point
		{
			if(levelLoaded)
				return new Point(ship.x, ship.y);
			else
				return new Point();
		}
		
		public function loadLevel(level:int):void
		{
			if(LevelLoader.loaded)
			{
				levelLoaded=true;
				bulletTimeMultiplyer=1;
				clearWorld();
				
				createShip();
				createEnemyFortress(level);
				ship.radialDistance=fortress.getMaxRadius()+60;
			}
			else
			{
				setTimeout(loadLevel,500,level);
			}
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		private function createShip():void
		{
			ship=new Ship();
			ship.center=new Point(0,0);
			this.addChild(ship);
			ship.addEventListener(FortressEvent.SHIP_SHOT, onShipShot);
			ship.addEventListener(FortressEvent.SHIP_DESTROYED, onShipDestroyed);
			shipBullets=[];
			enemyBullets=[];
		}
		
		private function createEnemyFortress(level:int):void
		{
			fortress=new EnemyFortress(level);
			fortress.addEventListener(FortressEvent.BULLET_HIT_ARMOR, bulletHitArmor);
			fortress.addEventListener(FortressEvent.BULLET_REACHED_CENTER, onBulletReachCenter);
			fortress.addEventListener(FortressEvent.CORE_DESTROYED, onCoreDestroyed);
			fortress.addEventListener(FortressEvent.CANNON_SHOT, onCannonShot);
			this.addChild(fortress);
		}
		
		private function destroyShipBullet(bullet:ShipBullet):void
		{
			aux_array=[];
			for(i=0;i<shipBullets.length;i++)
			{
				if(bullet!=shipBullets[i])
					aux_array.push(shipBullets[i]);
			}
			shipBullets=aux_array;
			this.removeChild(bullet);
		}
		
		private function destroyEnemyBullet(bullet:EnemyBullet):void
		{
			aux_array=[];
			for(i=0;i<enemyBullets.length;i++)
			{
				if(bullet!=enemyBullets[i])
					aux_array.push(enemyBullets[i]);
			}
			enemyBullets=aux_array;
			this.removeChild(bullet);
		}
		
		private function detectCollisions():void
		{
			for(i=0;i<shipBullets.length;i++)
			{
				if(shipBullets[i].collisionRadialDistances[1] < fortress.getMaxRadius())
				{
					fortress.collidesWith(shipBullets[i] as ShipBullet);
				}
			}
			
			for(i=0;i<enemyBullets.length;i++)
			{
				if(enemyBullets[i].hitTestObject(ship.shipCore))
				{
					ship.takehit(0,50);
					destroyEnemyBullet(enemyBullets[i]);
				}
			}
			
			fortress.collidesWithShip(ship);
		}
		
		private function clearWorld():void
		{
			if(ship!=null && ship.parent)
			{
				ship.removeEventListener(FortressEvent.SHIP_SHOT, onShipShot);
				ship.removeEventListener(FortressEvent.SHIP_DESTROYED, onShipDestroyed);
				ship.parent.removeChild(ship);
			}
			if(fortress!=null && fortress.parent)
			{
				fortress.removeEventListener(FortressEvent.BULLET_HIT_ARMOR, bulletHitArmor);
				fortress.removeEventListener(FortressEvent.BULLET_REACHED_CENTER, onBulletReachCenter);
				fortress.removeEventListener(FortressEvent.CORE_DESTROYED, onCoreDestroyed);
				fortress.removeEventListener(FortressEvent.CANNON_SHOT, onCannonShot);
				fortress.parent.removeChild(fortress);
			}
			
			for(i=0;i<enemyBullets.length;i++)
			{
				this.removeChild(enemyBullets[i]);
			}
			
			enemyBullets=[];
			
			for(i=0;i<shipBullets.length;i++)
			{
				this.removeChild(shipBullets[i]);
			}
			
			shipBullets=[];
		}
		
		//------------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
		private function onShipShot(event:Event):void
		{
			aux_shipBullet=new ShipBullet(ship.angularPosition, ship.radialDistance-50);
			this.addChild(aux_shipBullet);
			shipBullets.push(aux_shipBullet);
			aux_shipBullet.addEventListener(FortressEvent.BULLET_REACHED_CENTER, onBulletReachCenter);
			SoundFX.play("laser"+Math.ceil(Math.random()*2.99));
		}
		
		private function onCannonShot(event:FortressEvent):void
		{
			aux_cannonBullet=new EnemyBullet(event.data.cannon.globalAngularPosition, event.data.cannon.radius+10);
			this.addChild(aux_cannonBullet);
			enemyBullets.push(aux_cannonBullet);
			if(enemyBullets.length>maxBullets)
			{
				destroyEnemyBullet(enemyBullets[0]);
			}
			SoundFX.play("laser"+Math.ceil(Math.random()*2.99));
		}
		
		private function onBulletReachCenter(event:FortressEvent):void
		{
			destroyShipBullet(event.data.bullet);
		}
		
		private function bulletHitArmor(event:FortressEvent):void
		{
			destroyShipBullet(event.data.bullet);
			SoundFX.play("armorHit");
		}
		
		private function onCoreDestroyed(event:FortressEvent):void
		{
			trace("BAKOOOOM! YOU SUNK MY BATTLESHIP")
			bulletTimeMultiplyer=1;
			TweenMax.to(this,1,{bulletTimeMultiplyer:25,yoyo:true,repeat:1});
			fortress.goBoom();
			SoundFX.play("coreExplosion");
		}
		
		private function onShipDestroyed(event:Event):void
		{
			bulletTimeMultiplyer=1;
			TweenMax.to(this,1,{bulletTimeMultiplyer:3});
		}
	}
}