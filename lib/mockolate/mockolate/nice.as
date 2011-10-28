package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * Creates an instance of the given Class that will behave as a 'nice' mock.
     * 
     * When a Mockolate is 'nice' it will return false-y values for any method 
     * or property that does not have a <code>mock()</code> or 
     * <code>stub()</code> Expectation defined. 
     * 
     * @param klass Class to create a nice mock for.
     * @param name Name for the mock instance.
     * 
     * @see mockolate#strict()
     * @see mockolate#mock()
     * @see mockolate#stub()
     * 
     * @example
     * <listing version="3.0">
     *  var flavour:Flavour = nice(Flavour);
     * </listing>
     * 
     * @author drewbourne
     */
    public function nice(klass:Class, name:String=null, constructorArgs:Array=null):*
    {
        return MockolatierMaster.nice(klass, name, constructorArgs);
    }
}
