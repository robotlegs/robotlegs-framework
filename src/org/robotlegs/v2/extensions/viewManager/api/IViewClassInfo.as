//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.api
{
	import flash.system.ApplicationDomain;

	public interface IViewClassInfo
	{
		function get applicationDomain():ApplicationDomain;
		function get fqcn():String;
		function get type():Class;
		function get typeNames():Vector.<String>;

		function isType(type:Class):Boolean;
	}
}
