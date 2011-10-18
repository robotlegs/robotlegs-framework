//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isTrue;
	import org.robotlegs.v2.view.api.IViewWatcher;

	public class StageWatcher_OptimisationTests
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var container:DisplayObjectContainer;

		protected var group:UIComponent;

		protected var watcher:IViewWatcher;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[Test]
		public function dummy():void
		{
			assertThat(true, isTrue());
		}

		[Before(ui)]
		public function setUp():void
		{
			group = new UIComponent()
			container = new Sprite();
			watcher = new StageWatcher();

			group.addChild(container)
			UIImpersonator.addChild(group);
		}

		[After]
		public function tearDown():void
		{
			watcher = null;
			UIImpersonator.removeAllChildren();
		}
	}
}
