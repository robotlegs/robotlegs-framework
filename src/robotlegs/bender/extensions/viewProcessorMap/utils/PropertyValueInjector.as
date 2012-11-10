//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils
{
	import org.swiftsuspenders.Injector;

	public class PropertyValueInjector
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _valuesByPropertyName:Object;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PropertyValueInjector(valuesByPropertyName:Object)
		{
			_valuesByPropertyName = valuesByPropertyName;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function process(view:Object, type:Class, injector:Injector):void
		{
			for (var propName:String in _valuesByPropertyName)
			{
				view[propName] = _valuesByPropertyName[propName];
			}
		}

		public function unprocess(view:Object, type:Class, injector:Injector):void
		{

		}
	}
}
