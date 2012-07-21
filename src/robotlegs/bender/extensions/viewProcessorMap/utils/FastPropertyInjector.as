//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils
{
	import org.swiftsuspenders.Injector;
	
	public class FastPropertyInjector
	{
		private var _propertyTypesByName:Object;

		public function FastPropertyInjector(propertyTypesByName:Object)
		{
			_propertyTypesByName = propertyTypesByName;
		}
		
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