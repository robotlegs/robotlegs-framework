//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
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

		private var _view:Object;

		public function get view():Object
		{
			return _view;
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
			view:Object,
			mapping:IMediatorMapping,
			factory:IMediatorFactory)
		{
			super(type);
			_mediator = mediator;
			_view = view;
			_mapping = mapping;
			_factory = factory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new MediatorFactoryEvent(type, _mediator, _view, _mapping, _factory);
		}
	}
}
