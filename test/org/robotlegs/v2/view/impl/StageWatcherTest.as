//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.display.Sprite;
	import mx.containers.Canvas;
	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.isTrue;
	import org.robotlegs.v2.view.api.IViewWatcher;

	public class StageWatcherTest
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var container:Canvas;

		protected var watcher:IViewWatcher;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[Test]
		public function addHandler_results_in_handler_running_when_view_lands_in_container():void
		{
			var view:Sprite = new Sprite();
			//watcher.addHandler(handler, container);
			container.addChild(view);
			//assertThat(wasHandled, isTrue());
		}

		[Before(ui)]
		public function setUp():void
		{
			container = new Canvas();
			watcher = new StageWatcher();

			UIImpersonator.addChild(container);
		}

		[After]
		public function tearDown():void
		{
			watcher = null;
		}
	}
}
