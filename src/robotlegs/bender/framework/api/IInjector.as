//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import org.swiftsuspenders.dependencyproviders.FallbackDependencyProvider;
	import org.swiftsuspenders.mapping.InjectionMapping;
	import org.swiftsuspenders.typedescriptions.TypeDescription;

	[Event(name='mappingOverride', type='org.swiftsuspenders.mapping.MappingEvent')]
	[Event(name='postConstruct', type='org.swiftsuspenders.InjectionEvent')]
	[Event(name='postInstantiate', type='org.swiftsuspenders.InjectionEvent')]
	[Event(name='postMappingChange', type='org.swiftsuspenders.mapping.MappingEvent')]
	[Event(name='postMappingCreate', type='org.swiftsuspenders.mapping.MappingEvent')]
	[Event(name='postMappingRemove', type='org.swiftsuspenders.mapping.MappingEvent')]
	[Event(name='preConstruct', type='org.swiftsuspenders.InjectionEvent')]
	[Event(name='preMappingChange', type='org.swiftsuspenders.mapping.MappingEvent')]
	[Event(name='preMappingCreate', type='org.swiftsuspenders.mapping.MappingEvent')]
	public interface IInjector extends IEventDispatcher
	{
		function set parent(parentInjector:IInjector):void;
		function get parent():IInjector;
		function set applicationDomain(applicationDomain:ApplicationDomain):void;
		function get applicationDomain():ApplicationDomain;
		function get fallbackProvider():FallbackDependencyProvider;
		function set fallbackProvider(provider:FallbackDependencyProvider):void;
		function get blockParentFallbackProvider():Boolean;
		function set blockParentFallbackProvider(value:Boolean):void;

		function addTypeDescription(type:Class, description:TypeDescription):void;
		function getTypeDescription(type:Class):TypeDescription;
		function hasMapping(type:Class, name:String = ''):Boolean;
		function hasDirectMapping(type:Class, name:String = ''):Boolean;
		function map(type:Class, name:String = ''):InjectionMapping;
		function unmap(type:Class, name:String = ''):void;
		function satisfies(type:Class, name:String = ''):Boolean;
		function satisfiesDirectly(type:Class, name:String = ''):Boolean;
		function getMapping(type:Class, name:String = ''):InjectionMapping;
		function injectInto(target:Object):void;
		function getInstance(type:Class, name:String = '', targetType:Class = null):*;
		function getOrCreateNewInstance(type:Class):*;
		function instantiateUnmapped(type:Class):*;
		function destroyInstance(instance:Object):void;
		function teardown():void;
		function createChild(applicationDomain:ApplicationDomain = null):IInjector;
	}
}
