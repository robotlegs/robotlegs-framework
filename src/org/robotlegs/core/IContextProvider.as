/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.core
{
	
	/**
	 * The Robotlegs Context Provider contract
	 */
	public interface IContextProvider
	{
		/**
		 * Retrieve the <code>IContext</code>
		 * @return The <code>IContext</code>
		 */
		function getContext():IContext;
	}
}