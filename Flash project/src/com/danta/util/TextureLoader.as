package com.danta.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class TextureLoader
	{
		[Embed(source="assets/HardMetalTexture.jpg")]
		private static var hardMetalClass:Class;
		private static var hardMetalAsset:Bitmap = Bitmap(new hardMetalClass());
		private static var textures:Object={hardMetal:hardMetalAsset};
		
		public function TextureLoader()
		{
		}
		
		public static function getTexture(name:String):BitmapData
		{
			return textures[name].bitmapData;
		}
	}
}