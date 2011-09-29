package com.danta.radialFortress.components
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LevelLoader
	{
		private static var loader:URLLoader;
		private static var dataXML:XML;
		private static var initialized:Boolean;
		public static var loaded:Boolean;
		
		public function LevelLoader()
		{
		}
		
		public static function initialize():void
		{
			if(!initialized)
			{
				initialized=true;
				loader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.load(new URLRequest("xml/levels.xml"));
			}
		}
		
		private static function onLoadComplete(event:Event):void
		{
			dataXML= new XML(loader.data);
			loaded=true;
		}
		
		private static function onLoadError(event:IOErrorEvent):void
		{
			trace("Error loading levels file: ",event.text);
		}
		
		public static function getLevelData(level:int):XML
		{
			if(loaded)
				return dataXML.level.(int(@id)==level)[0];
			else
				return null
		}
	}
}