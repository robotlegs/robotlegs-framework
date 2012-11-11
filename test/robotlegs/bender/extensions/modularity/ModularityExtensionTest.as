//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
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
	import org.hamcrest.object.isTrue;

	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.stageSync.StageSyncExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.loggingSupport.CallbackLogTarget;

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

		private var rootAddedToStage:Boolean;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, ui)]
		public function setUp():void
		{
			rootAddedToStage = false;
			root = new UIComponent();
			parentView = new UIComponent();
			childView = new UIComponent();

			parentContext = new Context().install(StageSyncExtension, ContextViewExtension);
			childContext = new Context().install(StageSyncExtension, ContextViewExtension);
		}

		[After(async, ui)]
		public function tearDown():void
		{
			rootAddedToStage && UIImpersonator.removeChild(root);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(async, ui)]
		public function context_inherits_parent_injector():void
		{
			addRootToStage();
			parentContext.install(ModularityExtension).configure(new ContextView(parentView));
			childContext.install(ModularityExtension).configure(new ContextView(childView));
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, equalTo(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_not_interested():void
		{
			addRootToStage();
			parentContext.install(ModularityExtension).configure(new ContextView(parentView));
			childContext.install(new ModularityExtension(false)).configure(new ContextView(childView));
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test(async, ui)]
		public function context_does_not_inherit_parent_injector_when_disallowed_by_parent():void
		{
			addRootToStage();
			parentContext.install(new ModularityExtension(true, false)).configure(new ContextView(parentView));
			childContext.install(ModularityExtension).configure(new ContextView(childView));
			root.addChild(parentView);
			parentView.addChild(childView);
			assertThat(childContext.injector.parentInjector, not(parentContext.injector));
		}

		[Test]
		public function extension_logs_error_when_context_initialized_with_no_contextView():void
		{
			var errorLogged:Boolean = false;
			const logTarget:CallbackLogTarget = new CallbackLogTarget(
				function(log:Object):void {
					if (log.source['constructor'] == ModularityExtension && log.level == LogLevel.ERROR)
					{
						errorLogged = true;
					}
				});
			childContext.install(ModularityExtension);
			childContext.addLogTarget(logTarget);
			childContext.lifecycle.initialize();
			assertThat(errorLogged, isTrue());

		}

		[Test(async, ui)]
		public function child_added_to_viewManager_inherits_injector():void
		{
			addRootToStage();
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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addRootToStage():void
		{
			rootAddedToStage = true;
			UIImpersonator.addChild(root);
		}
	}
}
