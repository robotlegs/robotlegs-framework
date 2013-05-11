//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * Container existence event
	 * @private
	 */
	public class ContainerRegistryEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTAINER_ADD:String = 'containerAdd';

		public static const CONTAINER_REMOVE:String = 'containerRemove';

		public static const ROOT_CONTAINER_ADD:String = 'rootContainerAdd';

		public static const ROOT_CONTAINER_REMOVE:String = 'rootContainerRemove';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _container:DisplayObjectContainer;

		/**
		 * The container associated with this event
		 */
		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a new container existence event
		 * @param type The event type
		 * @param container The container associated with this event
		 */
		public function ContainerRegistryEvent(type:String, container:DisplayObjectContainer)
		{
			super(type);
			_container = container;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ContainerRegistryEvent(type, _container);
		}
	}
}
