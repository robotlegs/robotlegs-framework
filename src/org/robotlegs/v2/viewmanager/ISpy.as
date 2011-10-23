//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.viewmanager.tasks.ITaskHandler;

	public interface ISpy
	{

		function get listeningStrategy():IListeningStrategy;
		function set listeningStrategy(strategy:IListeningStrategy):void;

		function addInterest(target:DisplayObjectContainer, taskHandler:ITaskHandler):void;

		function removeInterest(target:DisplayObjectContainer, taskHandler:ITaskHandler):void;
	}

}
