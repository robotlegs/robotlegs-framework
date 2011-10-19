package org.robotlegs.v2.core.api {
		
	public interface ITypeFilter {
		
		function get allOfTypes():Vector.<Class>;
		
		function get anyOfTypes():Vector.<Class>;
		
		function get noneOfTypes():Vector.<Class>;
		
		function get descriptor():String;
		
	}
}
