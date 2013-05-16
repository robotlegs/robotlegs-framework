//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.impl.rl2_internal;

	use namespace rl2_internal;

	/**
	 * Simple Mediator creation processor
	 */
	public class MediatorCreator
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _mediatorClass:Class;

		private const _createdMediatorsByView:Dictionary = new Dictionary(true);

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Mediator Creator Processor
		 * @param mediatorClass The mediator class to create
		 */
		public function MediatorCreator(mediatorClass:Class)
		{
			_mediatorClass = mediatorClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function process(view:Object, type:Class, injector:Injector):void
		{
			if (_createdMediatorsByView[view])
			{
				return;
			}
			const mediator:* = injector.instantiateUnmapped(_mediatorClass);
			_createdMediatorsByView[view] = mediator;
			initializeMediator(view, mediator);
		}

		/**
		 * @private
		 */
		public function unprocess(view:Object, type:Class, injector:Injector):void
		{
			if (_createdMediatorsByView[view])
			{
				destroyMediator(_createdMediatorsByView[view]);
				delete _createdMediatorsByView[view];
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function initializeMediator(view:Object, mediator:Object):void
		{
			if (mediator.hasOwnProperty('viewComponent'))
				mediator.viewComponent = view;

			if (mediator.hasOwnProperty('initialize'))
				mediator.initialize();
		}

		private function destroyMediator(mediator:Object):void
		{
			if (mediator.hasOwnProperty('destroy'))
			{
				mediator.destroy();
				if(!mediator.destroyed)
					mediator.finallyDestroy();
			}
		}
	}
}
