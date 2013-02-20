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
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.contextSupport.CallbackExtension;

	public class ExtensionInstallerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var installer:ExtensionInstaller;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			installer = new ExtensionInstaller(new Context());
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function extension_instance_is_installed():void
		{
			var callCount:int = 0;
			installer.install(new CallbackExtension(function():void {
				callCount++;
			}));
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function extension_class_is_installed():void
		{
			var callCount:int = 0;
			CallbackExtension.staticCallback = function():void {
				callCount++;
			};
			installer.install(CallbackExtension);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function extension_is_installed_once_for_same_instance():void
		{
			var callCount:int = 0;
			const callback:Function = function():void {
				callCount++;
			};
			const extension:IExtension = new CallbackExtension(callback);
			installer.install(extension);
			installer.install(extension);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function extension_is_installed_once_for_same_class():void
		{
			var callCount:int = 0;
			const callback:Function = function():void {
				callCount++;
			};
			installer.install(new CallbackExtension(callback));
			installer.install(new CallbackExtension(callback));
			assertThat(callCount, equalTo(1));
		}
	}
}
