//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl.loggingSupport
{

	public class LogParams
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var source:Object;

		public var level:uint;

		public var timestamp:int;

		public var message:String;

		public var params:Array;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function LogParams(source:Object, level:uint, timestamp:int, message:String, params:Array)
		{
			this.source = source;
			this.level = level;
			this.timestamp = timestamp;
			this.message = message;
			this.params = params;
		}
	}
}
