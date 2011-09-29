package com.danta.radialFortress.components
{
	import com.danta.util.ArcHelper;
	import com.danta.util.TextureLoader;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.geom.Matrix;

	public class HardArmorPiece extends ArmorPiece
	{
		public function HardArmorPiece(radius:Number, radialThickness:Number=20, angularPosition:Number=0, angularWidth:Number=30, angularVelocity:Number=1, color:uint=0, startingEnergy:int=75)
		{
			super(radius, radialThickness, angularPosition, angularWidth, angularVelocity, color, startingEnergy);
		}
		
		private var matrix:Matrix;
		
		override public function draw(deltaT:Number):void
		{
			if(!arcDrawn || currentState!=NORMAL)
			{
				this.radius += radialVelocity*deltaT;
				this.graphics.clear();
				matrix=new Matrix;
				matrix.rotate(-_angularPosition);
				this.graphics.beginBitmapFill(TextureLoader.getTexture("hardMetal"),matrix,true,true);
				ArcHelper.drawArc(this, radius-radialDepth/2, radius+radialDepth/2, _angularPosition-angularWidth/2, _angularPosition+angularWidth/2);
				this.graphics.endFill();
				this.graphics.beginFill(0,0.3);
				ArcHelper.drawArc(this, radius-radialDepth/2, radius-radialDepth/2+6, _angularPosition-angularWidth/2, _angularPosition+angularWidth/2);
				this.graphics.endFill();
				this.graphics.beginFill(0xffffff,0.3);
				ArcHelper.drawArc(this, radius+radialDepth/2-6, radius+radialDepth/2, _angularPosition-angularWidth/2, _angularPosition+angularWidth/2);
				this.graphics.endFill();
				arcDrawn=true;
				this.alpha=1;
				
				if(radius < 15)
				{
					currentState=EXPLODE;
					radialVelocity=0;
					TweenMax.killTweensOf(this);
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
		
		override public function collidesWith(bullet:ShipBullet):Boolean
		{
			if(Math.abs(bullet.angularPosition-this.globalAngularPosition) < (4*angularWidth/6) && Math.abs(bullet.radialDistance-this.radius)<(1.5*this.radialDepth) && currentState==NORMAL)
			{
				trace("bullet hit armor: ",this.name)
				return true;
			}
			
			return false;
		}
		
	}
}