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
	public class CommandPayload
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _values:Array;

		/**
		 * Ordered list of values
		 */
		public function get values():Array
		{
			return _values;
		}

		private var _classes:Array;

		/**
		 * Ordered list of value classes
		 */
		public function get classes():Array
		{
			return _classes;
		}

		/**
		 * The number of payload items
		 */
		public function get length():uint
		{
			return _classes ? _classes.length : 0;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a command payload
		 * @param values Optional values
		 * @param classes Optional classes
		 */
		public function CommandPayload(values:Array = null, classes:Array = null)
		{
			_values = values;
			_classes = classes;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Adds an item to this payload
		 * @param payloadValue The value
		 * @param payloadClass The class of the value
		 * @return Self
		 */
		public function addPayload(payloadValue:Object, payloadClass:Class):CommandPayload
		{
			if (_values)
			{
				_values.push(payloadValue);
			}
			else
			{
				_values = [payloadValue];
			}
			if (_classes)
			{
				_classes.push(payloadClass);
			}
			else
			{
				_classes = [payloadClass];
			}

			return this;
		}

		/**
		 * Does this payload have any items?
		 * @return Boolean
		 */
		public function hasPayload():Boolean
		{
			// todo: the final clause will make this fail silently
			// todo: rethink
			return _values && _values.length > 0
				&& _classes && _classes.length == _values.length;
		}
	}
}
