/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs.xmlconfig
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.base.MediatorMapTests;
	import org.robotlegs.mvcs.support.TestContextView;
	
	public class XmlMediatorMapTests extends org.robotlegs.base.MediatorMapTests
	{
		protected static const XML_CONFIG : XML =
			<types>
				<type name='org.robotlegs.mvcs.support::CustomEventCommand'>
					<field name='event'/>
					<field name='testSuite'/>
				</type>
				<type name='org.robotlegs.mvcs.support::ViewMediator'>
					<field name='view'/>
				</type>
				<type name='org.robotlegs.mvcs.support::ViewMediatorAdvanced'>
					<field name='view'/>
					<field name='viewAdvanced'/>
				</type>
			</types>;
		
		[Before(ui)]
		override public function runBeforeEachTest():void
		{
			contextView = new TestContextView();
			eventDispatcher = new EventDispatcher();
			injector = new SwiftSuspendersInjector(XML_CONFIG);
			reflector = new SwiftSuspendersReflector();
			mediatorMap = new MediatorMap(contextView, injector, reflector);
			
			injector.mapValue(DisplayObjectContainer, contextView);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(IMediatorMap, mediatorMap);
			
			UIImpersonator.addChild(contextView);
		}
	}
}
