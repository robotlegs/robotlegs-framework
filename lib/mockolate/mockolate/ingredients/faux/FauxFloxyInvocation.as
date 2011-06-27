package mockolate.ingredients.faux
{
    import org.flemit.reflection.Type;
    import org.flemit.reflection.MethodInfo;
    import org.flemit.reflection.PropertyInfo;
    import org.floxy.IInvocation;

    public class FauxFloxyInvocation implements IInvocation
    {
        public function FauxFloxyInvocation()
        {
        }

        public function get arguments():Array
        {
            return null;
        }
        
        public function get targetType():Type
        {
            return null;
        }
        
        public function get proxy():Object
        {
            return null;
        }
        
        public function get method():MethodInfo
        {
            return null;
        }
        
        public function get property():PropertyInfo
        {
            return null;
        }
        
        public function get invocationTarget():Object
        {
            return null;
        }
        
        public function get methodInvocationTarget():MethodInfo
        {
            return null;
        }
        
        public function get returnValue():Object
        {
            return null;
        }
        
        public function set returnValue(value:Object):void
        {
        }
        
        public function get canProceed():Boolean
        {
            return false;
        }
        
        public function proceed():void
        {
        }
        
    }
}