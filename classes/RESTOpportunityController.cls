@RestResource(urlMapping='/Opportunity/*')
global with sharing class RESTOpportunityController {

    @HttpGet
    global static List<Opportunity> getOpportunities() {
        List<Opportunity> opportunities = [select name,Description,LeadSource,Type,TotalOpportunityQuantity,ExpectedRevenue,closedate from Opportunity];
        return opportunities;
    }
}