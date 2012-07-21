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
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	import StageAccessor;

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

			parentContext = new Context().extend(StageSyncExtension, ContextViewExtension);
			childContext = new Context().extend(StageSyncExtension, ContextViewExtension);
		}

		[After(async, ui)]
		public function tearDown():void
		{
			StageAccessor.removeChild(root);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(async, ui)]
		public function context_inherits_parent_injector():void
		{
			StageAccessor.addChild(root);
			parentContext.extend(ModularityExtension).configure(parentView);
			childContext.extend(ModularityExtension).configure(childView);
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, equalTo(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_not_interested():void
		{
			StageAccessor.addChild(root);
			parentContext.extend(ModularityExtension).configure(parentView);
			childContext.extend(new ModularityExtension(false)).configure(childView);
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_disallowed_by_parent():void
		{
			StageAccessor.addChild(root);
			parentContext.extend(new ModularityExtension(true, false)).configure(parentView);
			childContext.extend(ModularityExtension).configure(childView);
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(expects="Error")]
		public function extension_throws_if_context_initialized_with_no_contextView():void
		{
			childContext.extend(ModularityExtension);
			childContext.lifecycle.initialize();
		}

		[Test]
		public function child_added_to_viewManager_inherits_injector():void
		{
			StageAccessor.addChild(root);
			parentContext = new Context().extend(
				ContextViewExtension,
				ModularityExtension,
				ViewManagerExtension,
				StageSyncExtension)
				.configure(parentView);

			const viewManager:IViewManager =
				parentContext.injector.getInstance(IViewManager);
			viewManager.addContainer(childView);

			childContext = new Context().extend(
				ContextViewExtension,
				ModularityExtension,
				StageSyncExtension)
				.configure(childView);

			root.addChild(parentView);
			root.addChild(childView);

			assertThat(childContext.injector.parentInjector,
				equalTo(parentContext.injector));
		}
	}
}