//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;

	public class DefaultMediatorManager
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static var UIComponentClass:Class;

		private static const flexAvailable:Boolean = checkFlex();

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _factory:IMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

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
			const displayObject:DisplayObject = event.view as DisplayObject;

			if (!displayObject)
			{
				// Non-display-object was added, initialize and exit
				initializeMediator(event.view, mediator);
				return;
			}

			// Watch this view for removal
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			// Is this a UIComponent that needs to be initialized?
			if (flexAvailable && (displayObject is UIComponentClass) && !displayObject['initialized'])
			{
				displayObject.addEventListener('creationComplete', function(e:Event):void
				{
					displayObject.removeEventListener('creationComplete', arguments.callee);
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
			const displayObject:DisplayObject = event.view as DisplayObject;

			if (displayObject)
				displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (event.mediator)
				destroyMediator(event.mediator);
		}

		private function onRemovedFromStage(event:Event):void
		{
			_factory.removeMediators(event.target);
		}

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
				mediator.destroy();
		}
	}
}
