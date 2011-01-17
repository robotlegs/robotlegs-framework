/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs.xmlconfig
{
	import flash.events.EventDispatcher;
	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.CommandMapWithEventClassTests;
	import org.robotlegs.mvcs.support.ICommandTest;
	
	public class XmlCommandMapWithEventClassTests extends org.robotlegs.base.CommandMapWithEventClassTests
	{
		protected static const XML_CONFIG : XML =
			<types>
				<type name='org.robotlegs.mvcs.support::CustomEventCommand'>
					<field name='event'/>
					<field name='testSuite'/>
				</type>
				<type name='org.robotlegs.mvcs.support::BlendCommand'>
					<field name='event'/>
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
