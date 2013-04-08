//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{

	public class CommandPayload
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _values:Array;

		public function get values():Array
		{
			return _values;
		}

		private var _classes:Array;

		public function get classes():Array
		{
			return _classes;
		}

		public function get length():uint
		{
			return _classes ? _classes.length : 0;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandPayload(values:Array = null, classes:Array = null)
		{
			_values = values;
			_classes = classes;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addPayload(payloadValue:Object, payloadClass:Class):void
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
		}

		public function hasPayload():Boolean
		{
			// todo: the final clause will make this fail silently
			// todo: rethink
			return _values && _values.length > 0
				&& _classes && _classes.length == _values.length;
		}
	}
}
