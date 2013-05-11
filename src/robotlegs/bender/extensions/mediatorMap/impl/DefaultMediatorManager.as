//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;

	/**
	 * @private
	 */
	public class DefaultMediatorManager
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static var UIComponentClass:Class;

		private static const flexAvailable:Boolean = checkFlex();

		private static const CREATION_COMPLETE:String = "creationComplete";

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _factory:IMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function DefaultMediatorManager(factory:IMediatorFactory)
		{
			_factory = factory;
			_factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, onMediatorCreate);
			_factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, onMediatorRemove);
		}

		/*============================================================================*/
		/* Private Static Functions                                                   */
		/*============================================================================*/

		private static function checkFlex():Boolean
		{
			try
			{
				UIComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
			}
			catch (error:Error)
			{
				// Do nothing
			}
			return UIComponentClass != null;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onMediatorCreate(event:MediatorFactoryEvent):void
		{
			const mediator:Object = event.mediator;
			const displayObject:DisplayObject = event.mediatedItem as DisplayObject;

			if (!displayObject)
			{
				// Non-display-object was added, initialize and exit
				initializeMediator(event.mediatedItem, mediator);
				return;
			}

			if (event.mapping.autoRemoveEnabled)
			{
				// Watch this view for removal
				displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}

			// Is this a UIComponent that needs to be initialized?
			if (flexAvailable && (displayObject is UIComponentClass) && !displayObject['initialized'])
			{
				displayObject.addEventListener(CREATION_COMPLETE, function(e:Event):void
				{
					displayObject.removeEventListener(CREATION_COMPLETE, arguments.callee);
					// ensure that we haven't been removed in the meantime
					if (_factory.getMediator(displayObject, event.mapping))
						initializeMediator(displayObject, mediator);
				});
			}
			else
			{
				initializeMediator(displayObject, mediator);
			}
		}

		private function onMediatorRemove(event:MediatorFactoryEvent):void
		{
			const displayObject:DisplayObject = event.mediatedItem as DisplayObject;

			if (displayObject)
				displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (event.mediator)
				destroyMediator(event.mediator);
		}

		private function onRemovedFromStage(event:Event):void
		{
			_factory.removeMediators(event.target);
		}

		private function initializeMediator(mediatedItem:Object, mediator:Object):void
		{
			if (mediator.hasOwnProperty('viewComponent'))
				mediator.viewComponent = mediatedItem;

			if (mediator.hasOwnProperty('initialize'))
				mediator.initialize();
		}

		private function destroyMediator(mediator:Object):void
		{
			if (mediator.hasOwnProperty('destroy'))
				mediator.destroy();
		}
	}
}
