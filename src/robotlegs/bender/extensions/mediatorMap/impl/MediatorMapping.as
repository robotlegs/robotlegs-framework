//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorConfigurator;

	/**
	 * @private
	 */
	public class MediatorMapping implements IMediatorMapping, IMediatorConfigurator
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:ITypeFilter;

		/**
		 * @inheritDoc
		 */
		public function get matcher():ITypeFilter
		{
			return _matcher;
		}

		private var _mediatorClass:Class;

		/**
		 * @inheritDoc
		 */
		public function get mediatorClass():Class
		{
			return _mediatorClass;
		}

		private var _guards:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}

		private var _autoRemoveEnabled:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function get autoRemoveEnabled():Boolean
		{
			return _autoRemoveEnabled;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorMapping(matcher:ITypeFilter, mediatorClass:Class)
		{
			_matcher = matcher;
			_mediatorClass = mediatorClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):IMediatorConfigurator
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):IMediatorConfigurator
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function autoRemove(value:Boolean = true):IMediatorConfigurator
		{
			_autoRemoveEnabled = value;
			return this;
		}
	}
}
