package com.danta.radialFortress.components
{
	import com.danta.radialFortress.FortressEvent;
	import com.danta.radialfortress.lib.CoreSprite;
	import com.danta.radialfortress.lib.Rayo1;
	import com.danta.radialfortress.lib.Rayo2;
	import com.danta.radialfortress.lib.Rayo3;
	import com.danta.radialfortress.lib.Rayo4;
	import com.danta.util.ArcHelper;
	import com.greensock.TweenMax;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;
	
	import mx.core.BitmapAsset;
	
	public class EnemyCore extends Sprite
	{
		public function EnemyCore()
		{
			coreSprite= new CoreSprite();
			coreContainer.addChild(coreSprite);
			arcClass=[];
			arcClass[0]=Rayo1;
			arcClass[1]=Rayo2;
			arcClass[2]=Rayo3;
			arcClass[3]=Rayo4;
			
			arcs=[];
			this.addChild(coreContainer);
		}
		
		private var coreContainer:Sprite = new Sprite();
		private var coreSprite:CoreSprite;
		private var CoreAngularPosition:Number=0;
		private var ShieldAngularPosition:Number=0;
		private var CoreAngularVelocity:Number = 0.0003;
		private var ShieldAngularVelocity:Number = - 0.00016;
		private var _life:int = 100;
		private var cmFilter:ColorMatrixFilter;
		private var isDead:Boolean;
		private var arcClass:Array;
		private var arcChance:Number=0.03;
		private var arcs:Array;
		
		
		public function draw(deltaT:Number):void
		{
			CoreAngularPosition += CoreAngularVelocity*deltaT;
			ShieldAngularPosition += ShieldAngularVelocity*deltaT;
			
			coreSprite.crystal.rotation=-ArcHelper.toDeg(CoreAngularPosition);
			if(Math.random()<arcChance)
			{
				addArc();
			}
		}
		
		public function takeHit(amount:int):void
		{
			_life-=amount;
			
			if(_life<=0 && !isDead)
			{
				isDead=true;
				TweenMax.to(this, 1,{tint:0x880000, blurFilter:{blurX:10, blurY:10, quality:3},alpha:0});
				coreSprite.crystal.play();
				dispatchEvent(new FortressEvent(FortressEvent.CORE_DESTROYED,true));
			}
			else if(!isDead)
			{
				coreSprite.crystal.play();
			}
		}
		
		private function addArc():void
		{
			var arc:MovieClip= new arcClass[Math.floor(Math.random()*4)]();
			arc.rotation=Math.random()*360;
			arc.filters=[new GlowFilter(0x00ccff,4,6,6)];
			coreContainer.addChild(arc);
			arcs.push(arc);
			setTimeout(removeArc,400+Math.random()*400);
		}
		
		private function removeArc():void
		{
			if(arcs.length>0)
			{
				var arc:MovieClip=arcs.shift();
				coreContainer.removeChild(arc);
			}
		}
	}
}