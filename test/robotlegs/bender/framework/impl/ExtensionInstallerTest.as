//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IContextExtension;
	import robotlegs.bender.framework.impl.contextSupport.CallbackExtension;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.ExtensionInstaller;

	public class ExtensionInstallerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var extensionManager:ExtensionInstaller;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			extensionManager = new ExtensionInstaller(context);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function extension_instance_is_installed():void
		{
			var callCount:int;
			extensionManager.install(new CallbackExtension(function():void {
				callCount++;
			}));
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function extension_class_is_installed():void
		{
			var callCount:int;
			CallbackExtension.staticCallback = function():void {
				callCount++;
			};
			extensionManager.install(CallbackExtension);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function extension_is_installed_once_for_same_instance():void
		{
			var callCount:int;
			const callback:Function = function():void {
				callCount++;
			};
			const extension:IContextExtension = new CallbackExtension(callback);
			extensionManager.install(extension);
			extensionManager.install(extension);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function extension_is_installed_once_for_same_class():void
		{
			var callCount:int;
			const callback:Function = function():void {
				callCount++;
			}
			extensionManager.install(new CallbackExtension(callback));
			extensionManager.install(new CallbackExtension(callback));
			assertThat(callCount, equalTo(1));
		}
	}
}
