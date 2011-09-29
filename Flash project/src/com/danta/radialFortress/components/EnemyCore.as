package com.danta.radialFortress.components
{
	import com.danta.radialFortress.FortressEvent;
	import com.danta.util.ArcHelper;
	import com.greensock.TweenMax;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	
	import mx.core.BitmapAsset;
	
	public class EnemyCore extends Sprite
	{
		public function EnemyCore()
		{
			coreContainer.addChild(CoreAsset);
			shieldContainer.addChild(CoreShieldAsset);
			
			CoreAsset.x=-CoreAsset.width/2;
			CoreAsset.y=-CoreAsset.height/2;
			
			CoreShieldAsset.x=-CoreShieldAsset.width/2;
			CoreShieldAsset.y=-CoreShieldAsset.height/2;
			
			CoreAsset.cacheAsBitmap=true;
			CoreAsset.smoothing=true;
			
			CoreShieldAsset.cacheAsBitmap=true;
			CoreShieldAsset.smoothing=true;
			
			this.addChild(coreContainer);
			this.addChild(shieldContainer);
			shieldContainer.blendMode=BlendMode.HARDLIGHT;
		}
		
		[Embed(source="assets/Core.png")]
		private var CoreAssetClass:Class;
		[Embed(source="assets/CoreShield.png")]
		private var CoreShieldAssetClass:Class;
		
		private var CoreAsset:BitmapAsset = BitmapAsset(new CoreAssetClass());
		private var CoreShieldAsset:BitmapAsset = BitmapAsset(new CoreShieldAssetClass());
		
		private var coreContainer:Sprite = new Sprite();
		private var shieldContainer:Sprite = new Sprite();
		
		private var CoreAngularPosition:Number=0;
		private var ShieldAngularPosition:Number=0;
		private var CoreAngularVelocity:Number = 0.0001;
		private var ShieldAngularVelocity:Number = - 0.00016;
		private var _life:int = 100;
		private var cmFilter:ColorMatrixFilter;
		private var isDead:Boolean;
		
		
		public function draw(deltaT:Number):void
		{
			CoreAngularPosition += CoreAngularVelocity*deltaT;
			ShieldAngularPosition += ShieldAngularVelocity*deltaT;
			
			coreContainer.rotation=-ArcHelper.toDeg(CoreAngularPosition);
			shieldContainer.rotation=-ArcHelper.toDeg(ShieldAngularPosition);
		}
		
		public function takeHit(amount:int):void
		{
			_life-=amount;
			
			if(_life<=0 && !isDead)
			{
				isDead=true;
				TweenMax.to(this, 1,{tint:0xffffff, blurFilter:{blurX:10, blurY:10, quality:3},alpha:0});
				dispatchEvent(new FortressEvent(FortressEvent.CORE_DESTROYED,true));
			}
			else if(!isDead)
			{
				TweenMax.to(this,0.5,{yoyo:true, tint:0xffffff, repeat:3});
			}
		}
		
	}
}