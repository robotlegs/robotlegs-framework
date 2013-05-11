//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
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
			context.install(StageSyncExtension).configure(new ContextView(contextView));
			UIImpersonator.addChild(contextView);
			assertThat(context.initialized, isTrue());
		}

		[Test]
		public function adding_contextView_that_is_already_on_stage_initializes_context():void
		{
			UIImpersonator.addChild(contextView);
			context.install(StageSyncExtension).configure(new ContextView(contextView));
			assertThat(context.initialized, isTrue());
		}

		[Test]
		public function removing_contextView_from_stage_destroys_context():void
		{
			context.install(StageSyncExtension).configure(new ContextView(contextView));
			UIImpersonator.addChild(contextView);
			UIImpersonator.removeChild(contextView);
			assertThat(context.destroyed, isTrue());
		}
	}
}
