//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.support
{
	import flash.display.Sprite;

	public class TreeSpriteSupport extends Sprite {

		// Testable constants
		public const children:Vector.<TreeSpriteSupport> = new Vector.<TreeSpriteSupport>();

		public function TreeSpriteSupport(tree_depth:uint, tree_width:uint) {
			populate(tree_depth, tree_width);
		}

		protected function populate(tree_depth:uint, tree_width:uint):void
		{
			if (tree_depth == 0) return;

			for (var i:uint = 0; i < tree_width; i++)
			{
				var child:TreeSpriteSupport = new TreeSpriteSupport(tree_depth-1, tree_width);
				children.push(child);
				addChild(child);
			}
		}
	}
}