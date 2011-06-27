package asunit.errors {
    
    public class InstanceNotFoundError extends Error {
        
        public function InstanceNotFoundError(message:String) {
            super(message);
            name = "InstanceNotFoundError";
        }
    }
}