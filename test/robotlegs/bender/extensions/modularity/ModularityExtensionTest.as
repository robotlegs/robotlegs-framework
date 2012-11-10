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

	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.stageSync.StageSyncExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	public class ModularityExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var root:UIComponent;

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
			root = new UIComponent();
			parentView = new UIComponent();
			childView = new UIComponent();

			parentContext = new Context().install(StageSyncExtension, ContextViewExtension);
			childContext = new Context().install(StageSyncExtension, ContextViewExtension);
		}

		[After(async, ui)]
		public function tearDown():void
		{
			UIImpersonator.removeChild(root);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(async, ui)]
		public function context_inherits_parent_injector():void
		{
			UIImpersonator.addChild(root);
			parentContext.install(ModularityExtension).configure(new ContextView(parentView));
			childContext.install(ModularityExtension).configure(new ContextView(childView));
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, equalTo(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_not_interested():void
		{
			UIImpersonator.addChild(root);
			parentContext.install(ModularityExtension).configure(new ContextView(parentView));
			childContext.install(new ModularityExtension(false)).configure(new ContextView(childView));
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_disallowed_by_parent():void
		{
			UIImpersonator.addChild(root);
			parentContext.install(new ModularityExtension(true, false)).configure(new ContextView(parentView));
			childContext.install(ModularityExtension).configure(new ContextView(childView));
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(expects="Error")]
		public function extension_throws_if_context_initialized_with_no_contextView():void
		{
			childContext.install(ModularityExtension);
			childContext.lifecycle.initialize();
		}

		[Test(async, ui)]
		public function child_added_to_viewManager_inherits_injector():void
		{
			UIImpersonator.addChild(root);
			parentContext = new Context().install(
				ContextViewExtension,
				ModularityExtension,
				ViewManagerExtension,
				StageSyncExtension)
				.configure(new ContextView(parentView));

			const viewManager:IViewManager =
				parentContext.injector.getInstance(IViewManager);
			viewManager.addContainer(childView);

			childContext = new Context().install(
				ContextViewExtension,
				ModularityExtension,
				StageSyncExtension)
				.configure(new ContextView(childView));

			root.addChild(parentView);
			root.addChild(childView);

			assertThat(childContext.injector.parentInjector,
				equalTo(parentContext.injector));
		}
	}
}
