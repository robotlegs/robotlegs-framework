//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging.impl
{

	public class LogMessageParser
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function parseMessage(message:String, params:Array):String
		{
			if (params)
			{
				const numParams:int = params.length;
				for (var i:int = 0; i < numParams; ++i)
				{
					message = message.split("{" + i + "}").join(params[i]);
				}
			}
			return message;
		}
	}
}
