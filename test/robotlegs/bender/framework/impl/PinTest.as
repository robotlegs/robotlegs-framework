//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{

	public class PinTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var pin:Pin;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			pin = new Pin();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function detain_is_pretty_much_untestable():void
		{
			// note: this *can* be tested - it's just really, really gross
			pin.detain({});
		}

		[Test]
		public function release_is_pretty_much_untestable():void
		{
			// note: this *can* be tested - it's just really, really gross
			pin.release({});
		}

		[Test]
		public function flush_is_pretty_much_untestable():void
		{
			// note: this *can* be tested - it's just really, really gross
			pin.flush();
		}
	}
}
