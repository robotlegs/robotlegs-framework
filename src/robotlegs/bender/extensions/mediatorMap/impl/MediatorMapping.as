//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.core.api.ITypeFilter;
	import robotlegs.bender.core.api.ITypeMatcher;
	import robotlegs.bender.core.impl.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorConfig;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorUnmapping;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorConfig;
	import org.swiftsuspenders.Injector;

	public class MediatorMapping implements IMediatorMapping, IMediatorUnmapping
	{

		private var _callbackForDeletion:Function;

		private var _injector:Injector;

		private var _configsByMediator:Dictionary;

		private var _typeFilter:ITypeFilter;

		public function get configsByMediator():Dictionary
		{
			return _configsByMediator;
		}

		public function MediatorMapping(callbackForDeletion:Function, typeFilter:ITypeFilter, injector:Injector)
		{
			_configsByMediator = new Dictionary();
			_callbackForDeletion = callbackForDeletion;
			_typeFilter = typeFilter;
			_injector = injector;
		}

		public function toMediator(mediatorType:Class):IMediatorConfig
		{
			if(_configsByMediator[mediatorType])
			{
				// todo improve error;
				throw Error("You've already created a mapping like this one. Duh.");
			}
			_configsByMediator[mediatorType] = new MediatorConfig(this, _injector);
			return _configsByMediator[mediatorType];
		}

		public function fromMediator(mediatorType:Class):void
		{
			if (_configsByMediator[mediatorType])
			{
				delete _configsByMediator[mediatorType];
			}

			if (!hasConfigs)
			{
				_callbackForDeletion(_typeFilter);
			}
		}

		public function fromAll():void
		{
			_configsByMediator = new Dictionary();
			_callbackForDeletion(_typeFilter);
		}

		public function get hasConfigs():Boolean
		{
			for each (var item:Object in _configsByMediator)
			{
				return true;
			}

			return false;
		}
	}
}