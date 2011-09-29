package com.danta.util
{
	import flash.media.Sound;

	public class SoundFX
	{
		[Embed(source="assets/sounds/laser1.mp3")]
		private static var laser1Class:Class;
		[Embed(source="assets/sounds/laser2.mp3")]
		private static var laser2Class:Class;
		[Embed(source="assets/sounds/laser3.mp3")]
		private static var laser3Class:Class;
		[Embed(source="assets/sounds/shipHit.mp3")]
		private static var shipHitClass:Class;
		[Embed(source="assets/sounds/armorHit.mp3")]
		private static var armorHitClass:Class;
		[Embed(source="assets/sounds/coreExplosion.mp3")]
		private static var coreExplosionClass:Class;
		
		private static var laser1:Sound;
		private static var laser2:Sound;
		private static var laser3:Sound;
		private static var shipHit:Sound;
		private static var armorHit:Sound;
		private static var coreExplosion:Sound;
		
		private static var sounds:Object;
		private static var initialized:Boolean;
		
		public function SoundFX()
		{
		}
		
		public static function initialize():void
		{
			if(!initialized)
			{
				laser1=new laser1Class() as Sound;
				laser2=new laser2Class() as Sound;
				laser3=new laser3Class() as Sound;
				shipHit=new shipHitClass() as Sound;
				armorHit=new armorHitClass() as Sound;
				coreExplosion=new coreExplosionClass() as Sound;
				
				sounds={laser1:laser1, laser2:laser2, laser3:laser3, shipHit:shipHit, armorHit:armorHit, coreExplosion:coreExplosion};
				
				initialized=true;
			}
		}
		
		public static function play(soundId:String):void
		{
			if(initialized)
			{
				sounds[soundId].play(0,1);	
			}
		}
	}
}