//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity
{
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.stageSync.StageSyncExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	public class ModularityExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var container:UIComponent;

		private var parentView:UIComponent;

		private var childView:UIComponent;

		private var parentContext:IContext;

		private var childContext:IContext;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, ui)]
		public function setUp():void
		{
			container = new UIComponent();
			parentView = new UIComponent();
			childView = new UIComponent();

			parentContext = new Context().extend(StageSyncExtension, ContextViewExtension);
			childContext = new Context().extend(StageSyncExtension, ContextViewExtension);

			container.addChild(parentView);
			parentView.addChild(childView);
		}

		[After(async, ui)]
		public function tearDown():void
		{
			UIImpersonator.removeChild(container);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(async, ui)]
		public function context_inherits_parent_injector():void
		{
			parentContext.extend(ModularityExtension).configure(parentView);
			childContext.extend(ModularityExtension).configure(childView);

			UIImpersonator.addChild(container);
			assertThat(childContext.injector.parentInjector, equalTo(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_not_interested():void
		{
			parentContext.extend(ModularityExtension).configure(parentView);
			childContext.extend(new ModularityExtension(false)).configure(childView);

			UIImpersonator.addChild(container);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_disallowed_by_parent():void
		{
			parentContext.extend(new ModularityExtension(true, false)).configure(parentView);
			childContext.extend(ModularityExtension).configure(childView);

			UIImpersonator.addChild(container);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(expects="Error")]
		public function extension_throws_if_context_initialized_with_no_contextView():void
		{
			childContext.extend(ModularityExtension);
			childContext.lifecycle.initialize();
		}
	}
}
