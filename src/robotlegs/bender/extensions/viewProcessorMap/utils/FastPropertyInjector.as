//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils
{
	import org.swiftsuspenders.Injector;

	public class FastPropertyInjector
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _propertyTypesByName:Object;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FastPropertyInjector(propertyTypesByName:Object)
		{
			_propertyTypesByName = propertyTypesByName;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function process(view:Object, type:Class, injector:Injector):void
		{
			for (var propName:String in _propertyTypesByName)
			{
				view[propName] = injector.getInstance(_propertyTypesByName[propName]);
			}
		}

		public function unprocess(view:Object, type:Class, injector:Injector):void
		{

		}
	}
}
