package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class TreeNode extends Object
	{
	
		protected var _target:DisplayObjectContainer;
	
		public function TreeNode(target:DisplayObjectContainer)
		{
			_target = target;
		}
	
		public function contains(needle:DisplayObject):Boolean
		{
			return _target.contains(needle)
		}
	
		protected var _sibling:TreeNode;

		public function get sibling():TreeNode
		{
			return _sibling;
		}

		public function set sibling(value:TreeNode):void
		{
			_sibling = value;
		}   
	
		protected var _firstChild:TreeNode;

		public function get firstChild():TreeNode
		{
			return _firstChild;
		}

		public function set firstChild(value:TreeNode):void
		{
			if (value !== _firstChild)
			{
				_firstChild = value;
			}
		}
		
		public function getAncestory(needle:DisplayObject):Vector.<TreeNode>
		{
			if(!contains(needle)) return null;
		
			var child:TreeNode = firstChild;
			var ancestory:Vector.<TreeNode>;
			while(child)
			{
				if(child.contains(needle))
				{
					ancestory = child.getAncestory(needle);
					ancestory.unshift(this);
					return ancestory;
				}
			
				child = child.sibling;
			}  
		
			return new <TreeNode>[this];
		}
		
		public function getDeepestChildContaining(needle:DisplayObject):TreeNode
		{
			if(!contains(needle)) return null;
		
			var child:TreeNode = firstChild;
			var ancestory:Vector.<TreeNode>;
			while(child)
			{
				if(child.contains(needle))
				{
					return child.getDeepestChildContaining(needle);
				}
			
				child = child.sibling;
			}  
		
			return this;
		}
   
	}

}