public with sharing class CustomOpportunityController {

    public List<Opportunity> opportunities {get;set;}
    public List<SelectOption> types {get;set;}
    public List<SelectOption> pages {get;set;}
    public String opportunityType;
    public Integer currentPageNum {get;set;}
   	public Integer totalPages {get;set;}

    private Integer totalRecs = 0;
    private Integer OffsetSize = 0;
    private Integer LimitSize= 5;
    private Map<String, String> filter = new Map<String, String>();
    
    
    public CustomOpportunityController (){
    	setTypes();
    	searchOpportunities();
    }

    public void searchOpportunities() {

        String SELECT_OPPORTUNITIES =  'select name,Description,LeadSource,Type,TotalOpportunityQuantity,ExpectedRevenue,closedate from Opportunity';
        if(opportunities != null && !opportunities.isEmpty() ){
    		opportunities.clear();
		}

		if( filter != null && ! filter.isEmpty() ){
			boolean isfirstElem = true;
			for (String key : filter.keySet()) {
				if( isfirstElem ) {
					SELECT_OPPORTUNITIES += ' WHERE ' + key + ' = \'' + filter.get(key) + '\'';
					isfirstElem = false;
				} else {
					SELECT_OPPORTUNITIES += ' AND ' + key + ' = \'' + filter.get(key) + '\'';
				}
			}
 		}

		//If total record field is empty then get total number of available records
        if(totalRecs != null && totalRecs == 0) {
        	System.debug('Query to get record count ==>'+SELECT_OPPORTUNITIES);
    		List<Opportunity> oppTemp = Database.query(SELECT_OPPORTUNITIES);
    		totalRecs = ( oppTemp !=null && oppTemp.size()>0 ) ? oppTemp.size() : 0;
    		totalPages = Math.ceil(((Double) totalRecs) / LimitSize).intValue();
    		setPages();
 		}

 		//Current Page number
 		currentPageNum = (OffsetSize/LimitSize) + 1;

 		//Search the query 
 		SELECT_OPPORTUNITIES  += ' ORDER BY Name  ASC, CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize';
 		System.debug('Final Query ==>'+SELECT_OPPORTUNITIES);
        opportunities = Database.query(SELECT_OPPORTUNITIES);
    }
    
    public void firstPage() {
        OffsetSize = 0;
        searchOpportunities();
    }
    
    public void previous() {
        OffsetSize = (OffsetSize-LimitSize);
        searchOpportunities();
    }

    public void next(){
        OffsetSize = OffsetSize + LimitSize;
        searchOpportunities();
    }

    public void lastPage() {
        OffsetSize = totalRecs - math.mod(totalRecs,LimitSize);
        searchOpportunities();
    }

    public void goToPage() {
    	OffsetSize = (currentPageNum - 1 ) * LimitSize;
    	searchOpportunities();
    }
 
    public boolean getPrv() {
        if(OffsetSize == 0)
            return true;
        else
            return false;
    }

    public boolean getNxt()
    {
        if((OffsetSize + LimitSize) > totalRecs)
            return true;
        else
            return false;
    }

    public void setTypes() {
    	//If Opportunity types is null or empty then set the values from database
		if( types == null || types.isEmpty() ) {
			types = new List<SelectOption>();
			types.add(new SelectOption('', '- None -'));
			Schema.DescribeFieldResult fieldResult = Opportunity.Type.getDescribe();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry f : ple)
				types.add(new SelectOption(f.getLabel(), f.getValue()));
		}
    }

    public void setPages() {
    	if( totalPages != null && totalPages > 0 ) {
    		pages = new List<SelectOption>();
    		for (Integer i = 1; i <= totalPages; i++) {
    			pages.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
			}
    	}
    }

    public String getOpportunityType() {
    	return opportunityType;
    }

    public void setOpportunityType(String opportunity) {
    	this.opportunityType = opportunity;
    	System.debug('Selected Opportunity ==>' + opportunity);
    }

    public void setcurrentPageNum(Integer currentPageNum) {
    	this.currentPageNum = currentPageNum;
    }

    public void searchFilter() {

    	//If No Option is selected then clear the filter map
    	if( opportunityType != null && opportunityType.length() > 0 ) {
	    	if( filter != null ){
	    		filter.put('Type', opportunityType);
	    	} else {
	    		filter = new Map<String, String>();
	    		filter.put('Type', opportunityType);
	    	}
    	} else {
    		filter.clear();
    	}

    	totalRecs = 0;
    	searchOpportunities();
    }
}