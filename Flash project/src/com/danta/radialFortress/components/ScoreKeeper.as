package com.danta.radialFortress.components
{
	public class ScoreKeeper
	{
		public static var scoreItems:Object;
		private static var itemNames:Array;
		private static var initialized:Boolean;
		
		public function ScoreKeeper()
		{
		}
		
		public static function initialize():void
		{
			if(!initialized)
			{
				initialized=true;
				scoreItems=new Object();
				itemNames=[];
			}
		}
		
		public static function addScoreItem(name:String, value:int):void
		{
			scoreItems[name].value=value;
			scoreItems[name].count=0;
			itemNames.push(name);
		}
		
		public static function addScore(name, count):void
		{
			scoreItems[name].count+=count;
		}
		
		public static function getTotalScore():uint
		{
			var totalScore:uint;
			for each(var name:String in itemNames)
			{
				totalScore+=scoreItems[name].count*scoreItems[name].value;
			}
			return totalScore;
		}
	}
}