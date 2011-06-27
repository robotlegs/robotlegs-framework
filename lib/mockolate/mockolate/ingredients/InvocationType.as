package mockolate.ingredients
{
    /**
     * Type of an Invocation.
     * 
     * <ul>
     * <li><code>METHOD</code> indicates the Invocation is a Method.
     * <li><code>GETTER</code> indicates the Invocation is for the getter of a Property.
     * <li><code>SETTER</code> indicates the Invocation is for the setter of a Property.
     * </ul>
     * 
     * @author drewbourne
     */
    public class InvocationType
    {
    	/**
    	 * Used to indicate a Method Invocation. 
    	 */
        public static const METHOD:InvocationType = new InvocationType("METHOD");
        
    	/**
    	 * Used to indicate a Property getter Invocation.
    	 */
        public static const GETTER:InvocationType = new InvocationType("GETTER");
        
    	/**
    	 * Used to indicate a Property setter Invocation.
    	 */
        public static const SETTER:InvocationType = new InvocationType("SETTER");
        
        private var _name:String;
        
    	/**
    	 * Constructor.
    	 * 
    	 * @private 
    	 */
        public function InvocationType(name:String)
        {
            _name = name;
        }
        
    	/**
    	 * Indicates if this InvocationType is InvocationType.METHOD.
    	 */
        public function get isMethod():Boolean
        {
            return this == METHOD;
        }
        
    	/**
    	 * Indicates if this InvocationType is InvocationType.GETTER.
    	 */
        public function get isGetter():Boolean
        {
            return this == GETTER;
        }
        
     	/**
    	 * Indicates if this InvocationType is InvocationType.SETTER.
    	 */
       public function get isSetter():Boolean
        {
            return this == SETTER;
        }
        
    	/**
    	 * Formats the InvocationType as a String. 
    	 */
        public function toString():String
        {
            return _name;
        }
    }
}