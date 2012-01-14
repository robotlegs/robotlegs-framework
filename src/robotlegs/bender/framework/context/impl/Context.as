//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context.impl
{
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.config.manager.api.IConfigManager;
	import robotlegs.bender.framework.config.manager.impl.ConfigManager;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.object.managed.api.IManagedObject;
	import robotlegs.bender.framework.object.manager.api.IObjectManager;
	import robotlegs.bender.framework.object.manager.impl.ObjectManager;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _injector:Injector = new Injector();

		public function get injector():Injector
		{
			return _injector;
		}

		public function get initializing():Boolean
		{
			return _managedObject.initializing;
		}

		public function get initialized():Boolean
		{
			return _managedObject.initialized;
		}

		public function get destroying():Boolean
		{
			return _managedObject.destroying;
		}

		public function get destroyed():Boolean
		{
			return _managedObject.destroyed;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _objectManager:IObjectManager = new ObjectManager();

		private var _configManager:IConfigManager;

		private var _managedObject:IManagedObject;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Context(... configs)
		{
			_injector.map(Injector).toValue(_injector);
			_managedObject = _objectManager.addObject(this);
			_configManager = new ConfigManager(this);
			require.apply(this, configs);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize():void
		{
			_managedObject.initialize(handleError);
		}

		public function destroy():void
		{
			_managedObject.destroy(handleError);
		}

		public function require(... configs):IContext
		{
			for each (var config:Object in configs)
			{
				_configManager.addConfig(config);
			}
			return this;
		}

		public function addConfigHandler(matcher:Matcher, handler:Function):IContext
		{
			_configManager.addConfigHandler(matcher, handler);
			return this;
		}

		public function addObject(object:Object):IContext
		{
			_objectManager.addObject(object);
			return this;
		}

		public function addObjectHandler(matcher:Matcher, handler:Function):IContext
		{
			_objectManager.addObjectHandler(matcher, handler);
			return this;
		}

		public function getManagedObject(object:Object):IManagedObject
		{
			return _objectManager.getManagedObject(object);
		}

		public function matches(object:Object):Boolean
		{
			return _objectManager.matches(object);
		}

		public function describeTo(description:Description):void
		{
			_objectManager.describeTo(description);
		}

		public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
			_objectManager.describeMismatch(item, mismatchDescription);
		}

		public function addStateHandler(step:String, handler:Function):IContext
		{
			_managedObject.addStateHandler(step, handler);
			return this;
		}

		public function removeStateHandler(step:String, handler:Function):IContext
		{
			_managedObject.removeStateHandler(step, handler);
			return this;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleError(error:Object):void
		{
			if (error is Error)
			{
				throw error as Error;
			}
			else if (error)
			{
				throw new Error(error);
			}
		}
	}
}
