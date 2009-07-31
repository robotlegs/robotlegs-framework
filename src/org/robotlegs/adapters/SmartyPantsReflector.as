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

package org.robotlegs.adapters
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import net.expantra.smartypants.utils.Reflection;
	
	import org.robotlegs.core.IReflector;
	
	/**
	 * An adapter for SmartyPants-IOC
	 * See: http://code.google.com/p/smartypants-ioc/
	 */
	public class SmartyPantsReflector implements IReflector
	{
		/**
		 * Creates a new <code>SmartyPantsReflector</code> object
		 */
		public function SmartyPantsReflector()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function classExtendsOrImplements(classOrClassName:Object, superclass:Class, application:ApplicationDomain = null):Boolean
		{
			return Reflection.classExtendsOrImplements(classOrClassName, superclass);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(value)));
		}
		
		/**
		 * @inheritDoc
		 */
		public function getFQCN(value:*, replaceColons:Boolean = false):String
		{
			var fqcn:String;
			if (value is String)
			{
				fqcn = value;
			}
			else
			{
				fqcn = getQualifiedClassName(value);
			}
			if (replaceColons)
			{
				fqcn = fqcn.replace('::', '.');
			}
			return fqcn;
		}
	}
}