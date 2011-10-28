package mockolate.ingredients
{
    /**
     * Interface implemented by facades to the invocation objects provided by ASMock and Loom.
     * 
     * @author drewbourne
     */
    public interface Invocation
    {
        /**
         * Object this Invocation was triggered by.
         */
        function get target():Object;
        
        /**
         * Name of the Method, Getter or Setter.
         */
        function get name():String;
        
        /**
         * InvocationType indicates if this invocation is a Method, Getter or Setter.
         */
        function get invocationType():InvocationType;
        
        /**
         * Indicates this Invocation is a Method
         */
        function get isMethod():Boolean;
        
        /**
         * Indicates this Invocation is a Getter
         */
        function get isGetter():Boolean;
        
        /**
         * Indicates this Invocation is a Setter
         */
        function get isSetter():Boolean;
        
        /**
         * Array of arguments received by this Invocation
         */
        function get arguments():Array;
        
        /**
         * Value to return.
         */
        function get returnValue():*;
        
        function set returnValue(value:*):void;
        
        /**
         * Proceed with the original implementation.
         */
        function proceed():void;
    }
}