//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.matching.instanceOfType;
	import robotlegs.bender.framework.api.IInjector;

	public class ConfigManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:Context;

		private var injector:IInjector;

		private var configManager:ConfigManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
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
			configManager.addConfigHandler(instanceOfType(String), new Function());
		}

		[Test]
		public function handler_is_called():void
		{
			const expected:String = "config";
			var actual:Object = null;
			configManager.addConfigHandler(instanceOfType(String), function(config:Object):void {
				actual = config;
			});
			configManager.addConfig(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function plain_config_class_added_before_initialization_is_not_immediately_instantiated():void
		{
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});

			configManager.addConfig(PlainConfig);

			assertThat(actual, nullValue());
		}

		[Test]
		public function plain_config_class_added_before_initialization_is_instantiated_at_initialization():void
		{
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});

			configManager.addConfig(PlainConfig);
			context.initialize();

			assertThat(actual, instanceOf(PlainConfig));
		}

		[Test]
		public function plain_config_class_added_after_initialization_is_immediately_instantiated():void
		{
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:PlainConfig):void {
				actual = config;
			});

			context.initialize();
			configManager.addConfig(PlainConfig);

			assertThat(actual, instanceOf(PlainConfig));
		}

		[Test]
		public function plain_config_object_added_before_initializiation_is_not_injected_into():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});

			configManager.addConfig(expected);

			assertThat(actual, nullValue());
		}

		[Test]
		public function plain_config_object_added_before_initializiation_is_injected_into_at_initialization():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});

			configManager.addConfig(expected);
			context.initialize();

			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function plain_config_object_added_after_initializiation_is_injected_into():void
		{
			const expected:PlainConfig = new PlainConfig();
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});

			context.initialize();
			configManager.addConfig(expected);

			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function configure_is_invoked_for_IConfig_object():void
		{
			const expected:TypedConfig = new TypedConfig();
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});
			configManager.addConfig(expected);
			context.initialize();
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function configure_is_invoked_for_IConfig_class():void
		{
			var actual:Object = null;
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual = config;
			});
			configManager.addConfig(TypedConfig);
			context.initialize();
			assertThat(actual, instanceOf(TypedConfig));
		}

		[Test]
		public function config_queue_is_processed_after_other_initialize_listeners():void
		{
			const actual:Array = [];
			injector.map(Function, 'callback').toValue(function(config:Object):void {
				actual.push('config');
			});
			configManager.addConfig(TypedConfig);
			context.whenInitializing(function():void {
				actual.push('listener1');
			});
			context.whenInitializing(function():void {
				actual.push('listener2');
			});
			context.initialize();
			assertThat(actual, array(['listener1', 'listener2', 'config']));
		}
	}
}

import robotlegs.bender.framework.api.IConfig;

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

class TypedConfig implements IConfig
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name='callback')]
	public var callback:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function configure():void
	{
		callback(this);
	}
}
