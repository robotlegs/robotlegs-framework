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
	import net.expantra.smartypants.Injector;
	import net.expantra.smartypants.SmartyPants;
	import net.expantra.smartypants.dsl.InjectorRuleNamed;
	
	import org.robotlegs.core.IInjector;
	
	/**
	 * An adapter for SmartyPants-IOC
	 * See: http://code.google.com/p/smartypants-ioc/
	 */
	public class SmartyPantsInjector implements IInjector
	{
		/**
		 * Internal
		 * The concrete SmartyPants-IOC Injector
		 */
		protected var injector:Injector;
		
		/**
		 * Creates a new <code>SmartyPantsInjector</code> object
		 * @param injector
		 */
		public function SmartyPantsInjector(injector:Injector = null)
		{
			this.injector = injector ? injector : SmartyPants.getOrCreateInjectorFor(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindValue(whenAskedFor:Class, useValue:Object, named:String = null):void
		{
			getRule(whenAskedFor, named).useValue(useValue);
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindClass(whenAskedFor:Class, instantiateClass:Class, named:String = null):void
		{
			getRule(whenAskedFor, named).useClass(instantiateClass);
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindSingleton(whenAskedFor:Class, named:String = null):void
		{
			getRule(whenAskedFor, named).useSingleton();
		}
		
		/**
		 * @inheritDoc
		 */
		public function bindSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = null):void
		{
			getRule(whenAskedFor, named).useSingletonOf(useSingletonOf);
		}
		
		/**
		 * @inheritDoc
		 */
		public function injectInto(target:Object):void
		{
			injector.injectInto(target);
		}
		
		/**
		 * @inheritDoc
		 */
		public function unbind(clazz:Class, named:String = null):void
		{
			getRule(clazz, named).defaultBehaviour();
		}
		
		/**
		 * Sorry I ruined your DSL.. it was just simpler this way
		 * @param clazz
		 * @param named
		 * @return The <code>InjectorRuleNamed</code>
		 */
		protected function getRule(clazz:Class, named:String = null):InjectorRuleNamed
		{
			return named ? injector.newRule().whenAskedFor(clazz).named(named) : injector.newRule().whenAskedFor(clazz);
		}
	
	}
}