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
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

	/**
	* @private
	*/
	public class MediatorManager
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

		private var _factory:MediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorManager(factory:MediatorFactory)
		{
			_factory = factory;
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
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function addMediator(mediator:Object, item:Object, mapping:IMediatorMapping):void
		{
			const displayObject:DisplayObject = item as DisplayObject;

			if (!displayObject)
			{
				// Non-display-object was added, initialize and exit
				initializeMediator(mediator, item);
				return;
			}

			if (mapping.autoRemoveEnabled)
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
					if (_factory.getMediator(displayObject, mapping))
						initializeMediator(mediator, displayObject);
				});
			}
			else
			{
				initializeMediator(mediator, displayObject);
			}
		}

		/**
		 * @private
		 */
		public function removeMediator(mediator:Object, item:Object, mapping:IMediatorMapping):void
		{
			const displayObject:DisplayObject = item as DisplayObject;

			if (displayObject)
				displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (mediator)
				destroyMediator(mediator);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onRemovedFromStage(event:Event):void
		{
			_factory.removeMediators(event.target);
		}

		private function initializeMediator(mediator:Object, mediatedItem:Object):void
		{
			if ('preInitialize' in mediator)
				mediator.preInitialize();

			if ('viewComponent' in mediator)
				mediator.viewComponent = mediatedItem;

			if ('initialize' in mediator)
				mediator.initialize();

			if ('postInitialize' in mediator)
				mediator.postInitialize();
		}

		private function destroyMediator(mediator:Object):void
		{
			if ('preDestroy' in mediator)
				mediator.preDestroy();

			if ('destroy' in mediator)
				mediator.destroy();

			if ('viewComponent' in mediator)
				mediator.viewComponent = null;

			if ('postDestroy' in mediator)
				mediator.postDestroy();
		}
	}
}
