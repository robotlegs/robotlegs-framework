//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class FewestListenersViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		// Finds the nearest common parent for the possible targets
		// Will return a single value unless possible targets are in diff windows
		public function FewestListenersViewListeningStrategy(targets:Vector.<DisplayObjectContainer>):void
		{
			super(targets);
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			var foundCommonParents:Vector.<DisplayObjectContainer> = findCommonParents(value);

			var changed:Boolean = changeCommonParents(foundCommonParents);

			return changed;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function changeCommonParents(updatedCommonParents:Vector.<DisplayObjectContainer>):Boolean
		{
			var oldCommonParents:Vector.<DisplayObjectContainer> = _targets;
			_targets = updatedCommonParents;

			return areDifferentVectorsIgnoringOrder(_targets, oldCommonParents);
		}

		/* 	Searches child lists from the top down. We know the [0] entries match
		  because they were already filtered on this basis, so start at [1].
		  When we find an entry that differs we know the previous level was the lowest common ancestor/root.

			NOTE: if this method proves to be slow we could use a binary approach and jump to the lowest
			length, then the mid point of [0] - [i] or [i] - [length-1] each time.
			Would pay off for LCA > length-as-power-of-2. But this code should run infrequently. */

		protected function extractLowestCommonAncestorFrom(ancestoryWithCommonRoots:Vector.<Vector.<DisplayObjectContainer>>):DisplayObjectContainer
		{
			var iLength:uint = ancestoryWithCommonRoots[0].length;
			var jLength:uint = ancestoryWithCommonRoots.length;

			if (jLength < 2)
			{
				return ancestoryWithCommonRoots[0][iLength - 1];
			}

			var entry:DisplayObjectContainer;

			for (var i:int = 1; i < iLength; i++)
			{
				entry = ancestoryWithCommonRoots[0][i];

				for (var j:int = 1; j < jLength; j++)
				{
					if ((ancestoryWithCommonRoots[j].length == i) ||
						(ancestoryWithCommonRoots[j][i] != entry))
					{
						return ancestoryWithCommonRoots[j][i - 1];
					}
				}
			}

			return ancestoryWithCommonRoots[0][i - 1];
		}

		protected function findCommonParents(value:Vector.<DisplayObjectContainer>):Vector.<DisplayObjectContainer>
		{
			if ((value == null) || (value.length == 0))
			{
				return null;
			}
			var nextChild:DisplayObjectContainer;
			var nextParent:DisplayObjectContainer;
			// put each linked list of parents into a vector in reverse order so the top of the tree is first
			// if this code needs to be optimised then first consider making this a linked list of child.child.child
			var childLineage:Vector.<DisplayObjectContainer>;
			// used to separate the lineages into their common roots (for multiple stages/windows)
			var childLineagesByRoot:Dictionary = new Dictionary();
			var childRoot:DisplayObjectContainer;
			// the collection of child lineages for any particular root (stage)
			var childRootSet:Vector.<Vector.<DisplayObjectContainer>>;

			var iLength:uint = value.length;

			for (var i:uint = 0; i < iLength; i++)
			{
				nextChild = value[i];
				nextParent = nextChild;
				childLineage = new Vector.<DisplayObjectContainer>();
				while (nextParent)
				{
					// backwards because we want root (stage) to be [0]
					childLineage.unshift(nextParent);
					nextParent = nextParent.parent;
				}

				childRoot = childLineage[0];
				childRootSet = (childLineagesByRoot[childRoot] ||= new Vector.<Vector.<DisplayObjectContainer>>());
				childRootSet.push(childLineage);
			}

			var returnVector:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();

			for each (childRootSet in childLineagesByRoot)
			{
				returnVector.push(extractLowestCommonAncestorFrom(childRootSet));
			}

			return returnVector;
		}
	}
}
