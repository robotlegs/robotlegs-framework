//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import mx.core.UIComponent;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;

	public class StageCrawlerTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var binding:ContainerBinding;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var container:UIComponent;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			container = new UIComponent();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function scan_finds_container_itself():void
		{
			new StageCrawler(binding).scan(container);
			assertThat(binding, received().method('handleView').args(container, UIComponent).once());
		}

		[Test]
		public function scan_finds_direct_child():void
		{
			const view:UIComponent = new UIComponent();
			container.addChild(view);
			new StageCrawler(binding).scan(container);
			assertThat(binding, received().method('handleView').args(view, UIComponent).once());
		}

		[Test]
		public function scan_finds_all_direct_children():void
		{
			container.addChild(new UIComponent());
			container.addChild(new UIComponent());
			new StageCrawler(binding).scan(container);
			assertThat(binding, received().method('handleView').args(instanceOf(UIComponent), UIComponent).thrice());
		}

		[Test]
		public function scan_finds_nested_children():void
		{
			const intermediary:UIComponent = new UIComponent();
			const child1:UIComponent = new UIComponent();
			const child2:UIComponent = new UIComponent();
			intermediary.addChild(child1);
			intermediary.addChild(child2);
			container.addChild(intermediary);
			new StageCrawler(binding).scan(container);
			assertThat(binding, received().method('handleView').args(child1, UIComponent).once());
			assertThat(binding, received().method('handleView').args(child2, UIComponent).once());
		}
	}
}

