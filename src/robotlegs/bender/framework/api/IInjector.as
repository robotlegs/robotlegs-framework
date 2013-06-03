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

	/**
	 * This event is dispatched if an existing mapping is overridden without first unmapping it.
	 *
	 * <p>The reason for dispatching an event (and tracing a warning) is that in most cases,
	 * overriding existing mappings is a sign of bugs in the application. Deliberate mapping
	 * changes should be done by first removing the existing mapping.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_REMOVE
	 */
	[Event(name='mappingOverride', type='org.swiftsuspenders.mapping.MappingEvent')]
	/**
	 * This event is dispatched each time the injector created and fully initialized a new instance
	 *
	 * <p>At the point where the event is dispatched all dependencies for the newly created instance
	 * have already been injected. That means that creation-events for leaf nodes of the created
	 * object graph will be dispatched before the creation-events for the branches they are
	 * injected into.</p>
	 *
	 * <p>The newly created instance's [PostConstruct]-annotated methods will also have run already.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.InjectionEvent.POST_CONSTRUCT
	 */
	[Event(name='postConstruct', type='org.swiftsuspenders.InjectionEvent')]
	/**
	* This event is dispatched each time the injector instantiated a class
	*
	* <p>At the point where the event is dispatched none of the injection points have been processed.</p>
	*
	* <p>The only difference to the <code>PRE_CONSTRUCT</code> event is that
	* <code>POST_INSTANTIATE</code> is only dispatched for instances that are created in the
	* injector, whereas <code>PRE_CONSTRUCT</code> is also dispatched for instances the injector
	* only injects into.</p>
	*
	* <p>This event is only dispatched if there are one or more relevant listeners attached to
	* the dispatching injector.</p>
	*
	* @eventType org.swiftsuspenders.InjectionEvent.POST_INSTANTIATE
	*/
	[Event(name='postInstantiate', type='org.swiftsuspenders.InjectionEvent')]
	/**
	 * This event is dispatched each time an injector mapping is changed in any way, right after
	 * the change is applied.
	 *
	 * <p>At the point where the event is dispatched the changes have already been applied, meaning
	 * the mapping stored in the event can be queried for its post-change state</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_CHANGE
	 */
	[Event(name='postMappingChange', type='org.swiftsuspenders.mapping.MappingEvent')]
	/**
	 * This event is dispatched each time the injector creates a new mapping for a type/ name
	 * combination, right after the mapping was created
	 *
	 * <p>At the point where the event is dispatched the mapping has already been created and stored
	 * in the injector's lookup table.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_CREATE
	 */
	[Event(name='postMappingCreate', type='org.swiftsuspenders.mapping.MappingEvent')]
	/**
	 * This event is dispatched each time an injector mapping is removed, right after
	 * the mapping is deleted from the configuration.
	 *
	 * <p>At the point where the event is dispatched the changes have already been applied, meaning
	 * the mapping is lost to the injector and can't be queried anymore.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.MappingEvent.POST_MAPPING_REMOVE
	 */
	[Event(name='postMappingRemove', type='org.swiftsuspenders.mapping.MappingEvent')]
	/**
	 * This event is dispatched each time the injector is about to inject into a class
	 *
	 * <p>At the point where the event is dispatched none of the injection points have been processed.</p>
	 *
	 * <p>The only difference to the <code>POST_INSTANTIATE</code> event is that
	 * <code>PRE_CONSTRUCT</code> is only dispatched for instances that are created in the
	 * injector, whereas <code>POST_INSTANTIATE</code> is also dispatched for instances the
	 * injector only injects into.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.InjectionEvent.PRE_CONSTRUCT
	 */
	[Event(name='preConstruct', type='org.swiftsuspenders.InjectionEvent')]
	/**
	 * This event is dispatched each time an injector mapping is changed in any way, right before
	 * the change is applied.
	 *
	 * <p>At the point where the event is dispatched the changes haven't yet been applied, meaning the
	 * mapping stored in the event can be queried for its pre-change state.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.MappingEvent.PRE_MAPPING_CHANGE
	 */
	[Event(name='preMappingChange', type='org.swiftsuspenders.mapping.MappingEvent')]
	/**
	 * This event is dispatched each time the injector creates a new mapping for a type/ name
	 * combination, right before the mapping is created
	 *
	 * <p>At the point where the event is dispatched the mapping hasn't yet been created. Thus, the
	 * respective field in the event is null.</p>
	 *
	 * <p>This event is only dispatched if there are one or more relevant listeners attached to
	 * the dispatching injector.</p>
	 *
	 * @eventType org.swiftsuspenders.MappingEvent.PRE_MAPPING_CREATE
	 */
	[Event(name='preMappingCreate', type='org.swiftsuspenders.mapping.MappingEvent')]
	/**
	 * The <code>Injector</code> manages the mappings and acts as the central hub from which all
	 * injections are started.
	 */
	public interface IInjector extends IEventDispatcher
	{
		/**
		 * Sets the parent <code>IInjector</code>
		 * @param parentInjector The parent IInjector
		 */
		function set parent(parentInjector:IInjector):void;

		/**
		 * Returns the <code>IInjector</code> used for dependencies the current
		 * <code>Injector</code> can't supply
		 */
		function get parent():IInjector;

		/**
		 * Sets the ApplicationDomain to use for type reflection
		 * @param applicationDomain The ApplicationDomain
		 */
		function set applicationDomain(applicationDomain:ApplicationDomain):void;

		/**
		 * The ApplicationDomain used for type reflection
		 */
		function get applicationDomain():ApplicationDomain;

		/**
		 * Sets the Fallback Provider
		 * @param provider FallbackDependencyProvider
		 */
		function set fallbackProvider(provider:FallbackDependencyProvider):void;

		/**
		 * The current FallbackDependencyProvider
		 */
		function get fallbackProvider():FallbackDependencyProvider;

		/**
		 * Disables parent FallbackProvider
		 * @param value True/false
		 */
		function set blockParentFallbackProvider(value:Boolean):void;

		/**
		 * Is the parent FallbackProvider blocked?
		 */
		function get blockParentFallbackProvider():Boolean;

		/**
		 * Instructs the injector to use the description for the given type when constructing or
		 * destroying instances.
		 *
		 * The description consists details for the constructor, all properties and methods to
		 * inject into during construction and all methods to invoke during destruction.
		 *
		 * @param type
		 * @param description
		 */
		function addTypeDescription(type:Class, description:TypeDescription):void;

		/**
		 * Returns a description of the given type containing its constructor, injection points
		 * and post construct and pre destroy hooks
		 *
		 * @param type The type to describe
		 * @return The TypeDescription containing all information the injector has about the type
		 */
		function getTypeDescription(type:Class):TypeDescription;

		/**
		 * Does this injector (or any parents) have a mapping for the given type?
		 * @param type The type
		 * @param name Optional name
		 * @return True if the mapping exists
		 */
		function hasMapping(type:Class, name:String = ''):Boolean;

		/**
		 * Does this injector have a direct mapping for the given type?
		 * @param type The type
		 * @param name Optional name
		 * @return True if the mapping exists
		 */
		function hasDirectMapping(type:Class, name:String = ''):Boolean;

		/**
		 * Maps a request description, consisting of the <code>type</code> and, optionally, the
		 * <code>name</code>.
		 *
		 * <p>The returned mapping is created if it didn't exist yet or simply returned otherwise.</p>
		 *
		 * <p>Named mappings should be used as sparingly as possible as they increase the likelyhood
		 * of typing errors to cause hard to debug errors at runtime.</p>
		 *
		 * @param type The <code>class</code> describing the mapping
		 * @param name The name, as a case-sensitive string, to further describe the mapping
		 *
		 * @return The <code>InjectionMapping</code> for the given request description
		 *
		 * @see #unmap()
		 * @see org.swiftsuspenders.mapping.InjectionMapping
		 */
		function map(type:Class, name:String = ''):InjectionMapping;

		/**
		 *  Removes the mapping described by the given <code>type</code> and <code>name</code>.
		 *
		 * @param type The <code>class</code> describing the mapping
		 * @param name The name, as a case-sensitive string, to further describe the mapping
		 *
		 * @throws org.swiftsuspenders.errors.InjectorError Descriptions that are not mapped can't be unmapped
		 * @throws org.swiftsuspenders.errors.InjectorError Sealed mappings have to be unsealed before unmapping them
		 *
		 * @see #map()
		 * @see org.swiftsuspenders.mapping.InjectionMapping
		 * @see org.swiftsuspenders.mapping.InjectionMapping#unseal()
		 */
		function unmap(type:Class, name:String = ''):void;

		/**
		 * Indicates whether the injector can supply a response for the specified dependency either
		 * by using a mapping of its own or by querying one of its ancestor injectors.
		 *
		 * @param type The type of the dependency under query
		 * @param name The name of the dependency under query
		 *
		 * @return <code>true</code> if the dependency can be satisfied, <code>false</code> if not
		 */
		function satisfies(type:Class, name:String = ''):Boolean;

		/**
		 * Indicates whether the injector can directly supply a response for the specified
		 * dependency.
		 *
		 * <p>In contrast to <code>#satisfies()</code>, <code>satisfiesDirectly</code> only informs
		 * about mappings on this injector itself, without querying its ancestor injectors.</p>
		 *
		 * @param type The type of the dependency under query
		 * @param name The name of the dependency under query
		 *
		 * @return <code>true</code> if the dependency can be satisfied, <code>false</code> if not
		 */
		function satisfiesDirectly(type:Class, name:String = ''):Boolean;

		/**
		 * Returns the mapping for the specified dependency class
		 *
		 * <p>Note that getMapping will only return mappings in exactly this injector, not ones
		 * mapped in an ancestor injector. To get mappings from ancestor injectors, query them
		 * using <code>parentInjector</code>.
		 * This restriction is in place to prevent accidential changing of mappings in ancestor
		 * injectors where only the child's response is meant to be altered.</p>
		 *
		 * @param type The type of the dependency to return the mapping for
		 * @param name The name of the dependency to return the mapping for
		 *
		 * @return The mapping for the specified dependency class
		 *
		 * @throws org.swiftsuspenders.errors.InjectorMissingMappingError when no mapping was found
		 * for the specified dependency
		 */
		function getMapping(type:Class, name:String = ''):InjectionMapping;

		/**
		 * Inspects the given object and injects into all injection points configured for its class.
		 *
		 * @param target The instance to inject into
		 *
		 * @throws org.swiftsuspenders.errors.InjectorError The <code>Injector</code> must have mappings
		 * for all injection points
		 *
		 * @see #map()
		 */
		function injectInto(target:Object):void;

		/**
		 * Instantiates the class identified by the given <code>type</code> and <code>name</code>.
		 *
		 * <p>The parameter <code>targetType</code> is only useful if the
		 * <code>InjectionMapping</code> used to satisfy the request might vary its result based on
		 * that <code>targetType</code>. An Example of that would be a provider returning a logger
		 * instance pre-configured for the instance it is used in.</p>
		 *
		 * @param type The <code>class</code> describing the mapping
		 * @param name The name, as a case-sensitive string, to use for mapping resolution
		 * @param targetType The type of the instance that is dependent on the returned value
		 *
		 * @return The mapped or created instance
		 *
		 * @throws org.swiftsuspenders.errors.InjectorMissingMappingError if no mapping was found
		 * for the specified dependency and no <code>fallbackProvider</code> is set.
		 */
		function getInstance(type:Class, name:String = '', targetType:Class = null):*;

		/**
		 * Returns an instance of the given type. If the Injector has a mapping for the type, that
		 * is used for getting the instance. If not, a new instance of the class is created and
		 * injected into.
		 *
		 * @param type The type to get an instance of
		 * @return The instance that was created or retrieved from the mapped provider
		 *
		 * @throws org.swiftsuspenders.errors.InjectorMissingMappingError if no mapping is found
		 * for one of the type's dependencies and no <code>fallbackProvider</code> is set
		 * @throws org.swiftsuspenders.errors.InjectorInterfaceConstructionError if the given type
		 * is an interface and no mapping was found
		 */
		function getOrCreateNewInstance(type:Class):*;

		/**
		 * Creates an instance of the given type and injects into it.
		 *
		 * @param type The type to instantiate
		 * @return The new instance, with all of its dependencies fulfilled
		 *
		 * @throws org.swiftsuspenders.errors.InjectorMissingMappingError if no mapping is found
		 * for one of the type's dependencies and no <code>fallbackProvider</code> is set
		 */
		function instantiateUnmapped(type:Class):*;

		/**
		 * Uses the <code>TypeDescription</code> the injector associates with the given instance's
		 * type to iterate over all <code>[PreDestroy]</code> methods in the instance, supporting
		 * automated destruction.
		 *
		 * @param instance The instance to destroy
		 */
		function destroyInstance(instance:Object):void;

		/**
		 * Destroys the injector by cleaning up all instances it manages.
		 *
		 * Cleanup in this context means iterating over all mapped dependency providers and invoking
		 * their <code>destroy</code> methods and calling preDestroy methods on all objects the
		 * injector created or injected into.
		 *
		 * Of note, the <link>SingletonProvider</link>'s implementation of <code>destroy</code>
		 * invokes all preDestroy methods on the managed singleton to guarantee its orderly
		 * destruction. Implementers of custom implementations of <link>DependencyProviders</link>
		 * are encouraged to do likewise.
		 */
		function teardown():void;

		/**
		 * Creates a new <code>Injector</code> and sets itself as that new <code>Injector</code>'s
		 * <code>parentInjector</code>.
		 *
		 * @param applicationDomain The optional domain to use in the new Injector.
		 * If not given, the creating injector's domain is set on the new Injector as well.
		 * @return The newly created <code>Injector</code> instance
		 *
		 * @see #parent
		 */
		function createChild(applicationDomain:ApplicationDomain = null):IInjector;
	}
}
