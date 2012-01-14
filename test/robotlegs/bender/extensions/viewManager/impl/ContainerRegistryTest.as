//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.impl.support.ViewHandlerSupport;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import ArgumentError;
	import robotlegs.bender.support.TreeSpriteSupport;

	public class ContainerRegistryTest
	{

		protected var instance:ContainerRegistry;

		[Before]
		public function setUp():void
		{
			instance = new ContainerRegistry();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function finds_correct_nearest_interested_container_view_and_returns_its_binding():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.registerContainer(searchTrees[0]);
			instance.registerContainer(searchTrees[1]);

			var correctTree:TreeSpriteSupport = searchTrees[1];

			var searchItem:Sprite = correctTree.children[3].children[3].children[3].children[3];

			var result:ContainerBinding = instance.findParentBinding(searchItem);

	    	assertEquals("Finds correct nearest interested container view and returns its binding", correctTree, result.container);
	    }

		[Test]
		public function binding_returns_with_correct_interested_parent_chain():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.registerContainer(searchTrees[0]);
			instance.registerContainer(searchTrees[1]);
			instance.registerContainer(searchTrees[1].children[3]);

			var searchItem:Sprite = searchTrees[1].children[3].children[3].children[3].children[3];

			var result:ContainerBinding = instance.findParentBinding(searchItem);

			assertEquals("Binding returns with correct container view", searchTrees[1].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent);
		}

		[Test]
		public function binding_returns_with_correct_interested_parent_chain_if_interested_views_added_in_wrong_order():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.registerContainer(searchTrees[0]);
			instance.registerContainer(searchTrees[1].children[3]);
			instance.registerContainer(searchTrees[1]);

			var searchItem:Sprite = searchTrees[1].children[3].children[3].children[3].children[3];

			var result:ContainerBinding = instance.findParentBinding(searchItem);

			assertEquals("Binding returns with correct container view", searchTrees[1].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent);
		}

		[Test]
		public function binding_returns_with_correct_interested_parent_chain_if_interested_views_added_in_wrong_order_with_gaps():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.registerContainer(searchTrees[0]);
			instance.registerContainer(searchTrees[1].children[3].children[2]);
			instance.registerContainer(searchTrees[1]);

			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];

			var result:ContainerBinding = instance.findParentBinding(searchItem);

			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent);
		}

	    [Test]
		public function binding_returns_with_correct_interested_parent_chain_after_removal():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.registerContainer(searchTrees[0]);
			instance.registerContainer(searchTrees[1]);
			instance.registerContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.registerContainer(searchTrees[1].children[3].children[2]);
			instance.registerContainer(searchTrees[1].children[3]);

			instance.unregisterContainer(searchTrees[1].children[3].children[2]);

			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];

			var result:ContainerBinding = instance.findParentBinding(searchItem);

			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1].children[3], result.parent.container);
			assertEquals("Binding returns with correct container parent parent view", searchTrees[1], result.parent.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent.parent);
		}

		[Test]
		public function returns_null_if_search_item_is_not_inside_an_included_view():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.registerContainer(searchTrees[0]);
			instance.registerContainer(searchTrees[1]);
			instance.registerContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.registerContainer(searchTrees[1].children[3].children[2]);
			instance.registerContainer(searchTrees[1].children[3]);

			instance.unregisterContainer(searchTrees[1].children[3].children[2]);

			var searchItem:Sprite = searchTrees[2].children[3].children[2].children[3].children[3];

			var result:ContainerBinding = instance.findParentBinding(searchItem);

			assertEquals("Returns null if not inside an included view", null, result);
		}

		[Test]
		public function returns_root_container_view_bindings_one_item():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(1, 1);
			var expectedBinding:ContainerBinding = instance.registerContainer(searchTrees[0]);
            var expectedRootBindings:Vector.<ContainerBinding> = new <ContainerBinding>[expectedBinding];
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, instance.rootBindings);
		}

		[Test]
		public function returns_root_container_view_bindings_many_items():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);

			var firstExpectedBinding:ContainerBinding = instance.registerContainer(searchTrees[0]);

			instance.registerContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.registerContainer(searchTrees[1].children[3].children[2]);

			var secondExpectedBinding:ContainerBinding = instance.registerContainer(searchTrees[1]);

			instance.registerContainer(searchTrees[1].children[3]);

			var expectedRootBindings:Vector.<ContainerBinding> = new <ContainerBinding>[firstExpectedBinding, secondExpectedBinding];

			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, instance.rootBindings);
		}

		[Test]
		public function returns_root_container_view_bindings_many_items_after_removals():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);

			var firstExpectedBinding:ContainerBinding = instance.registerContainer(searchTrees[0]);

			instance.registerContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.registerContainer(searchTrees[1].children[3].children[2]);
			instance.registerContainer(searchTrees[1]);

			var secondExpectedBinding:ContainerBinding = instance.registerContainer(searchTrees[1].children[3]);

			instance.unregisterContainer(searchTrees[1]);

			var expectedRootBindings:Vector.<ContainerBinding> = new <ContainerBinding>[firstExpectedBinding, secondExpectedBinding];

			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, instance.rootBindings);
		}


		protected function createTrees(tree_depth:uint, tree_width:uint):Vector.<TreeSpriteSupport>
		{
			var trees:Vector.<TreeSpriteSupport> = new Vector.<TreeSpriteSupport>();
			var iLength:uint = tree_width;
			for (var i:uint = 0; i < iLength; i++)
			{
				var nextTree:TreeSpriteSupport = new TreeSpriteSupport(tree_depth, tree_width);
				trees.push(nextTree);
			}
			return trees;
		}
	}
}