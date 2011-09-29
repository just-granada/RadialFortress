package com.danta.radialFortress.screens
{
	import com.danta.radialFortress.FortressEvent;
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

	public class LevelBeatScreen extends Sprite
	{
		private var fortressDestroyedLoader:Loader;
		private var nextLevelLoader:Loader;
		private var nextLevelReady:Boolean;
		private var nextLevelContainer:Sprite;
		
		public function LevelBeatScreen()
		{
			fortressDestroyedLoader=new Loader();
			fortressDestroyedLoader.load(new URLRequest("assets/levelPass.png"));
			fortressDestroyedLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onFortressDestroyedLoaded);
			
			nextLevelLoader=new Loader();
			nextLevelLoader.load(new URLRequest("assets/nextLevel.png"));
			nextLevelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNextLevelLoaded);
		}
		
		private function onFortressDestroyedLoaded(event:Event):void
		{
			this.addChild(fortressDestroyedLoader);
			fortressDestroyedLoader.alpha=0;
			fortressDestroyedLoader.x=-fortressDestroyedLoader.width/2;
			fortressDestroyedLoader.y=-fortressDestroyedLoader.height/2;
			TweenLite.to(fortressDestroyedLoader,1,{alpha:1, y:-200, onComplete:showNextLevel});
		}
		
		private function onNextLevelLoaded(event:Event):void
		{
			nextLevelReady=true;
		}
		
		private function showNextLevel():void
		{
			if(nextLevelReady)
			{
				nextLevelContainer=new Sprite();
				nextLevelContainer.buttonMode=true;
				nextLevelContainer.addChild(nextLevelLoader);
				this.addChild(nextLevelContainer);
				nextLevelContainer.alpha=0;
				nextLevelContainer.x=-nextLevelLoader.width/2;
				nextLevelContainer.y=-200;
				TweenLite.to(nextLevelContainer, 1,{y:50, alpha:1});
				
				nextLevelContainer.addEventListener(MouseEvent.CLICK, onNextLevelClick);
			}
			else
			{
				setTimeout(showNextLevel,200);
			}
		}
		
		private function onNextLevelClick(event:Event):void
		{
			dispatchEvent(new FortressEvent(FortressEvent.NEXT_LEVEL));
		}
	}
}