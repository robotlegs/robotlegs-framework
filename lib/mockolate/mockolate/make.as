package mockolate
{
    import mockolate.ingredients.MockolatierMaster;
    
    /**
     * Alias of <code>strict()</code>
     *  
     * @see mockolate#strict()
     * 
     * @author drewbourne
     */
    public function make(klass:Class, name:String=null, constructorArgs:Array=null):*
    {
        return strict(klass, name, constructorArgs);
    }
}
