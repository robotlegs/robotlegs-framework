//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.flexunit.asserts
{
	import flash.errors.IllegalOperationError;
	import org.flexunit.Assert;

	/**
	 * Custom assert for FlexUnit for comparing vectors
	 *
	 * @param args
	 * 			Must be passed at least 2 arguments of type Vector to compare for equality.
	 * 			If three arguments are passed, the first argument must be a String
	 * 			and will be used as the error message.
	 *
	 * 			<code>assertEqualsVectorsIgnoringOrder( String, Vector.<T>, Vector.<T> );</code>
	 * 			<code>assertEqualsVectorsIgnoringOrder( Vector.<T>, Vector.<T> );</code>
	 *
	 */
	// TODO: turn this into a Hamcrest matcher
	public function assertEqualsVectorsIgnoringOrder(... args):void
	{

		var message:String;
		var expected:Vector.<*>;
		var actual:Vector.<*>;

		if (args.length == 2)
		{
			message = "";
			expected = Vector.<*>(args[0]);
			actual = Vector.<*>(args[1]);
		}
		else if (args.length == 3)
		{
			message = args[0];
			expected = Vector.<*>(args[1]);
			actual = Vector.<*>(args[2]);
		}
		else
		{
			throw new IllegalOperationError("Invalid argument count on assertEqualsArraysIgnoringOrder");
		}

		var expected_array:Array = [];
		for each (var expectedItem:* in expected)
		{
			expected_array.push(expectedItem);
		}

		var actual_array:Array = [];
		for each (var actualItem:* in actual)
		{
			actual_array.push(actualItem);
		}

		assertEqualsArraysIgnoringOrder(message, expected_array, actual_array);
	}
}
