//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.robotlegs.v2.core.api.IContext;
	import org.swiftsuspenders.Injector;

	public class ExtensionManagerTests
	{
		private var injector:Injector;

		private var context:IContext;

		private var manager:ExtensionManager;

		[Before]
		public function setUp():void
		{
			injector = new Injector()
			context = new SupportContext(injector);
			manager = new ExtensionManager(context);
		}

		[After]
		public function tearDown():void
		{
			manager = null;
		}

		[Test]
		public function extension_is_stored():void
		{
			manager.addExtension(CallbackExtension);
			assertThat(manager.hasExtension(CallbackExtension), isTrue());
		}

		[Test]
		public function extension_is_removed():void
		{
			manager.addExtension(CallbackExtension);
			manager.removeExtension(CallbackExtension);
			assertThat(manager.hasExtension(CallbackExtension), isFalse());
		}

		[Test]
		public function destroy_removes_all_extensions():void
		{
			manager.addExtension(CallbackExtension);
			manager.initialize();
			manager.destroy();
			assertThat(manager.hasExtension(CallbackExtension), isFalse());
		}

		[Test]
		public function extension_is_installed_during_manager_initialization():void
		{
			var installCount:uint = 0;
			injector.map(Function, 'installCallback').toValue(function(... r):void
			{
				installCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.initialize();
			assertThat(installCount, equalTo(1));
		}

		[Test]
		public function extension_is_initialized_during_manager_initialization():void
		{
			var initCount:uint = 0;
			injector.map(Function, 'initializeCallback').toValue(function(... r):void
			{
				initCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.initialize();
			assertThat(initCount, equalTo(1));
		}

		[Test]
		public function extension_is_uninstalled_during_manager_destruction():void
		{
			var uninstallCount:uint = 0;
			injector.map(Function, 'uninstallCallback').toValue(function(... r):void
			{
				uninstallCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.initialize();
			manager.destroy();
			assertThat(uninstallCount, equalTo(1));
		}

		[Test]
		public function extension_is_installed_immediately_when_manager_already_initialized():void
		{
			var installCount:uint = 0;
			injector.map(Function, 'installCallback').toValue(function(... r):void
			{
				installCount++;
			});
			manager.initialize();
			manager.addExtension(CallbackExtension);
			assertThat(installCount, equalTo(1));
		}

		[Test]
		public function installed_extension_is_uninstalled_immediately_when_removed():void
		{
			var uninstallCount:uint = 0;
			injector.map(Function, 'uninstallCallback').toValue(function(... r):void
			{
				uninstallCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.initialize();
			manager.removeExtension(CallbackExtension);
			assertThat(uninstallCount, equalTo(1));
		}

		[Test]
		public function extension_removed_before_manager_initialization_is_not_installed():void
		{
			var installCount:uint = 0;
			injector.map(Function, 'installCallback').toValue(function(... r):void
			{
				installCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.removeExtension(CallbackExtension);
			manager.initialize();
			manager.destroy();
			assertThat(installCount, equalTo(0));
		}

		[Test]
		public function extension_removed_before_manager_initialization_is_not_initialized():void
		{
			var initCount:uint = 0;
			injector.map(Function, 'initializeCallback').toValue(function(... r):void
			{
				initCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.removeExtension(CallbackExtension);
			manager.initialize();
			manager.destroy();
			assertThat(initCount, equalTo(0));
		}

		[Test]
		public function extension_removed_before_manager_initialization_is_not_uninstalled():void
		{
			var uninstallCount:uint = 0;
			injector.map(Function, 'uninstallCallback').toValue(function(... r):void
			{
				uninstallCount++;
			});
			manager.addExtension(CallbackExtension);
			manager.removeExtension(CallbackExtension);
			manager.initialize();
			manager.destroy();
			assertThat(uninstallCount, equalTo(0));
		}

		[Test]
		public function extensions_added_before_manager_initialization_are_all_installed_before_being_initialized():void
		{
			const log:Array = [];
			injector.map(Function, 'installCallback').toValue(function(name:String):void
			{
				log.push('install', name);
			});
			injector.map(Function, 'initializeCallback').toValue(function(name:String):void
			{
				log.push('initialize', name);
			});
			manager.addExtension(CallbackExtension);
			manager.addExtension(CallbackExtension2);
			manager.addExtension(CallbackExtension3);
			manager.initialize();
			assertThat(log, array([
				'install', 'CallbackExtension',
				'install', 'CallbackExtension2',
				'install', 'CallbackExtension3',
				'initialize', 'CallbackExtension',
				'initialize', 'CallbackExtension2',
				'initialize', 'CallbackExtension3']));
		}

		[Test]
		public function extensions_are_uninstalled_in_reverse_order():void
		{
			const log:Array = [];
			injector.map(Function, 'uninstallCallback').toValue(function(name:String):void
			{
				log.push(name);
			});
			manager.addExtension(CallbackExtension);
			manager.addExtension(CallbackExtension2);
			manager.addExtension(CallbackExtension3);
			manager.initialize();
			manager.destroy();
			assertThat(log, array(['CallbackExtension3', 'CallbackExtension2', 'CallbackExtension']));
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
	}
}

import org.robotlegs.v2.core.api.IContext;
import org.robotlegs.v2.core.api.IContextExtension;
import org.robotlegs.v2.core.impl.support.NullContext;
import org.swiftsuspenders.Injector;

class SupportContext extends NullContext
{
	public function SupportContext(injector:Injector)
	{
		_injector = injector;
	}
}

class CallbackExtension implements IContextExtension
{

	protected var name:String = 'CallbackExtension';

	private var context:IContext;

	public function install(context:IContext):void
	{
		this.context = context;
		const callback:Function =
			context.injector.satisfies(Function, 'installCallback') ?
			context.injector.getInstance(Function, 'installCallback') : null;
		callback && callback(name);
	}

	public function initialize():void
	{
		const callback:Function =
			context.injector.satisfies(Function, 'initializeCallback') ?
			context.injector.getInstance(Function, 'initializeCallback') : null;
		callback && callback(name);
	}

	public function uninstall():void
	{
		const callback:Function =
			context.injector.satisfies(Function, 'uninstallCallback') ?
			context.injector.getInstance(Function, 'uninstallCallback') : null;
		callback && callback(name);
	}
}

class CallbackExtension2 extends CallbackExtension
{
	public function CallbackExtension2()
	{
		name = 'CallbackExtension2';
	}
}

class CallbackExtension3 extends CallbackExtension
{
	public function CallbackExtension3()
	{
		name = 'CallbackExtension3';
	}
}
