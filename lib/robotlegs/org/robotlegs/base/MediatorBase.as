/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	
	import org.robotlegs.core.IMediator;
	
	/**
	 * An abstract <code>IMediator</code> implementation
	 */
	public class MediatorBase implements IMediator
	{
		/**
		 * Flex framework work-around part #1
		 */
		protected static var UIComponentClass:Class;
		
		/**
		 * Flex framework work-around part #2
		 */
		protected static const flexAvailable:Boolean = checkFlex();
		
		/**
		 * Internal
		 *
		 * <p>This Mediator's View Component - used by the RobotLegs MVCS framework internally.
		 * You should declare a dependency on a concrete view component in your
		 * implementation instead of working with this property</p>
		 */
		protected var viewComponent:Object;
		
		/**
		 * Internal
		 *
		 * <p>In the case of deffered instantiation, onRemove might get called before
		 * onCreationComplete has fired. This here Bool helps us track that scenario.</p>
		 */
		protected var removed:Boolean;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		/**
		 * Creates a new <code>Mediator</code> object
		 */
		public function MediatorBase()
		{
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function preRegister():void
		{
			removed = false;
			
			if (flexAvailable && (viewComponent is UIComponentClass) && !viewComponent['initialized'])
			{
				IEventDispatcher(viewComponent).addEventListener('creationComplete', onCreationComplete, false, 0, true);
			}
			else
			{
				onRegister();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRegister():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function preRemove():void
		{
			removed = true;
			onRemove();
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRemove():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getViewComponent():Object
		{
			return viewComponent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setViewComponent(viewComponent:Object):void
		{
			this.viewComponent = viewComponent;
		}
		
		//---------------------------------------------------------------------
		//  Internal
		//---------------------------------------------------------------------
		
		/**
		 * Flex framework work-around part #3
		 *
		 * <p>Checks for availability of the Flex framework by trying to get the class for UIComponent.</p>
		 */
		protected static function checkFlex():Boolean
		{
			try
			{
				UIComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
			}
			catch (error:Error)
			{
				// do nothing
			}
			return UIComponentClass != null;
		}
		
		/**
		 * Flex framework work-around part #4
		 *
		 * <p><code>FlexEvent.CREATION_COMPLETE</code> handler for this Mediator's View Component</p>
		 *
		 * @param e The Flex <code>FlexEvent</code> event
		 */
		protected function onCreationComplete(e:Event):void
		{
			IEventDispatcher(e.target).removeEventListener('creationComplete', onCreationComplete);
			
			if (!removed)
				onRegister();
		}
	
	}
}
