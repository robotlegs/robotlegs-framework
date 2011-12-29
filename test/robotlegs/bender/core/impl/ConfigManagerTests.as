//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.core.api.IContext;
	import org.swiftsuspenders.Injector;

	public class ConfigManagerTests
	{
		private var injector:Injector;

		private var context:IContext;

		private var manager:ConfigManager;

		[Before]
		public function setUp():void
		{
			injector = new Injector()
			context = new SupportContext(injector);
			manager = new ConfigManager(context);
		}

		[After]
		public function tearDown():void
		{
			manager = null;
		}

		[Test]
		public function config_is_stored():void
		{
			manager.addConfig(NullConfig);
			assertThat(manager.hasConfig(NullConfig), isTrue());
		}

		[Test]
		public function config_is_removed():void
		{
			manager.addConfig(NullConfig);
			manager.removeConfig(NullConfig);
			assertThat(manager.hasConfig(NullConfig), isFalse());
		}

		[Test]
		public function destroy_removes_all_configs():void
		{
			manager.addConfig(NullConfig);
			manager.initialize();
			manager.destroy();
			assertThat(manager.hasConfig(NullConfig), isFalse());
		}

		[Test]
		public function config_is_configured_during_manager_initialization():void
		{
			var configureCount:uint = 0;
			injector.map(Function, 'configureCallback').toValue(function(... r):void
			{
				configureCount++;
			});
			manager.addConfig(SelfReportingCallbackConfig);
			manager.initialize();
			assertThat(configureCount, equalTo(1));
		}

		[Test]
		public function config_is_injected_into_during_manager_initialization():void
		{
			const sprite:Sprite = new Sprite();
			injector.map(Sprite).toValue(sprite);
			var configInstance:InjectableSelfReportingCallbackConfig;
			injector.map(Function, 'configureCallback').toValue(function(config:InjectableSelfReportingCallbackConfig):void
			{
				configInstance = config;
			});
			manager.addConfig(InjectableSelfReportingCallbackConfig);
			manager.initialize();
			assertThat(configInstance.sprite, equalTo(sprite));
		}

		[Test]
		public function config_removed_before_manager_initialization_is_not_configured():void
		{
			var configureCount:uint = 0;
			injector.map(Function, 'configureCallback').toValue(function(... r):void
			{
				configureCount++;
			});
			manager.addConfig(SelfReportingCallbackConfig);
			manager.removeConfig(SelfReportingCallbackConfig);
			manager.initialize();
			assertThat(configureCount, equalTo(0));
		}

		[Test(expects="Error")]
		public function manager_throws_on_double_initialization():void
		{
			manager.initialize();
			manager.initialize();
		}

		[Test(expects="Error")]
		public function manager_throws_on_double_destruction():void
		{
			manager.initialize();
			manager.destroy();
			manager.destroy();
		}

		[Test(expects="Error")]
		public function manager_throws_when_adding_config_after_destruction():void
		{
			manager.initialize();
			manager.destroy();
			manager.addConfig(NullConfig);
		}

		[Test(expects="Error")]
		public function manager_throws_when_removing_config_after_destruction():void
		{
			manager.initialize();
			manager.destroy();
			manager.removeConfig(NullConfig);
		}
	}
}

import flash.display.Sprite;
import robotlegs.bender.core.api.IContext;
import robotlegs.bender.core.api.IContextConfig;
import robotlegs.bender.core.impl.support.NullContext;
import org.swiftsuspenders.Injector;

class SupportContext extends NullContext
{
	public function SupportContext(injector:Injector)
	{
		_injector = injector;
	}
}

class NullConfig implements IContextConfig
{
	public function configure(context:IContext):void
	{
	}
}

class SelfReportingCallbackConfig implements IContextConfig
{

	[Inject(name="configureCallback")]
	public var callback:Function;

	public function configure(context:IContext):void
	{
		callback(this);
	}
}

class InjectableSelfReportingCallbackConfig extends SelfReportingCallbackConfig
{

	[Inject]
	public var sprite:Sprite;
}
