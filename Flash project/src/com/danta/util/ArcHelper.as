////////////////////////////////////////////////////////////////////////////////
//
//  Zemoga Inc
//  Copyright 2011 Zemoga Inc
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package com.danta.util
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * Class description here
	 * 
	 * @author	camilosoto	<email>
	 */
	public class ArcHelper
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
		
		public static function toDeg(rad:Number):Number
		{
			return 180*(rad/Math.PI);
		}
		
		public static function toRad(deg:Number):Number
		{
			return Math.PI*(deg/180);
		}
		
		public static function drawArc(target:Sprite, innerRadius:Number, outerRadius:Number, angleStart:Number, angleEnd:Number, subdivs:int=5):void
		{
			var i:int;
			var angleDist:Number=angleEnd-angleStart;
			
			if(innerRadius>0)
			{
				target.graphics.moveTo(Math.sin(angleStart)*innerRadius,Math.cos(angleStart)*innerRadius); //move to the initial point
				target.graphics.lineTo(Math.sin(angleStart)*outerRadius,Math.cos(angleStart)*outerRadius); //draw the first radius
				for(i=1; i<=subdivs; i++) // draw the outer arc
				{
					target.graphics.lineTo(Math.sin(angleStart + i*angleDist/subdivs)*outerRadius,Math.cos(angleStart + i*angleDist/subdivs)*outerRadius);
				}
				target.graphics.lineTo(Math.sin(angleEnd)*innerRadius, Math.cos(angleEnd)*innerRadius); //draw the second radius
				for(i=1; i<=subdivs; i++) // draw the inner arc
				{
					target.graphics.lineTo(Math.sin(angleEnd - i*angleDist/subdivs)*innerRadius,Math.cos(angleEnd - i*angleDist/subdivs)*innerRadius);
				}
			}	
			else
			{
				target.graphics.moveTo(0,0);
				target.graphics.lineTo(Math.sin(angleStart)*outerRadius,Math.cos(angleStart)*outerRadius); //draw the first radius
				for(i=1; i<=subdivs; i++) // draw the aouter arc
				{
					target.graphics.lineTo(Math.sin(angleStart + i*angleDist/subdivs)*outerRadius,Math.cos(angleStart + i*angleDist/subdivs)*outerRadius);
				}
				target.graphics.lineTo(0,0); //draw the second radius
			}
		}
		
		public static function normalize(angle:Number):Number
		{
			if(angle<0)
			{
				return 2*Math.PI+angle;
			}
			else if(angle >Math.PI*2)
			{
				return angle - Math.PI*2;
			}
			return angle;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//  Constructor
		//
		////////////////////////////////////////////////////////////////////////////////
		
		public function ArcHelper()
		{
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
		
		
		//------------------------------------------------------------------------------
		//
		//  Properties (getters/setters)
		//
		//------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------
		//
		//  Methods
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
		//  Event Handlers
		//
		//------------------------------------------------------------------------------
		
	}
}