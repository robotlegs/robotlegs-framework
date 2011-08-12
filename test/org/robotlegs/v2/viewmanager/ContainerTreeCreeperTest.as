package org.robotlegs.v2.viewmanager {

	import asunit.framework.TestCase;
	import org.robotlegs.v2.viewmanager.IContainerBinding;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.viewmanager.TreeNode;

	public class ContainerTreeCreeperTest extends TestCase {
		private var instance:ContainerTreeCreeper;
		private var rootsReceived:Vector.<IContainerBinding>;

		public function ContainerTreeCreeperTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ContainerTreeCreeper();
			rootsReceived = null;
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}
        
		public function testInstantiated():void {
			assertTrue("instance is ContainerTreeCreeper", instance is ContainerTreeCreeper);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
	    public function test_finds_correct_nearest_interested_container_view_and_returns_its_binding():void {  
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1]);
			
			var correctTree:TreeSpriteSupport = searchTrees[1];
			                                            
			var searchItem:Sprite = correctTree.children[3].children[3].children[3].children[3];
		    
			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     
					
	    	assertEquals("Finds correct nearest interested container view and returns its binding", correctTree, result.container);
	    }
	
		public function test_binding_returns_with_correct_interested_parent_chain():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1]);
			instance.includeContainer(searchTrees[1].children[3]);
						
			var searchItem:Sprite = searchTrees[1].children[3].children[3].children[3].children[3];
		    
			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     
			                                                                                                                     
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent); 
		}
		
		public function test_binding_returns_with_correct_interested_parent_chain_if_interested_views_added_in_wrong_order():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1].children[3]);
			instance.includeContainer(searchTrees[1]);
						
			var searchItem:Sprite = searchTrees[1].children[3].children[3].children[3].children[3];
		    
			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent); 
		}


		public function test_binding_returns_with_correct_interested_parent_chain_if_interested_views_added_in_wrong_order_with_gaps():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1].children[3].children[2]);
			instance.includeContainer(searchTrees[1]);
						
			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];
		    
			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     
			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1], result.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent); 
		}
		
	     public function test_binding_returns_with_correct_interested_parent_chain_after_removal():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1]);          
			instance.includeContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.includeContainer(searchTrees[1].children[3].children[2]);
			instance.includeContainer(searchTrees[1].children[3]);  
			
			instance.excludeContainer(searchTrees[1].children[3].children[2]);

			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];

			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     

			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1].children[3], result.parent.container);
			assertEquals("Binding returns with correct container parent parent view", searchTrees[1], result.parent.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent.parent); 
		}
		
		public function test_binding_returns_with_correct_interested_parent_chain_after_removal_via_binding_remove():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1]);          
			instance.includeContainer(searchTrees[1].children[3].children[2].children[3]);
			var bindingToRemove:IContainerBinding = instance.includeContainer(searchTrees[1].children[3].children[2]);
			instance.includeContainer(searchTrees[1].children[3]);  
			
			bindingToRemove.remove();

			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];

			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     

			assertEquals("Binding returns with correct container view", searchTrees[1].children[3].children[2].children[3], result.container);
			assertEquals("Binding returns with correct container parent view", searchTrees[1].children[3], result.parent.container);
			assertEquals("Binding returns with correct container parent parent view", searchTrees[1], result.parent.parent.container);
			assertEquals("Further parents are null", null, result.parent.parent.parent); 
		}
		
		public function test_returns_null_if_search_item_is_not_inside_an_included_view():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1]);          
			instance.includeContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.includeContainer(searchTrees[1].children[3].children[2]);
			instance.includeContainer(searchTrees[1].children[3]);  
			
			instance.excludeContainer(searchTrees[1].children[3].children[2]);

			var searchItem:Sprite = searchTrees[2].children[3].children[2].children[3].children[3];

			var preTime:Number = getTimer();
			var result:IContainerBinding = instance.findParentBindingFor(searchItem);
			trace("found parent " + String(getTimer()-preTime) + " ms");                                                                                                                     

			assertEquals("Returns null if not inside an included view", null, result);
		}
		
		public function test_returns_root_container_view_bindings_one_item():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(1, 1);
			var expectedBinding:IContainerBinding = instance.includeContainer(searchTrees[0]);
            var expectedRootBindings:Vector.<IContainerBinding> = new <IContainerBinding>[expectedBinding];
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, instance.rootContainerBindings);
		}
		
		public function test_returns_root_container_view_bindings_many_items():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);     
			
			var firstExpectedBinding:IContainerBinding = instance.includeContainer(searchTrees[0]);
			
			instance.includeContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.includeContainer(searchTrees[1].children[3].children[2]);
			
			var secondExpectedBinding:IContainerBinding = instance.includeContainer(searchTrees[1]);          
			
			instance.includeContainer(searchTrees[1].children[3]);  
            
			var expectedRootBindings:Vector.<IContainerBinding> = new <IContainerBinding>[firstExpectedBinding, secondExpectedBinding];
			
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, instance.rootContainerBindings);
		}
		
		public function test_returns_root_container_view_bindings_many_items_after_removals():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);     
			
			var firstExpectedBinding:IContainerBinding = instance.includeContainer(searchTrees[0]);
			
			instance.includeContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.includeContainer(searchTrees[1].children[3].children[2]);
			instance.includeContainer(searchTrees[1]);
			
			var secondExpectedBinding:IContainerBinding = instance.includeContainer(searchTrees[1].children[3]);          
			
			instance.excludeContainer(searchTrees[1]);  
            
			var expectedRootBindings:Vector.<IContainerBinding> = new <IContainerBinding>[firstExpectedBinding, secondExpectedBinding];
			
			assertEqualsVectorsIgnoringOrder("Returns root container view bindings one item", expectedRootBindings, instance.rootContainerBindings);
		}   
				
		public function test_comparison_with_contains_and_brute_force():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 4);
			var searchItem:Sprite = searchTrees[1].children[3].children[2].children[3].children[3];
			
			var interestedContainers:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>
												[searchTrees[0], searchTrees[1], searchTrees[1].children[3], searchTrees[1].children[3].children[2].children[3]] 
			
			var preTime:Number = getTimer(); 
			var results:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			var iLength:uint = interestedContainers.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				if(interestedContainers[i].contains(searchItem))
				{
					results.push(interestedContainers[i]);
				}
			}
			trace("found parent vector " + String(getTimer()-preTime) + " ms");                                                                                                                     
			
			assertEquals("Comparison with contains and brute force -> finds item 0", searchTrees[1], results[0]);
			assertEquals("Comparison with contains and brute force -> finds item 1", searchTrees[1].children[3], results[1]);
			assertEquals("Comparison with contains and brute force -> finds item 2", searchTrees[1].children[3].children[2].children[3], results[2]);
		}

		public function test_worst_case_performance_10000_times():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(7, 4);
			instance.includeContainer(searchTrees[0]);
			instance.includeContainer(searchTrees[1]);          
			instance.includeContainer(searchTrees[1].children[3].children[2].children[3]);
			instance.includeContainer(searchTrees[1].children[3].children[2]);
			instance.includeContainer(searchTrees[1].children[3]);  
			instance.includeContainer(searchTrees[1].children[2].children[2]);  
			instance.includeContainer(searchTrees[1].children[2]);  
			instance.includeContainer(searchTrees[1].children[1].children[2]);  
			instance.includeContainer(searchTrees[1].children[1]);  
			instance.includeContainer(searchTrees[1].children[0].children[2]);  
			instance.includeContainer(searchTrees[1].children[0]);  
			
			var searchItem:Sprite = searchTrees[2].children[3].children[2].children[3].children[3].children[3].children[2];
                              
			var preTime:Number = getTimer();
			var result:IContainerBinding;
			
			var iLength:uint = 10000;
			for (var i:uint = 0; i < iLength; i++)
			{
				result = instance.findParentBindingFor(searchItem);
			}                                                                          
            trace("found parent 10000 times in " + String(getTimer()-preTime) + " ms");                                                                                                                     
			assertEquals("result is null", null, result);
		} 
		
		/*
		public function test_comparison_with_contains_and_brute_force_worst_case_10000_times():void {
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(7, 4);
			var searchItem:Sprite = searchTrees[2].children[3].children[2].children[3].children[3].children[3].children[2];
			
			var interestedContainers:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>
																			[	
																				searchTrees[0], 
																				searchTrees[1], 
																				searchTrees[1].children[3], 
																				searchTrees[1].children[3].children[2].children[3],
																				searchTrees[1].children[2].children[2],
																				searchTrees[1].children[2],  
																				searchTrees[1].children[1].children[2],
																				searchTrees[1].children[1],  
																				searchTrees[1].children[0].children[2],
																				searchTrees[1].children[0]  
																			]; 
			
			var preTime:Number = getTimer(); 
			var results:Vector.<DisplayObjectContainer>;
			var iLength:uint = interestedContainers.length;
			
			var jLength:uint = 10000;

			for (var j:int = 0; j < jLength; j++)
			{
				results = new Vector.<DisplayObjectContainer>();
				
				for (var i:uint = 0; i < iLength; i++)
				{
					if(interestedContainers[i].contains(searchItem))
					{
						results.push(interestedContainers[i]);
					}
				}
			} 
			
			trace("found parent vector 10000 times " + String(getTimer()-preTime) + " ms");                                                                                                                     
			assertEquals('no results', 0, results.length);
		}   */
		
		public function test_running_parent_loop_on_100_depth_single_branch():void 
		{
			var target:DisplayObject = new Sprite();
			var originalTarget:DisplayObject = target;
			var parent:DisplayObjectContainer;
			var iLength:uint = 100;
			for (var i:uint = 0; i < iLength; i++)
			{
				parent = new Sprite();
				parent.addChild(target);
				target = parent;
			}
			
			var preTime:Number = getTimer();
			
			var jLength:uint = 10000; 

			for (var j:int = 0; j < jLength; j++)
			{
				parent = originalTarget.parent;

				while(parent)
				{
					// do nothing
					parent = parent.parent;
				}
			}
            
			trace("found parent list for 100 depth, 10000 times in " + String(getTimer()-preTime) + " ms");
   		}

		public function test_running_parent_loop_on_30_depth_single_branch():void 
		{
			var target:DisplayObject = new Sprite();
			var originalTarget:DisplayObject = target;
			var parent:DisplayObjectContainer;
			var iLength:uint = 30;
			for (var i:uint = 0; i < iLength; i++)
			{
				parent = new Sprite();
				parent.addChild(target);
				target = parent;
			}
			
			var preTime:Number = getTimer();
			
			var jLength:uint = 10000; 

			for (var j:int = 0; j < jLength; j++)
			{
				parent = originalTarget.parent;

				while(parent)
				{
					// do nothing
					parent = parent.parent;
				}
			}
            
			trace("found parent list for 30 depth, 10000 times in " + String(getTimer()-preTime) + " ms");
   		}

		public function test_running_parent_loop_on_24_depth_single_branch():void 
		{
			var target:DisplayObject = new Sprite();
			var originalTarget:DisplayObject = target;
			var parent:DisplayObjectContainer;
			var iLength:uint = 24;
			for (var i:uint = 0; i < iLength; i++)
			{
				parent = new Sprite();
				parent.addChild(target);
				target = parent;
			}
			
			var preTime:Number = getTimer();
			
			var jLength:uint = 10000; 

			for (var j:int = 0; j < jLength; j++)
			{
				parent = originalTarget.parent;

				while(parent)
				{
					// do nothing
					parent = parent.parent;
				}
			}
            
			trace("found parent list for 24 depth, 10000 times in " + String(getTimer()-preTime) + " ms");
   		}

		public function test_running_parent_loop_on_15_depth_single_branch():void 
		{
			var target:DisplayObject = new Sprite();
			var originalTarget:DisplayObject = target;
			var parent:DisplayObjectContainer;
			var iLength:uint = 15;
			for (var i:uint = 0; i < iLength; i++)
			{
				parent = new Sprite();
				parent.addChild(target);
				target = parent;
			}
			
			var preTime:Number = getTimer();
			
			var jLength:uint = 10000; 

			for (var j:int = 0; j < jLength; j++)
			{
				parent = originalTarget.parent;

				while(parent)
				{
					// do nothing
					parent = parent.parent;
				}
			}
            
			trace("found parent list for 15 depth, 10000 times in " + String(getTimer()-preTime) + " ms");
   		} 
		
        /*
		public function test_running_contains_on_100_depth_single_branch():void 
		{
			var target:DisplayObject = new Sprite();
			var originalTarget:DisplayObject = target;
			var parent:DisplayObjectContainer;
			var iLength:uint = 100;
			for (var i:uint = 0; i < iLength; i++)
			{
				parent = new Sprite();
				parent.addChild(target);
				target = parent;
			}
			
			var lastParent:DisplayObjectContainer = parent;
			
			var preTime:Number = getTimer();
			
			var jLength:uint = 10000; 

			for (var j:int = 0; j < jLength; j++)
			{
				parent = originalTarget.parent;

				if(parent.contains(originalTarget))
				{
					// do nothing
				}
			}
            
			trace("found parent contains for 100 depth, 10000 times in " + String(getTimer()-preTime) + " ms");
   		}  

		public function test_finding_containers_in_order_on_15_depth_tree_double_branch_using_contains_5_containers():void
		{			
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(15, 2);
			
			var searchItem:Sprite = searchTrees[1].children[1].children[1].children[1].children[0].children[1].children[0];
			
			var childrenByContainer:Dictionary = new Dictionary();
			childrenByContainer[searchTrees[1]] = new <DisplayObjectContainer>[searchTrees[1].children[0], searchTrees[1].children[1]];
			childrenByContainer[searchTrees[1].children[0]] = new <DisplayObjectContainer>[searchTrees[1].children[0].children[1], searchTrees[1].children[0].children[0]];
			childrenByContainer[searchTrees[1].children[1]] = new <DisplayObjectContainer>[searchTrees[1].children[1].children[1], searchTrees[1].children[1].children[0]];
			childrenByContainer[searchTrees[1].children[1].children[1]] = new <DisplayObjectContainer>[searchTrees[1].children[1].children[0].children[1], searchTrees[1].children[1].children[1].children[1]]
			childrenByContainer[searchTrees[1].children[1].children[1].children[1]] = new <DisplayObjectContainer>[searchTrees[1].children[1].children[1].children[1].children[0], searchTrees[1].children[1].children[1].children[1].children[1]]
		    
			var preTime:Number = getTimer();
		    
			var kLength:uint = 10000;
			for(var k:uint = 0; k<kLength; k++)
			{
		    	var possibleContainer:DisplayObjectContainer = searchTrees[1];
			    var foundContainer:DisplayObjectContainer;
		    
				var containerList:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();  
			
				var containersToSearch:Vector.<DisplayObjectContainer>;
			
				var iLength:uint;
		                        
			    if(possibleContainer.contains(searchItem))
				{
				    foundContainer = possibleContainer;
					while(foundContainer)
					{
						containerList.push(foundContainer);
				
						if(childrenByContainer[foundContainer])
						{                          
							containersToSearch = childrenByContainer[possibleContainer];
							iLength = containersToSearch.length;
							for (var i:uint = 0; i < iLength; i++)
							{
								if(containersToSearch[i].contains(searchItem))
								{
									foundContainer = containersToSearch[i];
									i = iLength;
								}
							}                                              
							foundContainer = null;
						}
					}   
				} 
			}
			
			trace("found parent contains list for 15 depth, 5 containers, 10000 times in " + String(getTimer()-preTime) + " ms");
			trace(containerList);
		}
		
		public function test_finding_containers_in_order_on_15_depth_tree_double_branch_using_contains_4_containers():void
		{			
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(15, 2);
			
			var searchItem:Sprite = searchTrees[1].children[1].children[1].children[1].children[0].children[1].children[0];
			
			var childrenByContainer:Dictionary = new Dictionary();
			childrenByContainer[searchTrees[1]] = new <DisplayObjectContainer>[searchTrees[1].children[0], searchTrees[1].children[1]];
			childrenByContainer[searchTrees[1].children[0]] = new <DisplayObjectContainer>[searchTrees[1].children[0].children[1], searchTrees[1].children[0].children[0]];
			childrenByContainer[searchTrees[1].children[1]] = new <DisplayObjectContainer>[searchTrees[1].children[1].children[1], searchTrees[1].children[1].children[0]];
			childrenByContainer[searchTrees[1].children[1].children[1]] = new <DisplayObjectContainer>[searchTrees[1].children[1].children[0].children[1], searchTrees[1].children[1].children[1].children[1]]
		    
			var preTime:Number = getTimer();
		    
			var kLength:uint = 10000;
			for(var k:uint = 0; k<kLength; k++)
			{
		    	var possibleContainer:DisplayObjectContainer = searchTrees[1];
			    var foundContainer:DisplayObjectContainer;
		    
				var containerList:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();  
			
				var containersToSearch:Vector.<DisplayObjectContainer>;
			
				var iLength:uint;
		                        
			    if(possibleContainer.contains(searchItem))
				{
				    foundContainer = possibleContainer;
					while(foundContainer)
					{
						containerList.push(foundContainer);
				
						if(childrenByContainer[foundContainer])
						{                          
							containersToSearch = childrenByContainer[possibleContainer];
							iLength = containersToSearch.length;
							for (var i:uint = 0; i < iLength; i++)
							{
								if(containersToSearch[i].contains(searchItem))
								{
									foundContainer = containersToSearch[i];
									i = iLength;
								}
							}                                              
							foundContainer = null;
						}
					}   
				} 
			}
			
			trace("found parent contains list for 15 depth, 4 containers, 10000 times in " + String(getTimer()-preTime) + " ms");
			trace(containerList);
		}
		
		public function test_finding_containers_in_order_on_15_depth_tree_double_branch_using_contains_3_containers():void
		{			
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(15, 2);
			
			var searchItem:Sprite = searchTrees[1].children[1].children[1].children[1].children[1].children[1].children[1];
			
			var childrenByContainer:Dictionary = new Dictionary();
			childrenByContainer[searchTrees[1]] = new <DisplayObjectContainer>[searchTrees[1].children[0], searchTrees[1].children[1]];
			childrenByContainer[searchTrees[1].children[0]] = new <DisplayObjectContainer>[searchTrees[1].children[0].children[1], searchTrees[1].children[0].children[0]];
			childrenByContainer[searchTrees[1].children[1]] = new <DisplayObjectContainer>[searchTrees[1].children[1].children[1], searchTrees[1].children[1].children[0]];
		    
			
			var containerList:Vector.<DisplayObjectContainer>;
			var containersToSearch:Vector.<DisplayObjectContainer>;
		    var foundContainer:DisplayObjectContainer;
			var possibleContainer:DisplayObjectContainer
		    var iLength:uint;
			var kLength:uint = 10000;

			var preTime:Number = getTimer();   

			for(var k:uint = 0; k<kLength; k++)
			{
		    	possibleContainer = searchTrees[1];
		    
				containerList = new Vector.<DisplayObjectContainer>();  
			
			    if(possibleContainer.contains(searchItem))
				{
				    foundContainer = possibleContainer;
					containerList.push(foundContainer);
                    
					while(foundContainer)
					{
						if(childrenByContainer[foundContainer])
						{                          
							containersToSearch = childrenByContainer[possibleContainer];
							iLength = containersToSearch.length;
							for (var i:uint = 0; i < iLength; i++)
							{
								if(containersToSearch[i].contains(searchItem))
								{
									foundContainer = containersToSearch[i];
									containerList.push(foundContainer);
									i = iLength;
								}
							}
							foundContainer = null;                                              
						} 
					}
				} 
			}
			
			trace("found parent contains list for 15 depth, 3 containers, 10000 times in " + String(getTimer()-preTime) + " ms");
			trace(containerList);
		}  */
		
		public function test_finding_containers_in_order_on_5_depth_tree_triple_branch_using_6_tree_nodes():void
		{			
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 3);
			
			var searchItem:Sprite = searchTrees[1].children[1].children[2].children[1].children[0];
			
			var treeNode_A2:TreeNode = new TreeNode(searchTrees[1]);
			var treeNode_A2_1:TreeNode = new TreeNode(searchTrees[1].children[0]);
			var treeNode_A2_2:TreeNode = new TreeNode(searchTrees[1].children[1]);
			var treeNode_A2_2_1:TreeNode = new TreeNode(searchTrees[1].children[1].children[0]);
			var treeNode_A2_2_2:TreeNode = new TreeNode(searchTrees[1].children[1].children[1]);
			var treeNode_A2_2_3:TreeNode = new TreeNode(searchTrees[1].children[1].children[2]);

			treeNode_A2_2_2.sibling = treeNode_A2_2_3;
			treeNode_A2_2_1.sibling = treeNode_A2_2_2;
			treeNode_A2_2.firstChild = treeNode_A2_2_1;
			treeNode_A2_1.sibling = treeNode_A2_2;
			treeNode_A2.firstChild = treeNode_A2_1;
		    
			trace(treeNode_A2.getAncestory(searchItem));
			assertEquals("finds 3 nodes", 3, treeNode_A2.getAncestory(searchItem).length);
		    
			var preTime:Number = getTimer();
		    var ancestory:Vector.<TreeNode>;
			
			var kLength:uint = 10000;
			for(var k:uint = 0; k<kLength; k++)
			{
		    	ancestory = treeNode_A2.getAncestory(searchItem);
			}
			
			trace("found parent contains list for 5 depth triple branch using 6 tree nodes, 10000 times in " + String(getTimer()-preTime) + " ms");
		} 
		
		public function test_finding_deepest_child_on_5_depth_tree_triple_branch_using_6_tree_nodes():void
		{			
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 3);
			
			var searchItem:Sprite = searchTrees[1].children[1].children[2].children[1].children[0];
			
			var treeNode_A2:TreeNode = new TreeNode(searchTrees[1]);
			var treeNode_A2_1:TreeNode = new TreeNode(searchTrees[1].children[0]);
			var treeNode_A2_2:TreeNode = new TreeNode(searchTrees[1].children[1]);
			var treeNode_A2_2_1:TreeNode = new TreeNode(searchTrees[1].children[1].children[0]);
			var treeNode_A2_2_2:TreeNode = new TreeNode(searchTrees[1].children[1].children[1]);
			var treeNode_A2_2_3:TreeNode = new TreeNode(searchTrees[1].children[1].children[2]);

			treeNode_A2_2_2.sibling = treeNode_A2_2_3;
			treeNode_A2_2_1.sibling = treeNode_A2_2_2;
			treeNode_A2_2.firstChild = treeNode_A2_2_1;
			treeNode_A2_1.sibling = treeNode_A2_2;
			treeNode_A2.firstChild = treeNode_A2_1;
		    
			assertEquals("finds deepest child", treeNode_A2_2_3, treeNode_A2.getDeepestChildContaining(searchItem));
		    var deepestChild:TreeNode;
		 
			var preTime:Number = getTimer();
						
			var kLength:uint = 10000;
			for(var k:uint = 0; k<kLength; k++)
			{
		    	deepestChild = treeNode_A2.getDeepestChildContaining(searchItem);
			}
			
			trace("found deepest child for 5 depth triple branch using 6 tree nodes, 10000 times in " + String(getTimer()-preTime) + " ms");
		}
		
		public function test_finding_deepest_child_on_5_depth_tree_triple_branch_using_4_tree_nodes():void
		{			
			var searchTrees:Vector.<TreeSpriteSupport> = createTrees(5, 3);
			
			var searchItem:Sprite = searchTrees[1].children[0].children[1].children[1].children[0];
			
			var treeNode_A2:TreeNode = new TreeNode(searchTrees[1]);
			var treeNode_A2_1:TreeNode = new TreeNode(searchTrees[1].children[0]);
			var treeNode_A2_1_1:TreeNode = new TreeNode(searchTrees[1].children[0].children[0]);
			var treeNode_A2_1_2:TreeNode = new TreeNode(searchTrees[1].children[0].children[1]);

			treeNode_A2_1_1.sibling = treeNode_A2_1_2;
			treeNode_A2_1.firstChild = treeNode_A2_1_1;
			treeNode_A2.firstChild = treeNode_A2_1;
		    
			assertEquals("finds deepest child", treeNode_A2_1_2, treeNode_A2.getDeepestChildContaining(searchItem));
		    var deepestChild:TreeNode;
		 
			var preTime:Number = getTimer();
						
			var kLength:uint = 10000;
			for(var k:uint = 0; k<kLength; k++)
			{
		    	deepestChild = treeNode_A2.getDeepestChildContaining(searchItem);
			}
			
			trace("found deepest child for 5 depth triple branch using 4 tree nodes, 10000 times in " + String(getTimer()-preTime) + " ms");
		}
				
		
		protected function createTrees(tree_depth:uint, tree_width:uint):Vector.<TreeSpriteSupport>
		{
			var preTime:Number = getTimer();
			var trees:Vector.<TreeSpriteSupport> = new Vector.<TreeSpriteSupport>();
			var iLength:uint = tree_width;
			for (var i:uint = 0; i < iLength; i++)
			{                        
				var nextTree:TreeSpriteSupport = new TreeSpriteSupport(tree_depth, tree_width);
				trees.push(nextTree);
			}                      
			trace("created trees in: " + String(getTimer()-preTime) + "ms");                                                                                                                     
			return trees;
		}
	}
}