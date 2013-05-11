//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.events.Event;
	import robotlegs.bender.framework.api.IContext;

	/**
	 * Module Context Event
	 * @private
	 */
	public class ModularContextEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTEXT_ADD:String = "contextAdd";

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _context:IContext;

		/**
		 * The context associated with this event
		 */
		public function get context():IContext
		{
			return _context;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Module Context Event
		 * @param type The event type
		 * @param context The associated context
		 */
		public function ModularContextEvent(type:String, context:IContext)
		{
			super(type, true, true);
			_context = context;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ModularContextEvent(type, context);
		}

		override public function toString():String
		{
			return formatToString("ModularContextEvent", "context");
		}
	}
}
