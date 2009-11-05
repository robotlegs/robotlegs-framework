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

package org.robotlegs.core
{
	import flash.display.DisplayObjectContainer;
	
	public interface IViewMap
	{
		/**
		 * Map a view component Class for injection
		 *
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 */
		function mapView(viewClassOrName:*):void;
		
		/**
		 * The <code>IViewMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @return view The <code>DisplayObjectContainer</code> to use as scope for this <code>IViewMap</code>
		 */
		function get contextView():DisplayObjectContainer;
		
		/**
		 * The <code>IViewMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @param value The <code>DisplayObjectContainer</code> to use as scope for this <code>IViewMap</code>
		 */
		function set contextView(value:DisplayObjectContainer):void;
		
		/**
		 * The <code>IViewMap</code>'s enabled status
		 *
		 * @return Whether the <code>IViewMap</code> is enabled
		 */
		function get enabled():Boolean;
		
		/**
		 * The <code>IViewMap</code>'s enabled status
		 *
		 * @param value Whether the <code>IViewMap</code> should be enabled
		 */
		function set enabled(value:Boolean):void;
	
	}
}