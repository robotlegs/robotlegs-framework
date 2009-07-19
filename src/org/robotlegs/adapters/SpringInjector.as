package org.robotlegs.adapters
{
    import org.robotlegs.core.IInjector;
    
    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.ObjectUtils;
    import org.as3commons.reflect.Field;
    import org.as3commons.reflect.MetaData;
    import org.as3commons.reflect.Type;
    import org.springextensions.actionscript.ioc.ObjectDefinition;
    import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
    import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
    import org.springextensions.actionscript.ioc.factory.support.RobotLegsObjectFactory;

    public class SpringInjector implements IInjector
    {
        protected var factory:RobotLegsObjectFactory;

        public function SpringInjector()
        {
            factory = new RobotLegsObjectFactory();
        }

        public function bindValue(whenAskedFor:Class, useValue:Object, named:String = null):void
        {
            var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
            var useClassName:String = ObjectUtils.getFullyQualifiedClassName(useValue);
            var key:String = named ? named : whenAskedForClassName;
            registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.SINGLETON);
            factory.cacheSingletonValue(key, useValue);
        }

        public function bindClass(whenAskedFor:Class, instantiateClass:Class, named:String = null):void
        {
            var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
            var useClassName:String = ClassUtils.getFullyQualifiedName(instantiateClass);
            var properties:Object = findProperties(instantiateClass);
            registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.PROTOTYPE, properties);
        }

        public function bindSingleton(whenAskedFor:Class, named:String = null):void
        {
            var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
            var useClassName:String = whenAskedForClassName;
            var properties:Object = findProperties(whenAskedFor);
            registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.SINGLETON, properties);
        }

        public function bindSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = null):void
        {
            var whenAskedForClassName:String = ClassUtils.getFullyQualifiedName(whenAskedFor);
            var useClassName:String = ClassUtils.getFullyQualifiedName(useSingletonOf);
            var properties:Object = findProperties(useSingletonOf);
            registerObjectDefinition(whenAskedForClassName, useClassName, named, ObjectDefinitionScope.SINGLETON, properties);
        }

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

        public function unbind(clazz:Class, named:String = null):void
        {
            named = named ? named : ClassUtils.getFullyQualifiedName(clazz);
            factory.removeObjectDefinition(named);
        }

        protected function registerObjectDefinition(whenAskedForClassName:String, useClassName:String, named:String, scope:ObjectDefinitionScope, properties:Object = null):void
        {
            var objdef:ObjectDefinition = new ObjectDefinition(useClassName);
            var key:String = named ? named : whenAskedForClassName;
            objdef.properties = properties ? properties : objdef.properties;
            objdef.scope = scope;
            factory.registerObjectDefinition(key, objdef);
        }

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