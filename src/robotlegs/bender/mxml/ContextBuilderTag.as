//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.mxml
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	import mx.core.IMXMLObject;
	import org.swiftsuspenders.DescribeTypeReflector;
	import org.swiftsuspenders.Reflector;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;
	import robotlegs.bender.framework.context.impl.Context;

	[DefaultProperty("configs")]
	public class ContextBuilderTag implements IMXMLObject
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _configs:Array = [];

		public function get configs():Array
		{
			return _configs;
		}

		public function set configs(value:Array):void
		{
			_configs = value;
		}

		private var _contextView:DisplayObjectContainer;

		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}

		private const _context:IContext = new Context();

		public function get context():IContext
		{
			return _context;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _reflector:Reflector = new DescribeTypeReflector();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialized(document:Object, id:String):void
		{
			_contextView ||= document as DisplayObjectContainer;
			// if the contextView is bound it will only be set a frame later
			setTimeout(configureBuilder, 1);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function configureBuilder():void
		{
			for each (var config:Object in _configs)
			{
				isExtension(config)
					? _context.extend(config)
					: _context.configure(config);
			}

			_contextView && _context.configure(_contextView);
			_configs.length = 0;
		}

		private function isExtension(object:Object):Boolean
		{
			return (object is IContextExtension) || (object is Class && _reflector.typeImplements(object as Class, IContextExtension));
		}
	}
}
