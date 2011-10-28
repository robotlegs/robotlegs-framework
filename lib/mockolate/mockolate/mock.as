package mockolate
{
    import mockolate.ingredients.MockingCouverture;
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * Create an expectation of required behaviour on a target instance.
     * 
     * When the target instance was created using <code>nice()</code>
     * and a method or property on the target instance is called
     * and no expectations have been set using <code>mock()</code> or <code>stub()</code>
     * then a false-y value will be returned (<code>false</code>, <code>null</code>, <code>0</code>, <code>NaN</code>)
     *  
     * When the target instance was created using <code>strict()</code>
     * and a method or property on the target instance is called
     * and no expectations have been set using <code>mock()</code> or <code>stub()</code>
     * then an <code>UnspecifiedBehaiourError</code> will be thrown. 
     * 
     * When <code>verify()</code> is called for the target instance 
     * and the expectation has not been met 
     * then an <code>UnmetExpectationError</code> will be thrown. 
     *  
     * @see mockolate#stub()
     * 
     * @see mockolate#nice()
     * @see mockolate#strict()
     * 
     * @example
     * <listing version="3.0">
     * 	var flavour1:Flavour = make(Flavour);
     *  var flavour2:Flavour = make(Flavour);
     *  var combined:Flavour = make(Flavour);
     *  
     * 	mock(flavour1).method('combine').args(flavour2).returns(combined);
     * 
     *  var result:Flavour = flavour.combine(flavour2); 
     * </listing> 
     * 
     * @author drewbourne
     */
    public function mock(target:*):MockingCouverture
    {
        return MockolatierMaster.mock(target);
    }
}
