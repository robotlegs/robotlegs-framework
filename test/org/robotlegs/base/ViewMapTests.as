/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	import flash.display.DisplayObjectContainer;
	
	import org.flexunit.Assert;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.support.CanvasComponent;
	import org.robotlegs.base.support.ITestComponent;
	import org.robotlegs.base.support.TestContextCanvasView;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	
	public class ViewMapTests
	{
		protected static const INJECTION_NAME:String = 'injectionName';
		protected static const INJECTION_STRING:String = 'injectionString';
		
		protected var contextView:TestContextCanvasView;
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
			viewMap = new ViewMap(contextView, injector);
			
			injector.mapValue(String, INJECTION_STRING, INJECTION_NAME);
			
			UIImpersonator.addChild(contextView);
		}
		
		[After(ui)]
		public function runAfterEachTest():void
		{
			UIImpersonator.removeAllChildren();
		}
		
		[Test]
		public function mapType():void
		{
			viewMap.mapType(CanvasComponent);
			var mapped:Boolean = viewMap.hasType(CanvasComponent);
			Assert.assertTrue("Class should be mapped", mapped);
		}
		
		[Test]
		public function unmapType():void
		{
			viewMap.mapType(CanvasComponent);
			viewMap.unmapType(CanvasComponent);
			var mapped:Boolean = viewMap.hasType(CanvasComponent);
			Assert.assertFalse("Class should NOT be mapped", mapped);
		}
		
		[Test]
		public function mapTypeAndAddToDisplay():void
		{
			viewMap.mapType(CanvasComponent);
			contextView.addChild(testView);
			Assert.assertEquals("Injection points should be satisfied", INJECTION_STRING, testView.injectionPoint);
		}
		
		[Test]
		public function unmapTypeAndAddToDisplay():void
		{
			viewMap.mapType(CanvasComponent);
			viewMap.unmapType(CanvasComponent);
			contextView.addChild(testView);
			Assert.assertNull("Injection points should NOT be satisfied after unmapping", testView.injectionPoint);
		}
		
		[Test]
		public function mapTypeAndAddToDisplayTwice():void
		{
			viewMap.mapType(CanvasComponent);
			contextView.addChild(testView);
			testView.injectionPoint = null;
			contextView.removeChild(testView);
			contextView.addChild(testView);
			Assert.assertNull("View should NOT be injected into twice", testView.injectionPoint);
		}
		
		[Test]
		public function mapTypeOfContextViewShouldInjectIntoIt():void
		{
			viewMap.mapType(TestContextCanvasView);
			Assert.assertEquals("Injection points in contextView should be satisfied", INJECTION_STRING, contextView.injectionPoint);
		}
		
		[Test]
		public function mapTypeOfContextViewTwiceShouldInjectOnlyOnce():void
		{
			viewMap.mapType(TestContextCanvasView);
			contextView.injectionPoint = null;
			viewMap.mapType(TestContextCanvasView);
			Assert.assertNull("contextView should NOT be injected into twice", testView.injectionPoint);
		}
		
		[Test]
		public function mapPackage():void
		{
			viewMap.mapPackage('org.robotlegs');
			var mapped:Boolean = viewMap.hasPackage('org.robotlegs');
			Assert.assertTrue("Package should be mapped", mapped);
		}

		[Test]
		public function unmapPackage():void
		{
			viewMap.mapPackage('org.robotlegs');
			viewMap.unmapPackage('org.robotlegs');
			var mapped:Boolean = viewMap.hasPackage('org.robotlegs');
			Assert.assertFalse("Package should NOT be mapped", mapped);
		}
		
		[Test]
		public function mappedPackageIsInjected():void
		{
			viewMap.mapPackage('org.robotlegs');
			contextView.addChild(testView);
			Assert.assertEquals("Injection points should be satisfied", INJECTION_STRING, testView.injectionPoint);
		}
		
		[Test]
		public function mappedAbsolutePackageIsInjected():void
		{
			viewMap.mapPackage('org.robotlegs.base.support');
			contextView.addChild(testView);
			Assert.assertEquals("Injection points should be satisfied", INJECTION_STRING, testView.injectionPoint);
		}
		
		[Test]
		public function unmappedPackageShouldNotBeInjected():void
		{
			viewMap.mapPackage('org.robotlegs');
			viewMap.unmapPackage('org.robotlegs');
			contextView.addChild(testView);
			Assert.assertNull("Injection points should NOT be satisfied after unmapping", testView.injectionPoint);
		}

		[Test]
		public function mappedPackageNotInjectedTwiceWhenRemovedAndAdded():void
		{
			viewMap.mapPackage('org.robotlegs');
			contextView.addChild(testView);
			testView.injectionPoint = null;
			contextView.removeChild(testView);
			contextView.addChild(testView);
			Assert.assertNull("View should NOT be injected into twice", testView.injectionPoint);
		}
		
		[Test]
		public function mapInterface():void
		{
			viewMap.mapType(ITestComponent);
			var mapped:Boolean = viewMap.hasType(ITestComponent);
			Assert.assertTrue("Inteface should be mapped", mapped);
		}
		
		[Test]
		public function unmapInterface():void
		{
			viewMap.mapType(ITestComponent);
			viewMap.unmapType(ITestComponent);
			var mapped:Boolean = viewMap.hasType(ITestComponent);
			Assert.assertFalse("Class should NOT be mapped", mapped);
		}
		
		[Test]
		public function mappedInterfaceIsInjected():void
		{
			viewMap.mapType(ITestComponent);
			contextView.addChild(testView);
			Assert.assertEquals("Injection points should be satisfied", INJECTION_STRING, testView.injectionPoint);
		}
		
		[Test]
		public function unmappedInterfaceShouldNotBeInjected():void
		{
			viewMap.mapType(ITestComponent);
			viewMap.unmapType(ITestComponent);
			contextView.addChild(testView);
			Assert.assertNull("Injection points should NOT be satisfied after unmapping", testView.injectionPoint);
		}
		
		[Test]
		public function mappedInterfaceNotInjectedTwiceWhenRemovedAndAdded():void
		{
			viewMap.mapType(ITestComponent);
			contextView.addChild(testView);
			testView.injectionPoint = null;
			contextView.removeChild(testView);
			contextView.addChild(testView);
			Assert.assertNull("View should NOT be injected into twice", testView.injectionPoint);
		}
	}
}
