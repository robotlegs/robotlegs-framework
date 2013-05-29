//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl.support
{

	public class LifecycleReportingMediator
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject(name="preInitializeCallback", optional="true")]
		public var preInitializeCallback:Function;

		[Inject(name="initializeCallback", optional="true")]
		public var initializeCallback:Function;

		[Inject(name="postInitializeCallback", optional="true")]
		public var postInitializeCallback:Function;

		[Inject(name="preDestroyCallback", optional="true")]
		public var preDestroyCallback:Function;

		[Inject(name="destroyCallback", optional="true")]
		public var destroyCallback:Function;

		[Inject(name="postDestroyCallback", optional="true")]
		public var postDestroyCallback:Function;

		public var initialized:Boolean;

		public var destroyed:Boolean;

		public var view:Object;

		public function set viewComponent(view:Object):void
		{
			this.view = view;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function preInitialize():void
		{
			preInitializeCallback && preInitializeCallback('preInitialize');
		}

		public function initialize():void
		{
			initialized = true;
			initializeCallback && initializeCallback('initialize');
		}

		public function postInitialize():void
		{
			postInitializeCallback && postInitializeCallback('postInitialize');
		}

		public function preDestroy():void
		{
			preDestroyCallback && preDestroyCallback('preDestroy');
		}

		public function destroy():void
		{
			destroyed = true;
			destroyCallback && destroyCallback('destroy');
		}

		public function postDestroy():void
		{
			postDestroyCallback && postDestroyCallback('postDestroy');
		}
	}
}
