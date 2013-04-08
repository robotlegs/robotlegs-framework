//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{

	public class CommandPayloadConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _payloadValues:Array;

		public function get payloadValues():Array
		{
			return _payloadValues;
		}

		private var _payloadClasses:Array;

		public function get payloadClasses():Array
		{
			return _payloadClasses;
		}

		public function get payloadLength():uint
		{
			return payloadClasses.length;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandPayloadConfig(payloadValues:Array = null, payloadClasses:Array = null)
		{
			_payloadValues = payloadValues;
			_payloadClasses = payloadClasses;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addPayload(payloadValue:Object, payloadClass:Class):void
		{
			_payloadValues ||= [];
			_payloadValues.push(payloadValue);
			_payloadClasses ||= [];
			_payloadClasses.push(payloadClass);
		}

		public function hasPayload():Boolean
		{
			return payloadValues
				&& payloadValues.length > 0
				&& payloadClasses
				&& payloadClasses.length == payloadValues.length;
		}
	}
}
