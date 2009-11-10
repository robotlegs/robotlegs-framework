/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.robotlegs.base
{
	import flash.display.DisplayObjectContainer;
	
	import org.flexunit.Assert;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.support.CanvasComponent;
	import org.robotlegs.base.support.TestContextCanvasView;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	
	public class ViewMapTests
	{
		protected static const INJECTION_NAME:String = 'injectionName';
		protected static const INJECTION_STRING:String = 'injectionString';
		
		protected var contextView:DisplayObjectContainer;
		protected var testView:CanvasComponent;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var viewMap:IViewMap;
		
		[Before(ui)]
		public function runBeforeEachTest():void
		{
			contextView = new TestContextCanvasView();
			testView = new CanvasComponent();
			injector = new SwiftSuspendersInjector();
			reflector = new SwiftSuspendersReflector();
			viewMap = new ViewMap(contextView, injector, reflector);
			
			injector.mapValue(String, INJECTION_STRING, INJECTION_NAME);
			
			UIImpersonator.addChild(contextView);
		}
		
		[After(ui)]
		public function runAfterEachTest():void
		{
			UIImpersonator.removeAllChildren();
		}
		
		[Test]
		public function mapClass():void
		{
			viewMap.mapClass(CanvasComponent);
			var mapped:Boolean = viewMap.hasClass(CanvasComponent);
			Assert.assertTrue("Class should be mapped", mapped);
		}
		
		[Test]
		public function unmapClass():void
		{
			viewMap.mapClass(CanvasComponent);
			viewMap.unmapClass(CanvasComponent);
			var mapped:Boolean = viewMap.hasClass(CanvasComponent);
			Assert.assertFalse("Class should NOT be mapped", mapped);
		}
		
		[Test]
		public function mapClassAndAddToDisplay():void
		{
			viewMap.mapClass(CanvasComponent);
			contextView.addChild(testView);
			Assert.assertEquals("Injection points should be satisfied", INJECTION_STRING, testView.injectionPoint);
		}
		
		[Test]
		public function unmapClassAndAddToDisplay():void
		{
			viewMap.mapClass(CanvasComponent);
			viewMap.unmapClass(CanvasComponent);
			contextView.addChild(testView);
			Assert.assertNull("Injection points should NOT be satisfied after unmapping", testView.injectionPoint);
		}
		
		[Test]
		public function mapClassAndAddToDisplayTwice():void
		{
			viewMap.mapClass(CanvasComponent);
			contextView.addChild(testView);
			testView.injectionPoint = null;
			contextView.removeChild(testView);
			contextView.addChild(testView);
			Assert.assertNull("View should NOT be injected into twice", testView.injectionPoint);
		}
	
	}
}
