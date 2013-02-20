//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.dsl
{

	/**
	 * Configures a mediator mapping
	 */
	public interface IMediatorMappingConfig
	{
		/**
		 * Guards to check before allowing a mediator to be created
		 * @param guards Guards
		 * @return Self
		 */
		function withGuards(... guards):IMediatorMappingConfig;

		/**
		 * Hooks to run before a mediator is created
		 * @param hooks Hooks
		 * @return Self
		 */
		function withHooks(... hooks):IMediatorMappingConfig;

		/**
		 * Should the mediator be removed when the mediated item looses scope?
		 *
		 * <p>Usually this would be when the mediated item is a Display Object
		 * and it leaves the stage.</p>
		 *
		 * @param value Boolean
		 * @return Self
		 */
		function autoRemove(value:Boolean = true):IMediatorMappingConfig;
	}
}
