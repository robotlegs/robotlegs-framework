//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks.impl
{
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IGuardsAndHooksConfig;

	[Deprecated(message="any class, method or property with the word AND in it is banned :)")]
	public class GuardsAndHooksConfig implements IGuardsAndHooksConfig
	{

		protected const _guards:Vector.<Class> = new Vector.<Class>();

		public function get guards():Vector.<Class>
		{
			return _guards;
		}

		protected const _hooks:Vector.<Class> = new Vector.<Class>();

		public function get hooks():Vector.<Class>
		{
			return _hooks;
		}

		public function withGuards(... guardClasses):IGuardsAndHooksConfig
		{
			pushValuesToClassVector(guardClasses, _guards);
			return this;
		}

		public function withHooks(... hookClasses):IGuardsAndHooksConfig
		{
			pushValuesToClassVector(hookClasses, _hooks);
			return this;
		}
	}
}