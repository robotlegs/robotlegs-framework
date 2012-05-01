//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.ConfigManager;
	import robotlegs.bender.framework.impl.Context;

	public class ConfigManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		public var injector:Injector;

		private var configManager:ConfigManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			var context:Context = new Context();
			injector = context.injector;
			configManager = new ConfigManager(context);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

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
			var actual:Object = null;
			configManager.addConfigHandler(instanceOf(String), function(config:Object):void {
				actual = config;
			});
			configManager.addConfig(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function plain_config_class_is_instantiated_at_initialization():void
		{
			var actual:Object = null;
			configManager.addConfig(PlainConfig);
			injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});
			assertThat(actual, nullValue());
			configManager.initialize();
			assertThat(actual, instanceOf(PlainConfig));
		}

		[Test]
		public function plain_config_class_is_instantiated_after_initialization():void
		{
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});
			configManager.initialize();
			configManager.addConfig(PlainConfig);
			assertThat(actual, instanceOf(PlainConfig));
		}

		[Test]
		public function plain_config_object_is_injected_into_at_initialization():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object = null;
			configManager.addConfig(expected);
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});
			assertThat(actual, nullValue());
			configManager.initialize();
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function plain_config_object_is_injected_into_after_initialization():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object = null;
			configManager.initialize();
			injector.map(Function, 'callback').toValue(function(config:Object):void {
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
