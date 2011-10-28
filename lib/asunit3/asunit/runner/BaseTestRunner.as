package asunit.runner {
    import flash.display.Sprite;
    
    /**
     * Base class for all test runners.
     * This class was born live on stage in Sardinia during XP2000.
     */
    public class BaseTestRunner extends Sprite {

        // Filters stack frames from internal JUnit classes
        public static function getFilteredTrace(stack:String):String {
            return stack;
        }
    }
 }
