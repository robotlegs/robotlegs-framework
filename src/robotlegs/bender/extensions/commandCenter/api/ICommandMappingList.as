//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	/**
	 * @private
	 */
	public interface ICommandMappingList
	{
		/**
		 * Optional mapping sort function
		 * @param sorter Sort function
		 * @return Self
		 */
		function withSortFunction(sorter:Function):ICommandMappingList;

		/**
		 * Sorted list of active mappings
		 * @return List of mappings
		 */
		function getList():Vector.<ICommandMapping>;

		/**
		 * Adds a mapping to the mapping list
		 * @param mapping Command mapping
		 */
		function addMapping(mapping:ICommandMapping):void;

		/**
		 * Removes a mapping from the mapping list
		 * @param mapping Command mapping
		 */
		function removeMapping(mapping:ICommandMapping):void;

		/**
		 * Removes a mapping from the mapping list using the Command class
		 * @param commandClass The command class to remove the mapping for
		 */
		function removeMappingFor(commandClass:Class):void;

		/**
		 * Removes all mappings for this command mapping list
		 */
		function removeAllMappings():void;
	}
}
