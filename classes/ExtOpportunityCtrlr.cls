public with sharing class ExtOpportunityCtrlr {

    private final Opportunity opp;

    public ExtOpportunityCtrlr(ApexPages.StandardSetController controller) {
        this.opp = (Opportunity)controller.getRecord();
        setPageSize(5);
    }

    public ApexPages.StandardSetController opportunityRecords {
        get {
            if(opportunityRecords == null) {
                opportunityRecords = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [select name,Description,LeadSource,Type,TotalOpportunityQuantity,ExpectedRevenue,closedate from Opportunity]
                ));
            }
            return opportunityRecords;
        }
        private set;
    }


    public List<Opportunity> getOpportunityList() {
        return (List<Opportunity>) opportunityRecords.getRecords();
    }

    public void setPageSize(Integer pageSize) {
        opportunityRecords.setpagesize(pageSize);
    }

    public Integer getPageSize() {
        return opportunityRecords.getPageSize();
    }

    public Boolean hasNext {
        get {
            return opportunityRecords.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return opportunityRecords.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return opportunityRecords.getPageNumber();
        }
        set;
    }
  
    public void first() {
        opportunityRecords.first();
    }
  
    public void last() {
        opportunityRecords.last();
    }
  
    public void previous() {
        opportunityRecords.previous();
    }
  
    public void next() {
        opportunityRecords.next();
    }

    public Integer getTotalPages() {
        return Math.ceil(((Double) opportunityRecords.getResultSize()) / opportunityRecords.getpagesize()).intValue();
    }

    public pageReference refresh() {
        opportunityRecords = null;
        setPageSize(5);
        getOpportunityList();
        opportunityRecords.setPageNumber(1);
        return null;
    }
}