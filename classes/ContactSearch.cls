public with sharing Class ContactSearch {

    public static List<Contact> searchForContacts(String lname, String postCode) {
    
        List<Contact> contactSearchRes = [SELECT Id, Name FROM Contact where MailingPostalCode = :postCode AND LastName = :lname];
        return contactSearchRes;
    }

}