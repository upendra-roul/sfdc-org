public with sharing Class AccountHandler {

    public static Account insertNewAccount(String accName) {
        
        Account res = new Account(Name = accName);
        
        try {
            insert res;
            return res;
        } catch(DmlException e) {
            return null;
        }
        
    }
}