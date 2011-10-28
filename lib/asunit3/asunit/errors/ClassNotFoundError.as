package asunit.errors {
    
    public class ClassNotFoundError extends Error {
        
        public function ClassNotFoundError(message:String) {
            super(message);
            name = "ClassNotFoundError";
        }    
    }
}