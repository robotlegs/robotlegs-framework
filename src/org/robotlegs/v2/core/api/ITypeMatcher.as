package org.robotlegs.v2.core.api {
		
	public interface ITypeMatcher {
		
		function get typeFilter():ITypeFilter;
		
		function allOf(types:Vector.<Class>):ITypeMatcher;
		
		function anyOf(types:Vector.<Class>):ITypeMatcher;
		
		function noneOf(types:Vector.<Class>):ITypeMatcher;
		
	}
}
