public with sharing Class ContactAndLeadSearch {

    public static List<List< SObject>> searchContactsAndLeads(String name) {
        List<List< SObject>> result = [FIND :name IN NAME FIELDS RETURNING Lead(Id, Name), Contact(Id, FirstName,LastName,Department)];
        return result;
    }

}