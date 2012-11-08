//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand2;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand3;
	import robotlegs.bender.extensions.commandCenter.support.NullCommandTrigger;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;

	public class CommandMapperTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mapper:CommandMapper;

		private var trigger:ICommandTrigger;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			trigger = new NullCommandTrigger();
			mapper = new CommandMapper(trigger);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function toCommand_registers_mappingConfig_with_trigger():void
		{
			var registeredConfig:Object = null;
			mapper = new CommandMapper(new CallbackCommandTrigger(function(config:Object):void {
				registeredConfig = config;
			}));
			const returnedConfig:ICommandMappingConfig = mapper.toCommand(NullCommand);
			assertThat(registeredConfig, equalTo(returnedConfig));
		}

		[Test]
		public function fromCommand_removes_mappingConfig_from_trigger():void
		{
			var unregisteredConfig:Object = null;
			mapper = new CommandMapper(new CallbackCommandTrigger(
				null,
				function(config:Object):void {
					unregisteredConfig = config;
				}));
			const oldConfig:ICommandMappingConfig = mapper.toCommand(NullCommand);
			mapper.fromCommand(NullCommand);
			assertThat(unregisteredConfig, equalTo(oldConfig));
		}

		[Test]
		public function fromCommand_removes_only_specified_mappingConfig_from_trigger():void
		{
			const unregisteredConfigs:Array = [];
			mapper = new CommandMapper(new CallbackCommandTrigger(
				null,
				function(config:Object):void {
					unregisteredConfigs.push(config);
				}));
			const config1:ICommandMappingConfig = mapper.toCommand(NullCommand);
			const config2:ICommandMappingConfig = mapper.toCommand(NullCommand2);
			mapper.fromCommand(NullCommand);
			assertThat(unregisteredConfigs, hasItem(config1));
			assertThat(unregisteredConfigs, not(hasItem(config2)));
		}

		[Test]
		public function fromAll_removes_all_mappingConfigs_from_trigger():void
		{
			const unregisteredConfigs:Array = [];
			mapper = new CommandMapper(new CallbackCommandTrigger(
				null,
				function(config:Object):void {
					unregisteredConfigs.push(config);
				}));
			const configs:Array = [
				mapper.toCommand(NullCommand),
				mapper.toCommand(NullCommand2),
				mapper.toCommand(NullCommand3)];
			mapper.fromAll();
			assertThat(unregisteredConfigs, array(configs));
		}

		[Test]
		public function toCommand_unregisters_old_mappingConfig_and_registers_new_one_when_overwritten():void
		{
			var unregisteredConfig:Object = null;
			var registeredConfig:Object = null;
			mapper = new CommandMapper(new CallbackCommandTrigger(
				function(config:Object):void {
					registeredConfig = config;
				},
				function(config:Object):void {
					unregisteredConfig = config;
				}));
			const oldConfig:ICommandMappingConfig = mapper.toCommand(NullCommand);
			const newConfig:ICommandMappingConfig = mapper.toCommand(NullCommand);
			assertThat(unregisteredConfig, equalTo(oldConfig));
			assertThat(registeredConfig, equalTo(newConfig));
		}

		[Test]
		public function toCommand_warns_when_overwritten():void
		{
			var warning:Array = [];
			const logger:ILogger = new CallbackLogger(function(level:uint, params:Array):void {
				if (level == LogLevel.WARN)
					warning = [params[0], params[1]];
			});
			mapper = new CommandMapper(trigger, logger);
			const oldMapping:ICommandMappingConfig = mapper.toCommand(NullCommand);
			mapper.toCommand(NullCommand);
			assertThat(warning, array([trigger, oldMapping]));
		}

	}
}

import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.api.LogLevel;

class CallbackLogger implements ILogger
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _callback:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function CallbackLogger(callback:Function)
	{
		_callback = callback;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function debug(message:*, params:Array = null):void
	{
		_callback(LogLevel.DEBUG, params);
	}

	public function info(message:*, params:Array = null):void
	{
		_callback(LogLevel.INFO, params);
	}

	public function warn(message:*, params:Array = null):void
	{
		_callback(LogLevel.WARN, params);
	}

	public function error(message:*, params:Array = null):void
	{
		_callback(LogLevel.ERROR, params);
	}

	public function fatal(message:*, params:Array = null):void
	{
		_callback(LogLevel.FATAL, params);
	}
}
