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
	import org.robotlegs.base.CommandMapTests;
	import org.robotlegs.mvcs.support.ICommandTest;
	
	public class XmlCommandMapTests extends org.robotlegs.base.CommandMapTests
	{
		protected static const XML_CONFIG : XML =
			<types>
				<type name='org.robotlegs.mvcs.support::EventCommand'>
					<field name='testSuite'/>
				</type>
				<type name='org.robotlegs.base.support::ManualCommand'>
					<field name='testSuite'/>
				</type>
				<type name='org.robotlegs.mvcs.support::AbstractEventCommand'>
					<field name='testSuite'/>
					<field name='event'/>
					<field name='customEvent'/>
				</type>
				<type name='org.robotlegs.mvcs.support::AbstractEventNamedCommand'>
					<field name='testSuite'/>
					<field name='event'/>
					<field name='customEvent' injectionname='custom'/>
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
