//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

	/**
	 * The Mediator Map allows you to bind Mediators to objects
	 */
	public interface IMediatorMap
	{
		/**
		 * Maps a matcher that will be tested against incoming items to be handled.
		 * @param matcher The type or package matcher specifying the rules for matching.
		 * @return the mapper so that you can continue the mapping.
		 */
		function mapMatcher(matcher:ITypeMatcher):IMediatorMapper;

		/**
		 * Maps a type that will be tested against incoming items to be handled.
		 * Under the hood this will create a TypeMatcher for this type.
		 * @param type The class or interface to be matched against.
		 * @return the mapper so that you can continue the mapping.
		 */
		function map(type:Class):IMediatorMapper;

		/**
		 * Removes a mapping that was made against a matcher.
		 * No error will be thrown if there isn't a mapping to remove.
		 * @param matcher The type or package matcher specifying the rules for matching.
		 * @return the unmapper so that you can continue the unmapping.
		 */
		function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper;

		/**
		 * Removes a mapping that was made against a type.
		 * No error will be thrown if there isn't a mapping to remove.
		 * @param type The class or interface to be matched against.
		 * @return the unmapper so that you can continue the unmapping.
		 */
		function unmap(type:Class):IMediatorUnmapper;

		/**
		 * Mediates an item directly. If the item matches any mapped matchers or types then it will be mediated according to those mappings.
		 * @param item The item to create mediators for.
		 */
		function mediate(item:Object):void;

		/**
		 * Removes the mediators for an item if there are any.
		 * @param item The item to remove mediators for.
		 */
		function unmediate(item:Object):void;

		/**
		 * Removes all mediators
		 */
		function unmediateAll():void
	}
}
