//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError;

	public class MediatorMapping implements IMediatorMapping, IMediatorMappingConfig
	{
		private var _locked:Boolean = false;
		private var _validator:MediatorMappingValidator;
		
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:ITypeFilter;

		public function get matcher():ITypeFilter
		{
			validate();
			return _matcher;
		}

		private var _mediatorClass:Class;

		public function get mediatorClass():Class
		{
			return _mediatorClass;
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
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMapping(matcher:ITypeFilter, mediatorClass:Class)
		{
			_matcher = matcher;
			_mediatorClass = mediatorClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withGuards(... guards):IMediatorMappingConfig
		{
			_validator && _validator.checkGuards(guards);
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		public function withHooks(... hooks):IMediatorMappingConfig
		{
			_validator && _validator.checkHooks(hooks);
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}
		
		internal function invalidate():void
		{
			if(_validator)
				_validator.invalidate();
			else
				createValidator();

			_guards = [];
			_hooks = [];
		}
		
		private function validate():void
		{
			if(!_validator)
			{
				createValidator();
			}
			else if(!_validator.valid)
			{
				_validator.validate(_guards, _hooks);
			}
		}
		
		private function createValidator():void
		{
			_validator = new MediatorMappingValidator(_guards.slice(), _hooks.slice(), _matcher, _mediatorClass);
		}
	}
}