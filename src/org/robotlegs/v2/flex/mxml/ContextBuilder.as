//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.flex.mxml
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	import mx.core.IMXMLObject;
	import org.robotlegs.v2.context.api.IContextBuilderBundle;
	import org.robotlegs.v2.context.impl.ContextBuilder;

	[DefaultProperty("configs")]
	public class ContextBuilder extends org.robotlegs.v2.context.impl.ContextBuilder implements IMXMLObject
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _configs:Vector.<IContextBuilderBundle> = new Vector.<IContextBuilderBundle>;

		public function get configs():Vector.<IContextBuilderBundle>
		{
			return _configs;
		}

		public function set configs(value:Vector.<IContextBuilderBundle>):void
		{
			_configs = value;
		}

		protected var _contextView:DisplayObjectContainer;

		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _documentView:DisplayObjectContainer;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialized(document:Object, id:String):void
		{
			_documentView = document as DisplayObjectContainer;
			// if the contextView is bound it will only be set a frame later
			setTimeout(configureBuilder, 1);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function configureBuilder():void
		{
			if (!context.contextView)
			{
				withContextView(_contextView || _documentView);
			}

			configs.forEach(function(config:IContextBuilderBundle, ... rest):void
			{
				installBundle(config);
			}, this);

			configs = null;

			build();
		}
	}
}
