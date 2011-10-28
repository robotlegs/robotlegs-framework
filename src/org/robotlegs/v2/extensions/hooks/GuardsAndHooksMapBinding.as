//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{	
	public class GuardsAndHooksMapBinding implements IGuardsAndHooksMapBinding
	{
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/
		
		protected var _hooks:Vector.<Class> = new Vector.<Class>();
		protected var _guards:Vector.<Class> = new Vector.<Class>();
	
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
	
		public function GuardsAndHooksMapBinding()
		{
			
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
	
		public function get hooks():Vector.<Class>
		{
			return _hooks;
		}
	
		public function get guards():Vector.<Class>
		{
			return _guards;
		}
	
		public function withHooks(...hookClasses):IGuardsAndHooksMapBinding
		{
			pushValuesToVector(hookClasses, _hooks);
			return this;
		}
		
		public function withGuards(...guardClasses):IGuardsAndHooksMapBinding
		{
			pushValuesToVector(guardClasses, _guards);
		
			return this;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
	
		protected function pushValuesToVector(values:Array, vector:Vector.<Class>):void
		{
			if(values.length==1)
			{
				if(values[0] is Array)
				{
					values = values[0]
				}
				else if(values[0] is Vector.<Class>)
				{
					values = createArrayFromVector(values[0]);
				}
			}
		
			for each (var clazz:Class in values)
			{
				vector.push(clazz);
			}
		}
	
		protected function createArrayFromVector(typesVector:Vector.<Class>):Array
		{
			const returnArray:Array = [];

			for each (var type:Class in typesVector)
			{
				returnArray.push(type);
			}

			return returnArray;
		}
	}
}