//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils
{
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * Avoids view reflection by using a provided map
	 * of property names to dependency values
	 */
	public class PropertyValueInjector
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _valuesByPropertyName:Object;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Value Property Injection Processor
		 *
		 * <code>
		 *     new PropertyValueInjector({
		 *         userService: myUserService,
		 *         userPM: myUserPM
		 *     })
		 * </code>
		 *
		 * @param valuesByPropertyName A map of property names to dependency values
		 */
		public function PropertyValueInjector(valuesByPropertyName:Object)
		{
			_valuesByPropertyName = valuesByPropertyName;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function process(view:Object, type:Class, injector:IInjector):void
		{
			for (var propName:String in _valuesByPropertyName)
			{
				view[propName] = _valuesByPropertyName[propName];
			}
		}

		/**
		 * @private
		 */
		public function unprocess(view:Object, type:Class, injector:IInjector):void
		{
		}
	}
}
