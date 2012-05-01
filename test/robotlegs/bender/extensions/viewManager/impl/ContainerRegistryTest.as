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
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.support.CallbackViewHandler;
	import robotlegs.bender.extensions.viewManager.support.TreeSpriteSupport;

	public class ContainerRegistryTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var registry:ContainerRegistry;

		private var container:DisplayObjectContainer;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			registry = new ContainerRegistry();
			container = new Sprite();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function addContainer():void
		{
			registry.addContainer(container);
		}

		[Test]
		public function finds_correct_nearest_interested_container_view_and_returns_its_binding():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			registry.addContainer(searchTrees[0]);
			registry.addContainer(searchTrees[1]);

			var correctTree:TreeSpriteSupport = searchTrees[1];

			var searchItem:Sprite = correctTree.children[3].children[3].children[3].children[3];

			var result:ContainerBinding = registry.findParentBinding(searchItem);

			// TODO: use a matcher
			assertEquals("Finds correct nearest interested container view and returns its binding", correctTree, result.container);
		}

		[Test]
		public function binding_returns_with_correct_interested_parent_chain():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			registry.addContainer(searchTrees[0]);
			registry.addContainer(searchTrees[1]);
			registry.addContainer(searchTrees[1].children[3]);

			var searchItem:Sprite = searchTrees[1].children[3].children[3].children[3].children[3];

			var result:ContainerBinding = registry.findParentBinding(searchItem);

			// TODO: use a matcher
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent);
		}

		[Test]
		public function binding_returns_with_correct_interested_parent_chain_if_interested_views_added_in_wrong_order():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			registry.addContainer(searchTrees[0]);
			registry.addContainer(searchTrees[1].children[3]);
			registry.addContainer(searchTrees[1]);

			var searchItem:Sprite = searchTrees[1].children[3].children[3].children[3].children[3];

			var result:ContainerBinding = registry.findParentBinding(searchItem);

			// TODO: use a matcher
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent);
		}

		[Test]
		public function binding_returns_with_correct_interested_parent_chain_if_interested_views_added_in_wrong_order_with_gaps():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			registry.addContainer(searchTrees[0]);
			registry.addContainer(searchTrees[1].children[3].children[2]);
			registry.addContainer(searchTrees[1]);

			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];

			var result:ContainerBinding = registry.findParentBinding(searchItem);

			// TODO: use a matcher
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent);
		}

		[Test]
		public function binding_returns_with_correct_interested_parent_chain_after_removal():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			registry.addContainer(searchTrees[0]);
			registry.addContainer(searchTrees[1]);
			registry.addContainer(searchTrees[1].children[3].children[2].children[3]);
			registry.addContainer(searchTrees[1].children[3].children[2]);
			registry.addContainer(searchTrees[1].children[3]);

			registry.removeContainer(searchTrees[1].children[3].children[2]);

			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];

			var result:ContainerBinding = registry.findParentBinding(searchItem);

			// TODO: use a matcher
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1].children[3], result.parent.container);
			assertEquals("Binding returns with correct container parent parent view", searchTrees[1], result.parent.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent.parent);
		}

		[Test]
		public function returns_null_if_search_item_is_not_inside_an_included_view():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			registry.addContainer(searchTrees[0]);
			registry.addContainer(searchTrees[1]);
			registry.addContainer(searchTrees[1].children[3].children[2].children[3]);
			registry.addContainer(searchTrees[1].children[3].children[2]);
			registry.addContainer(searchTrees[1].children[3]);

			registry.removeContainer(searchTrees[1].children[3].children[2]);

			var searchItem:Sprite = searchTrees[2].children[3].children[2].children[3].children[3];

			var result:ContainerBinding = registry.findParentBinding(searchItem);

			// TODO: use a matcher
			assertEquals("Returns null if not inside an included view", null, result);
		}

		[Test]
		public function returns_root_container_view_bindings_one_item():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(1, 1);
			var expectedBinding:ContainerBinding = registry.addContainer(searchTrees[0]);
			var expectedRootBindings:Vector.<ContainerBinding> = new <ContainerBinding>[expectedBinding];
			// TODO: use a matcher
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, registry.rootBindings);
		}

		[Test]
		public function returns_root_container_view_bindings_many_items():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);

			var firstExpectedBinding:ContainerBinding = registry.addContainer(searchTrees[0]);

			registry.addContainer(searchTrees[1].children[3].children[2].children[3]);
			registry.addContainer(searchTrees[1].children[3].children[2]);

			var secondExpectedBinding:ContainerBinding = registry.addContainer(searchTrees[1]);

			registry.addContainer(searchTrees[1].children[3]);

			var expectedRootBindings:Vector.<ContainerBinding> = new <ContainerBinding>[firstExpectedBinding, secondExpectedBinding];

			// TODO: use a matcher
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, registry.rootBindings);
		}

		[Test]
		public function returns_root_container_view_bindings_many_items_after_removals():void
		{
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);

			var firstExpectedBinding:ContainerBinding = registry.addContainer(searchTrees[0]);

			registry.addContainer(searchTrees[1].children[3].children[2].children[3]);
			registry.addContainer(searchTrees[1].children[3].children[2]);
			registry.addContainer(searchTrees[1]);

			var secondExpectedBinding:ContainerBinding = registry.addContainer(searchTrees[1].children[3]);

			registry.removeContainer(searchTrees[1]);

			var expectedRootBindings:Vector.<ContainerBinding> = new <ContainerBinding>[firstExpectedBinding, secondExpectedBinding];

			// TODO: use a matcher
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, registry.rootBindings);
		}

		[Test]
		public function adding_container_dispatches_event():void
		{
			var callCount:int = 0;
			registry.addEventListener(
				ContainerRegistryEvent.CONTAINER_ADD,
				function onContainerAdd(event:ContainerRegistryEvent):void {
					callCount++;
				});
			registry.addContainer(container);
			registry.addContainer(container);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function removing_container_dispatches_event():void
		{
			var callCount:int = 0;
			registry.addEventListener(
				ContainerRegistryEvent.CONTAINER_REMOVE,
				function onContainerAdd(event:ContainerRegistryEvent):void {
					callCount++;
				});
			registry.addContainer(container);
			registry.removeContainer(container);
			registry.removeContainer(container);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function adding_root_container_dispatches_event():void
		{
			var callCount:int = 0;
			registry.addEventListener(
				ContainerRegistryEvent.ROOT_CONTAINER_ADD,
				function onContainerAdd(event:ContainerRegistryEvent):void {
					callCount++;
				});
			registry.addContainer(container);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function empty_binding_is_removed():void
		{
			const handler:IViewHandler = new CallbackViewHandler();
			registry.addContainer(container).addHandler(handler);
			registry.getBinding(container).removeHandler(handler);
			assertThat(registry.getBinding(container), nullValue());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createTrees(tree_depth:uint, tree_width:uint):Vector.<TreeSpriteSupport>
		{
			const trees:Vector.<TreeSpriteSupport> = new Vector.<TreeSpriteSupport>();
			for (var i:uint = 0; i < tree_width; i++)
			{
				var nextTree:TreeSpriteSupport = new TreeSpriteSupport(tree_depth, tree_width);
				trees.push(nextTree);
			}
			return trees;
		}
	}
}
