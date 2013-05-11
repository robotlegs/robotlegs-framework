//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapper;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;

	/**
	 * The View Processor Map allows you to bind views to processors
	 */
	public interface IViewProcessorMap
	{
		/**
		 * Maps a matcher that will be tested against incoming items to be handled.
		 * @param matcher The type or package matcher specifying the rules for matching.
		 * @return the mapper so that you can continue the mapping.
		 */
		function mapMatcher(matcher:ITypeMatcher):IViewProcessorMapper;

		/**
		 * Maps a type that will be tested against incoming items to be handled.
		 * Under the hood this will create a TypeMatcher for this type.
		 * @param type The class or interface to be matched against.
		 * @return the mapper so that you can continue the mapping.
		 */
		function map(type:Class):IViewProcessorMapper;

		/**
		 * Removes a mapping that was made against a matcher.
		 * No error will be thrown if there isn't a mapping to remove.
		 * @param matcher The type or package matcher specifying the rules for matching.
		 * @return the unmapper so that you can continue the unmapping.
		 */
		function unmapMatcher(matcher:ITypeMatcher):IViewProcessorUnmapper;

		/**
		 * Removes a mapping that was made against a type.
		 * No error will be thrown if there isn't a mapping to remove.
		 * @param type The class or interface to be matched against.
		 * @return the unmapper so that you can continue the unmapping.
		 */
		function unmap(type:Class):IViewProcessorUnmapper;

		/**
		 * Processes an item directly. If the item matches any mapped matchers or types then it will be processed according to those mappings.
		 * @param item The item to process.
		 */
		function process(item:Object):void;

		/**
		 * Runs unprocess on relevant processors for an item if there are any.
		 * @param item The item to unprocess.
		 */
		function unprocess(item:Object):void;
	}
}
