//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.impl
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.impl.Context;

	public class ContextTests
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[Test(expects='Error')]
		public function destroy_should_throw_if_called_twice():void
		{
			context.destroy();
			context.destroy();
		}

		[Test(expects='Error')]
		public function initialize_should_throw_if_called_twice():void
		{
			context.initialize();
			context.initialize();
		}


		[Before]
		public function setUp():void
		{
			context = new Context();
		}

		[After]
		public function tearDown():void
		{
			context = null;
		}
	}
}
