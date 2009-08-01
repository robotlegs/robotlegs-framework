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
	import flash.utils.getQualifiedClassName;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.Type;
	import org.robotlegs.core.IInjector;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.RobotLegsObjectFactory;
	
	/**
	 * An adapter for Spring ActionScript
	 * Uses as3commons-lang and as3commons-reflect
	 * See: http://www.springactionscript.org/
	 * See: http://www.as3commons.org/
	 */
	public class SpringInjector implements IInjector
	{
		/**
		 * Internal
		 */
		protected var factory:RobotLegsObjectFactory;
		
		/**
		 * Creates a new <code>SpringInjector</code> object
		 * @param objectFactory
		 */
		public function SpringInjector(objectFactory:RobotLegsObjectFactory = null)
		{
			factory = objectFactory ? objectFactory : new RobotLegsObjectFactory();
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindValue(whenAskedFor:Class, useValue:Object, named:String = null):void
		{
			var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
			var useClassName:String = getQualifiedClassName(useValue);
			var key:String = named ? named : whenAskedForClassName;
			registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.SINGLETON);
			factory.cacheSingletonValue(key, useValue);
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindClass(whenAskedFor:Class, instantiateClass:Class, named:String = null):void
		{
			var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
			var useClassName:String = ClassUtils.getFullyQualifiedName(instantiateClass);
			var properties:Object = findProperties(instantiateClass);
			registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.PROTOTYPE, properties);
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindSingleton(whenAskedFor:Class, named:String = null):void
		{
			var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
			var useClassName:String = whenAskedForClassName;
			var properties:Object = findProperties(whenAskedFor);
			registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.SINGLETON, properties);
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = null):void
		{
			var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
			var useClassName:String = ClassUtils.getFullyQualifiedName(useSingletonOf);
			var properties:Object = findProperties(useSingletonOf);
			registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.SINGLETON, properties);
		}
		
		/**
		 * @inheritDoc
		 */
		public function injectInto(target:Object):void
		{
			var type:Type = Type.forInstance(target);
			var fields:Array = type.fields;
			for each (var field:Field in fields)
			{
				if (field.hasMetaData('Inject'))
				{
					var named:String = null;
					var mds:Array = field.getMetaData('Inject');
					for each (var md:MetaData in mds)
					{
						if (md.hasArgumentWithKey('name'))
						{
							named = md.getArgument('name').value;
							break;
						}
						else if (md.hasArgumentWithKey('id'))
						{
							named = md.getArgument('id').value;
							break;
						}
					}
					named = named ? named : field.type.fullName;
					target[field.name] = factory.getObject(named);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unbind(clazz:Class, named:String = null):void
		{
			named = named ? named : ClassUtils.getFullyQualifiedName(clazz);
			factory.removeObjectDefinition(named);
		}
		
		/**
		 * Internal
		 * @param whenAskedForClassName
		 * @param useClassName
		 * @param named
		 * @param scope
		 * @param properties
		 */
		protected function registerObjectDefinition(whenAskedForClassName:String, useClassName:String, named:String, scope:ObjectDefinitionScope, properties:Object = null):void
		{
			var objdef:ObjectDefinition = new ObjectDefinition(useClassName);
			var key:String = named ? named : whenAskedForClassName;
			objdef.properties = properties ? properties : objdef.properties;
			objdef.scope = scope;
			factory.registerObjectDefinition(key, objdef);
		}
		
		/**
		 * Find annotated dependencies
		 * @param clazz The class to inspect
		 * @return A hash-map of named <code>RuntimeObjectReference</code>s
		 */
		protected function findProperties(clazz:Class):Object
		{
			var type:Type = Type.forClass(clazz);
			var fields:Array = type.fields;
			var properties:Object = new Object();
			for each (var field:Field in fields)
			{
				if (field.hasMetaData('Inject'))
				{
					var named:String = null;
					var mds:Array = field.getMetaData('Inject');
					for each (var md:MetaData in mds)
					{
						if (md.hasArgumentWithKey('name'))
						{
							named = md.getArgument('name').value;
							break;
						}
						else if (md.hasArgumentWithKey('id'))
						{
							named = md.getArgument('id').value;
							break;
						}
					}
					named = named ? named : field.type.fullName;
					properties[field.name] = new RuntimeObjectReference(named);
				}
			}
			return properties;
		}
	
	}
}