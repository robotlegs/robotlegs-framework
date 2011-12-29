//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.api
{
	import flash.events.Event;

	public class ContextBuilderEvent extends Event
	{

		public static const CONTEXT_BUILD_COMPLETE:String = 'contextBuildComplete';

		private var _builder:IContextBuilder;

		public function get builder():IContextBuilder
		{
			return _builder;
		}

		private var _context:IContext;

		public function get context():IContext
		{
			return _context;
		}

		public function ContextBuilderEvent(type:String, builder:IContextBuilder, context:IContext)
		{
			super(type);
			_builder = builder;
			_context = context;
		}

		override public function clone():Event
		{
			return new ContextBuilderEvent(type, builder, context);
		}
	}
}
