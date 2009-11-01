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
	import org.robotlegs.mvcs.MediatorMapTests;
	import org.robotlegs.mvcs.support.TestContextView;
	
	public class MediatorMapTests extends org.robotlegs.mvcs.MediatorMapTests
	{
		protected static const XML_CONFIG : XML = 
			<types>
				<type name='org.robotlegs.mvcs.support::CustomEventCommand'>
					<field name='event'/>
					<field name='testSuite'/>
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