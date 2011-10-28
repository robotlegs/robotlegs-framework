//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{

	public class GuardsAndHooksConfig implements IGuardsAndHooksConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _guards:Vector.<Class> = new Vector.<Class>();

		public function get guards():Vector.<Class>
		{
			return _guards;
		}

		protected var _hooks:Vector.<Class> = new Vector.<Class>();

		public function get hooks():Vector.<Class>
		{
			return _hooks;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function GuardsAndHooksConfig()
		{

		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withGuards(... guardClasses):IGuardsAndHooksConfig
		{
			pushValuesToVector(guardClasses, _guards);

			return this;
		}

		public function withHooks(... hookClasses):IGuardsAndHooksConfig
		{
			pushValuesToVector(hookClasses, _hooks);
			return this;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function createArrayFromVector(typesVector:Vector.<Class>):Array
		{
			const returnArray:Array = [];

			for each (var type:Class in typesVector)
			{
				returnArray.push(type);
			}

			return returnArray;
		}

		protected function pushValuesToVector(values:Array, vector:Vector.<Class>):void
		{
			if (values.length == 1)
			{
				if (values[0] is Array)
				{
					values = values[0]
				}
				else if (values[0] is Vector.<Class>)
				{
					values = createArrayFromVector(values[0]);
				}
			}

			for each (var clazz:Class in values)
			{
				vector.push(clazz);
			}
		}
	}
}
