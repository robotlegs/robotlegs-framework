package  {

	import flash.display.Sprite;

	public class TreeSpriteSupport extends Sprite {
		
		// Testable constants
		public const children:Vector.<TreeSpriteSupport> = new Vector.<TreeSpriteSupport>();
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function TreeSpriteSupport(tree_depth:uint, tree_width:uint) {			
			populate(tree_depth, tree_width);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
				
		protected function populate(tree_depth:uint, tree_width:uint):void
		{
			if(tree_depth == 0) return;
			
			var iLength:uint = tree_width;

			for (var i:uint = 0; i < iLength; i++)
			{                 
				var child:TreeSpriteSupport = new TreeSpriteSupport(tree_depth-1, tree_width);
				children.push(child);
				addChild(child);
			}
		}
		
		
	}
}