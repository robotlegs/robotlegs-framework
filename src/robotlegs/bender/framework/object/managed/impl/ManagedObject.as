//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object.managed.impl
{
	import robotlegs.bender.core.async.safelyCallBack;
	import robotlegs.bender.core.state.machine.impl.StateMachine;
	import robotlegs.bender.framework.object.managed.api.IManagedObject;

	public class ManagedObject extends StateMachine implements IManagedObject
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const PRE_INITIALIZE:String = 'preInitialize';

		public static const SELF_INITIALIZE:String = 'selfInitialize';

		public static const POST_INITIALIZE:String = 'postInitialize';

		public static const PRE_DESTROY:String = 'preDestroy';

		public static const SELF_DESTROY:String = 'selfDestroy';

		public static const POST_DESTROY:String = 'postDestroy';

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const INITIALIZE:String = 'initialize';

		private static const DESTROY:String = 'destroy';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _object:Object;

		public function get object():Object
		{
			return _object;
		}

		private var _initializing:Boolean;

		public function get initializing():Boolean
		{
			return _initializing;
		}

		private var _initialized:Boolean;

		public function get initialized():Boolean
		{
			return _initialized;
		}

		private var _destroying:Boolean;

		public function get destroying():Boolean
		{
			return _destroying;
		}

		private var _destroyed:Boolean;

		public function get destroyed():Boolean
		{
			return _destroyed;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ManagedObject(object:Object)
		{
			_object = object;
			addState(INITIALIZE, [PRE_INITIALIZE, SELF_INITIALIZE, POST_INITIALIZE]);
			addState(DESTROY, [PRE_DESTROY, SELF_DESTROY, POST_DESTROY], true);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize(callback:Function = null):void
		{
			if (_initializing || _initialized)
				return;
			_initializing = true;
			setCurrentState(INITIALIZE, function(error:Object):void {
				_initializing = false;
				_initialized = true;
				callback && safelyCallBack(callback, error);
			});
		}

		public function destroy(callback:Function = null):void
		{
			if (_destroying || _destroyed)
				return;
			_destroying = true;
			setCurrentState(DESTROY, function(error:Object):void {
				_destroying = false;
				_destroyed = true;
				callback && safelyCallBack(callback, error);
			});
		}
	}
}
