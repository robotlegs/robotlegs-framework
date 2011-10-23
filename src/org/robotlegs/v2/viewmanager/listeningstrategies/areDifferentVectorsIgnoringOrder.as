//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import flash.display.DisplayObjectContainer;


	/*============================================================================*/
	/* Internal Functions                                                         */
	/*============================================================================*/

	// this function does not find an empty vector and a null vector to be different

	internal function areDifferentVectorsIgnoringOrder(v1:Vector.<DisplayObjectContainer>, v2:Vector.<DisplayObjectContainer>):Boolean
	{
		if ((v1 == null) && (v2 == null))
		{
			return false;
		}

		if ((v1 && v1.length) && (v2 == null))
		{
			return true;
		}

		if ((v2 && v2.length) && (v1 == null))
		{
			return true;
		}

		if (v1 == null || v2 == null)
		{
			return false;
		}

		if (v1.length != v2.length)
		{
			return true;
		}

		var searchIndex:int;

		var iLength:uint = v1.length;
		var searchVector:Vector.<DisplayObjectContainer> = v2.slice();
		for (var i:uint = 0; i < iLength; i++)
		{
			searchIndex = searchVector.indexOf(v1[i]);
			if (searchIndex == -1)
			{
				return true;
			}
			searchVector.splice(searchIndex, 1);
		}

		return false;
	}
}
