//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;

	public class MediatorMapping implements IMediatorMapping, IMediatorMappingConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:Matcher;

		public function get matcher():Matcher
		{
			return _matcher;
		}

		private var _mediatorClass:Class;

		public function get mediatorClass():Class
		{
			return _mediatorClass;
		}

		private var _viewType:Class;

		public function get viewType():Class
		{
			return _viewType;
		}

		private var _guards:Array = [];

		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		public function get hooks():Array
		{
			return _hooks;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _factory:IMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMapping(matcher:Matcher, mediatorClass:Class, manager:IMediatorFactory, viewType:Class = null)
		{
			_matcher = matcher;
			_mediatorClass = mediatorClass;
			_factory = manager;
			_viewType = viewType;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withGuards(... guards):IMediatorMappingConfig
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		public function withHooks(... hooks):IMediatorMappingConfig
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}

		public function createMediator(view:Object):Object
		{
			return _factory.createMediator(view, this);
		}

		public function removeMediator(view:Object):void
		{
			_factory.removeMediator(view, this);
		}
	}
}
