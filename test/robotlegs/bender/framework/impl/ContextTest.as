//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import org.hamcrest.text.containsString;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.LifecycleEvent;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.api.PinEvent;
	import robotlegs.bender.framework.impl.contextSupport.CallbackConfig;
	import robotlegs.bender.framework.impl.contextSupport.CallbackExtension;
	import robotlegs.bender.framework.impl.loggingSupport.CallbackLogTarget;
	import robotlegs.bender.framework.impl.loggingSupport.LogParams;

	public class ContextTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_instantiate():void
		{
			assertThat(context, isA(IContext));
		}

		[Test]
		public function extensions_are_installed():void
		{
			var actual:IContext = null;
			const extension:IExtension = new CallbackExtension(
				function(error:Object, context:IContext):void {
					actual = context;
				});
			context.install(extension);
			assertThat(actual, equalTo(context));
		}

		[Test]
		public function configs_are_installed():void
		{
			var installed:Boolean = false;
			const config:IConfig = new CallbackConfig(
				function():void {
					installed = true;
				});
			context.configure(config);
			context.initialize();
			assertThat(installed, isTrue());
		}

		[Test]
		public function injector_is_mapped_into_itself():void
		{
			const injector:IInjector = context.injector.getInstance(IInjector);
			assertThat(injector, strictlyEqualTo(context.injector));
		}

		[Test]
		public function detain_stores_the_instance():void
		{
			const expected:Object = {};
			var actual:Object;
			var handler:Function = function(event:PinEvent):void {
				actual = event.instance;
			};
			context.addEventListener(PinEvent.DETAIN, handler);

			context.detain(expected);

			assertThat(actual, strictlyEqualTo(expected));
		}

		[Test]
		public function release_frees_up_the_instance():void
		{
			const expected:Object = {};
			var actual:Object;
			var handler:Function = function(event:PinEvent):void {
				actual = event.instance;
			};
			context.addEventListener(PinEvent.RELEASE, handler);
			context.detain(expected);

			context.release(expected);

			assertThat(actual, strictlyEqualTo(expected));
		}

		[Test]
		public function addChild_sets_child_parentInjector():void
		{
			const child:Context = new Context();
			context.addChild(child);
			assertThat(child.injector.parent, equalTo(context.injector));
		}

		[Test]
		public function addChild_logs_warning_unless_child_is_uninitialized():void
		{
			var warning:LogParams = null;
			context.addLogTarget(new CallbackLogTarget(
				function(log:LogParams):void {
					(log.level == LogLevel.WARN) && (warning = log);
				}));
			const child:Context = new Context();
			child.initialize();
			context.addChild(child);
			assertThat(warning.message, containsString("must be uninitialized"));
			assertThat(warning.params, array(child));
		}

		[Test]
		public function addChild_logs_warning_if_child_parentInjector_is_already_set():void
		{
			var warning:LogParams = null;
			context.addLogTarget(new CallbackLogTarget(
				function(log:LogParams):void {
					(log.level == LogLevel.WARN) && (warning = log);
				}));
			const child:Context = new Context();
			child.injector.parent = new RobotlegsInjector();
			context.addChild(child);
			assertThat(warning.message, containsString("must not have a parent Injector"));
			assertThat(warning.params, array(child));
		}

		[Test]
		public function removeChild_logs_warning_if_child_is_NOT_a_child():void
		{
			var warning:LogParams = null;
			context.addLogTarget(new CallbackLogTarget(
				function(log:LogParams):void {
					(log.level == LogLevel.WARN) && (warning = log);
				}));
			const child:Context = new Context();
			context.removeChild(child);
			assertThat(warning.message, containsString("must be a child"));
			assertThat(warning.params, array(child, context));
		}

		[Test]
		public function removesChild_clears_child_parentInjector():void
		{
			const child:Context = new Context();
			context.addChild(child);
			context.removeChild(child);
			assertThat(child.injector.parent, nullValue());
		}

		[Test]
		public function child_is_removed_when_child_is_destroyed():void
		{
			const child:Context = new Context();
			context.addChild(child);
			child.initialize();
			child.destroy();
			assertThat(child.injector.parent, nullValue());
		}

		[Test]
		public function children_are_removed_when_parent_is_destroyed():void
		{
			const child1:Context = new Context();
			const child2:Context = new Context();
			context.addChild(child1);
			context.addChild(child2);
			context.initialize();
			context.destroy();
			assertThat(child1.injector.parent, nullValue());
			assertThat(child2.injector.parent, nullValue());
		}

		[Test]
		public function removed_child_is_not_removed_again_when_destroyed():void
		{
			var warning:LogParams = null;
			context.addLogTarget(new CallbackLogTarget(
				function(log:LogParams):void {
					(log.level == LogLevel.WARN) && (warning = log);
				}));
			const child:Context = new Context();
			context.addChild(child);
			child.initialize();
			context.removeChild(child);
			child.destroy();
			assertThat(warning, nullValue());
		}

		[Test]
		public function lifecycleEvents_are_propagated():void
		{
			const actual:Array = [];
			const expected:Array = [LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE,
				LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND,
				LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME,
				LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY];
			function handler(event:LifecycleEvent):void {
				actual.push(event.type);
			}
			for each (var type:String in expected)
			{
				context.addEventListener(type, handler);
			}
			context.initialize();
			context.suspend();
			context.resume();
			context.destroy();
			assertThat(actual, array(expected));
		}

		[Test]
		public function lifecycleStateChangeEvent_is_propagated():void
		{
			var called:Boolean = false;
			context.addEventListener(LifecycleEvent.STATE_CHANGE, function(event:LifecycleEvent):void {
				called = true;
			});
			context.initialize();
			assertThat(called, isTrue());
		}
	}
}
