//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object.manager.impl
{
	import flash.utils.Dictionary;
	import org.hamcrest.Matcher;
	import robotlegs.bender.core.objectProcessor.api.IObjectProcessor;
	import robotlegs.bender.core.objectProcessor.impl.ObjectProcessor;
	import robotlegs.bender.framework.object.managed.api.IManagedObject;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;
	import robotlegs.bender.framework.object.manager.api.IObjectManager;

	public class ObjectManager implements IObjectManager
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _objectProcessor:IObjectProcessor = new ObjectProcessor();

		private const _managedObjects:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addObject(object:Object):IManagedObject
		{
			return getManagedObject(object) || createManagedObject(object);
		}

		public function addObjectHandler(matcher:Matcher, handler:Function):void
		{
			_objectProcessor.addObjectHandler(matcher, handler);
		}

		public function getManagedObject(object:Object):IManagedObject
		{
			return _managedObjects[object];
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createManagedObject(object:Object):IManagedObject
		{
			const managedObject:IManagedObject = new ManagedObject(object);
			_managedObjects[object] = managedObject;
			_objectProcessor.processObject(object);
			return managedObject;
		}
	}
}
