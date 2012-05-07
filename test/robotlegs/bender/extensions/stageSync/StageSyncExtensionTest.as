//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.stageSync
{
	import flash.display.DisplayObjectContainer;

	import mx.containers.Canvas;

	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.isTrue;

	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	public class StageSyncExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(ui)]
		public function before():void
		{
			context = new Context();
			contextView = new Canvas();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function adding_contextView_to_stage_initializes_context():void
		{
			context.extend(StageSyncExtension).configure(contextView);
			UIImpersonator.addChild(contextView);
			assertThat(context.lifecycle.initialized, isTrue());
		}

		[Test]
		public function adding_contextView_that_is_already_on_stage_initializes_context():void
		{
			UIImpersonator.addChild(contextView);
			context.extend(StageSyncExtension).configure(contextView);
			assertThat(context.lifecycle.initialized, isTrue());
		}

		[Test]
		public function removing_contextView_from_stage_destroys_context():void
		{
			context.extend(StageSyncExtension).configure(contextView);
			UIImpersonator.addChild(contextView);
			UIImpersonator.removeChild(contextView);
			assertThat(context.lifecycle.destroyed, isTrue());
		}
	}
}
