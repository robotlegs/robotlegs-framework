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
				// do nothing
			}
			return UIComponentClass != null;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onMediatorCreate(event:MediatorFactoryEvent):void
		{
			const view:DisplayObject = event.view as DisplayObject;
			
			if(event.view && !view)
				initializeMediator(view, event.mediator);
			
			if (!view)
				return;

			view.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (flexAvailable && (event.view is UIComponentClass) && !event.view['initialized'])
			{
				view.addEventListener('creationComplete', function(e:Event):void {
					view.removeEventListener('creationComplete', arguments.callee);
					// check that we haven't been removed in the meantime
					if (_factory.getMediator(event.view, event.mapping))
						initializeMediator(view, event.mediator);
				});
			}
			else
			{
				initializeMediator(view, event.mediator);
			}
		}

		private function onMediatorRemove(event:MediatorFactoryEvent):void
		{
			const view:DisplayObject = event.view as DisplayObject;

			if (view)
				view.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if(event.mediator)
				destroyMediator(event.mediator);
			
			// note: as far as I know, the re-parenting issue does not exist with Flex 4+.
			// question: should we bother handling re-parenting?
			// Stray: let's not handle it. People can defend against unwanted hooks running
			// during reparenting for themselves quite easily.
		}

		private function onRemovedFromStage(event:Event):void
		{
			_factory.removeMediators(event.target);
		}

		private function initializeMediator(view:DisplayObject, mediator:Object):void
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
