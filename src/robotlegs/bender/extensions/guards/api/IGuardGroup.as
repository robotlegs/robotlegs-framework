//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.guards.api
{

	// TODO: move out of extensions and into core
	public interface IGuardGroup
	{
		function add(... guardClasses):void;

		function remove(... guardClasses):void;

		function approve():Boolean;
	}
}
