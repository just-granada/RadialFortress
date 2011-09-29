package com.danta.radialFortress.screens
{
	import com.danta.radialFortress.FortressEvent;
	import com.danta.radialFortress.components.GameWorld;
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class GameOverScreen extends Sprite
	{
		
		private var gameOverHeader:Loader;
		private var tryAgainLoader:Loader
		private var tryAgainReady:Boolean;
		private var tryAgainContainer:Sprite;
		
		public function GameOverScreen()
		{
			gameOverHeader=new Loader();
			gameOverHeader.load(new URLRequest("assets/GameOver.png"));
			gameOverHeader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			
			tryAgainLoader=new Loader();
			tryAgainLoader.load(new URLRequest("assets/TryAgain.png"));
			tryAgainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTryAgainLoadComplete);
		}
		
		private function onLoadComplete(event:Event):void
		{
			this.addChild(gameOverHeader);
			gameOverHeader.alpha=0;
			gameOverHeader.x=-gameOverHeader.width/2;
			gameOverHeader.y=-gameOverHeader.height/2;
			TweenLite.to(gameOverHeader,1,{alpha:1, y:-200, onComplete:showTryAgain});
		}
		
		private function onTryAgainLoadComplete(event:Event):void
		{
			tryAgainReady=true;
		}
		
		private function showTryAgain():void
		{
			if(tryAgainReady)
			{
				tryAgainContainer=new Sprite();
				tryAgainContainer.buttonMode=true;
				tryAgainContainer.addChild(tryAgainLoader);
				this.addChild(tryAgainContainer);
				tryAgainContainer.alpha=0;
				tryAgainContainer.x=-tryAgainLoader.width/2;
				tryAgainContainer.y=-200;
				TweenLite.to(tryAgainContainer, 1,{y:50, alpha:1});
				
				tryAgainContainer.addEventListener(MouseEvent.CLICK, onTryAgainClick);
			}
			else
			{
				setTimeout(showTryAgain,200);
			}
		}
		
		private function onTryAgainClick(event:Event):void
		{
			dispatchEvent(new FortressEvent(FortressEvent.TRY_AGAIN));
		}
	}
}