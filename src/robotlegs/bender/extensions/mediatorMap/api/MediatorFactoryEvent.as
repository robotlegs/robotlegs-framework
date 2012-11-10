//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import flash.events.Event;

	public class MediatorFactoryEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const MEDIATOR_CREATE:String = 'mediatorCreate';

		public static const MEDIATOR_REMOVE:String = 'mediatorRemove';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _mediator:Object;

		public function get mediator():Object
		{
			return _mediator;
		}

		private var _mediatedItem:Object;

		public function get mediatedItem():Object
		{
			return _mediatedItem;
		}

		private var _mapping:IMediatorMapping;

		public function get mapping():IMediatorMapping
		{
			return _mapping;
		}

		private var _factory:IMediatorFactory;

		public function get factory():IMediatorFactory
		{
			return _factory;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorFactoryEvent(
			type:String,
			mediator:Object,
			mediatedItem:Object,
			mapping:IMediatorMapping,
			factory:IMediatorFactory)
		{
			super(type);
			_mediator = mediator;
			_mediatedItem = mediatedItem;
			_mapping = mapping;
			_factory = factory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new MediatorFactoryEvent(type, _mediator, _mediatedItem, _mapping, _factory);
		}
	}
}
