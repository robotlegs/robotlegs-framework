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
	import flash.events.EventDispatcher;
	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.mvcs.CommandMapTests;
	import org.robotlegs.mvcs.support.ICommandTest;
	
	public class CommandMapTests extends org.robotlegs.mvcs.CommandMapTests
	{
		protected static const XML_CONFIG : XML = 
			<types>
				<type name='org.robotlegs.mvcs.support::EventCommand'>
					<field name='testSuite'/>
				</type>
			</types>;
		
		[Before]
		override public function runBeforeEachTest():void
		{
			eventDispatcher = new EventDispatcher();
			injector = new SwiftSuspendersInjector(XML_CONFIG);
			reflector = new SwiftSuspendersReflector();
			commandMap = new CommandMap(eventDispatcher, injector, reflector);
			injector.mapValue(ICommandTest, this);
		}
	}
}
