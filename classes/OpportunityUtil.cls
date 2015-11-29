public with sharing class OpportunityUtil{


    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select name,Description,LeadSource,Type,TotalOpportunityQuantity,ExpectedRevenue,closedate from Opportunity]));
            }
            return setCon;
        }
        set;
    }

    public List<Opportunity> getOpportunities() {
         setCon.setpagesize(5);
         return (List<Opportunity>) setCon.getRecords();
    }
}