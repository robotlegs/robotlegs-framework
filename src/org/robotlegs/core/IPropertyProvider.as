package org.robotlegs.core
{
	
	public interface IPropertyProvider
	{
		/**
		 * Try to find a property on a parent
		 * @param name The name of the property
		 * @param type The type of the property
		 * @return The returned property or null if not found
		 */
		function findProperty(name:String, type:*):*;
		
		/**
		 * Provide a property when asked for one
		 * You should override this method and return any properties you wish to provide
		 * @param name The name of the property that is being asked for
		 * @param type The type of the property that is being asked for
		 * @return The property that you want to return or null
		 */
		function provideProperty(name:String, type:*):*;
	
	}
}