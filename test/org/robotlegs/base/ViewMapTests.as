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
		
		[Test]
		public function mapInterface():void
		{
			viewMap.mapClass(ITestComponent);
			var mapped:Boolean = viewMap.hasClass(ITestComponent);
			Assert.assertTrue("Inteface should be mapped", mapped);			
		}

		[Test]
		public function unmapInterface():void
		{
			viewMap.mapClass(ITestComponent);
			viewMap.unmapClass(ITestComponent);
			var mapped:Boolean = viewMap.hasClass(ITestComponent);
			Assert.assertFalse("Class should NOT be mapped", mapped);
		}
		
		[Test]
		public function mappedInterfaceIsInjected():void
		{
			viewMap.mapClass(ITestComponent);
			contextView.addChild(testView);
			Assert.assertEquals("Injection points should be satisfied", INJECTION_STRING, testView.injectionPoint);
		}
		
		[Test]
		public function unmappedInterfaceShouldNotBeInjected():void
		{
			viewMap.mapClass(ITestComponent);
			viewMap.unmapClass(ITestComponent);
			contextView.addChild(testView);
			Assert.assertNull("Injection points should NOT be satisfied after unmapping", testView.injectionPoint);
		}

		[Test]
		public function mappedInterfaceNotInjectedTwiceWhenRemovedAndAdded():void
		{
			viewMap.mapClass(ITestComponent);
			contextView.addChild(testView);
			testView.injectionPoint = null;
			contextView.removeChild(testView);
			contextView.addChild(testView);
			Assert.assertNull("View should NOT be injected into twice", testView.injectionPoint);
		}
	}
}
