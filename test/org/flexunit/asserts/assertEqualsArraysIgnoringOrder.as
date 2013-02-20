//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.flexunit.asserts
{
	import flash.errors.IllegalOperationError;
	import flexunit.framework.AssertionFailedError;
	import org.flexunit.Assert;

	/**
	 * Custom assert for FlexUnit for comparing vectors
	 *
	 * @param args
	 * 			Must be passed at least 2 arguments of type Array to compare for equality.
	 * 			If three arguments are passed, the first argument must be a String
	 * 			and will be used as the error message.
	 *
	 * 			<code>assertEqualsArraysIgnoringOrder( String, Array, Array );</code>
	 * 			<code>assertEqualsArraysIgnoringOrder( Array, Array );</code>
	 *
	 */
	// TODO: turn this into a Hamcrest matcher
	public function assertEqualsArraysIgnoringOrder(... args:Array):void
	{
		var message:String;
		var expected:Array;
		var actual:Array;

		if (args.length == 2)
		{
			message = "";
			expected = args[0];
			actual = args[1];
		}
		else if (args.length == 3)
		{
			message = args[0];
			expected = args[1];
			actual = args[2];
		}
		else
		{
			throw new IllegalOperationError("Invalid argument count");
		}

		if (expected == null && actual == null)
		{
			return;
		}
		if ((expected == null && actual != null) || (expected != null && actual == null))
		{
			Assert.failNotEquals(message, expected, actual);
		}
		// from here on: expected != null && actual != null
		if (expected.length != actual.length)
		{
			Assert.failNotEquals(message, expected, actual);
		}

		const actual_workingCopy:Array = actual.slice();

		for (var i:int = 0; i < expected.length; i++)
		{
			var foundMatch:Boolean = false;
			var expectedMember:Object = expected[i];
			for (var j:int = 0; j < actual_workingCopy.length; j++)
			{
				var actualMember:Object = actual_workingCopy[j];
				try
				{
					Assert.assertEquals(expectedMember, actualMember);
					foundMatch = true;
					actual_workingCopy.splice(j, 1);
					break;
				}
				catch (e:AssertionFailedError)
				{
					//  no match, try next
				}
			}
			if (!foundMatch)
			{
				Assert.failNotEquals("Found no match for " + expectedMember + ";", expected, actual);
			}
		}
	}
}
