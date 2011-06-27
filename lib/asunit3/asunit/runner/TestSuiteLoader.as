package asunit.runner {
    
    public interface TestSuiteLoader {
        // throws ClassNotFoundException
        function load(suiteClassName:String):Class;
        // throws ClassNotFoundException
        function reload(aClass:Class):Class;
    }
}