package asunit.errors {
    
    public class AbstractError extends Error {
        
        public function AbstractError(message:String) {
            super(message);
            name = "AbstractError";
        }
    }
}