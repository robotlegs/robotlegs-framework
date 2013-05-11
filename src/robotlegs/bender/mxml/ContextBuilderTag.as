//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.mxml
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	import mx.core.IMXMLObject;
	import org.swiftsuspenders.reflection.DescribeTypeReflector;
	import org.swiftsuspenders.reflection.Reflector;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.Context;

	[DefaultProperty("configs")]
	/**
	 * Apache Flex context builder tag
	 */
	public class ContextBuilderTag implements IMXMLObject
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _configs:Array = [];

		/**
		 * Configs, extensions or bundles
		 */
		public function get configs():Array
		{
			return _configs;
		}

		/**
		 * Configs, extensions or bundles
		 */
		public function set configs(value:Array):void
		{
			_configs = value;
		}

		private var _contextView:DisplayObjectContainer;

		/**
		 * The context view
		 * @param value
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}

		private const _context:IContext = new Context();

		/**
		 * The context associated with this builder
		 */
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

		/**
		 * @inheritDoc
		 */
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
					? _context.install(config)
					: _context.configure(config);
			}

			_contextView && _context.configure(new ContextView(_contextView));
			_configs.length = 0;
		}

		private function isExtension(object:Object):Boolean
		{
			return (object is IExtension) || (object is Class && _reflector.typeImplements(object as Class, IExtension));
		}
	}
}
