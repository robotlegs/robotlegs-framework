//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.events.Event;
	import robotlegs.bender.framework.api.IContext;

	public class ModularContextEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTEXT_ADD:String = "contextAdd";

		public static const CONTEXT_REMOVE:String = "contextRemove";

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _context:IContext;

		public function get context():IContext
		{
			return _context;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ModularContextEvent(type:String, context:IContext)
		{
			super(type, true, true);
			_context = context;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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
