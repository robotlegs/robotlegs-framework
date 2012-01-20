//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.config.manager.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.framework.config.manager.api.IConfigManager;
	import robotlegs.bender.framework.config.manager.support.CallbackContextConfig;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	import robotlegs.bender.framework.context.impl.Context;

	public class ConfigManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var configManager:ConfigManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			configManager = new ConfigManager(context);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_instantiate():void
		{
			assertThat(configManager, instanceOf(IConfigManager));
		}

		[Test]
		public function addConfig():void
		{
			configManager.addConfig({});
		}

		[Test]
		public function addHandler():void
		{
			configManager.addConfigHandler(instanceOf(String), new Function());
		}

		[Test]
		public function handler_is_called():void
		{
			const expected:String = "config";
			var actual:Object;
			configManager.addConfigHandler(instanceOf(String), function(config:Object):void {
				actual = config;
			});
			configManager.addConfig(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function IContextConfig_instance_is_configured():void
		{
			var actual:IContext;
			const config:IContextConfig = new CallbackContextConfig(function(error:Object, context:IContext):void {
				actual = context;
			});
			configManager.addConfig(config);
			assertThat(actual, equalTo(this.context));
		}

		[Test]
		public function IContextConfig_class_is_configured():void
		{
			var actual:IContextConfig;
			configManager.addConfigHandler(instanceOf(IContextConfig), function(config:IContextConfig):void {
				actual = config;
			});
			configManager.addConfig(CallbackContextConfig);
			assertThat(actual, instanceOf(CallbackContextConfig));
		}

		[Test]
		public function IContextConfig_is_only_installed_once():void
		{
			var callCount:int;
			const config:IContextConfig = new CallbackContextConfig(function():void {
				callCount++;
			});
			configManager.addConfig(config);
			configManager.addConfig(config);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function IContextConfig_class_is_only_installed_once():void
		{
			var callCount:int;
			configManager.addConfigHandler(instanceOf(IContextConfig), function():void {
				callCount++;
			});
			configManager.addConfig(CallbackContextConfig);
			configManager.addConfig(CallbackContextConfig);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function plain_config_class_is_instantiated_at_context_initialization():void
		{
			var actual:Object;
			configManager.addConfig(PlainConfig);
			context.injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});
			assertThat(actual, nullValue());
			context.initialize();
			assertThat(actual, instanceOf(PlainConfig));
		}

		[Test]
		public function plain_config_class_is_instantiated_after_context_initialization():void
		{
			var actual:Object;
			context.initialize();
			context.injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});
			configManager.addConfig(PlainConfig);
			assertThat(actual, instanceOf(PlainConfig));
		}

		[Test]
		public function plain_config_object_is_injected_into_at_context_initialization():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object;
			configManager.addConfig(expected);
			context.injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});
			assertThat(actual, nullValue());
			context.initialize();
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function plain_config_object_is_injected_into_after_context_initialization():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object;
			context.initialize();
			context.injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});
			configManager.addConfig(expected);
			assertThat(actual, equalTo(expected));
		}
	}
}

class PlainConfig
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name='callback')]
	public var callback:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	[PostConstruct]
	public function init():void
	{
		callback(this);
	}
}
