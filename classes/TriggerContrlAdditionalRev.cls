public with sharing class TriggerContrlAdditionalRev {

	private static Set<Id> opportunityIds = new Set<Id>();
	private static List<LogAdditionalRevenue__c> logList = new List<LogAdditionalRevenue__c>();

	public TriggerContrlAdditionalRev() {}

	public static void handleTrigger() {

		for( AdditonalRevenue__c ar : Trigger.isDelete ? (List<AdditonalRevenue__c>) Trigger.Old : (List<AdditonalRevenue__c>) Trigger.new ) {

			//Store Opportunity Ids
			if ( ar.Opportunity__c != null )
				opportunityIds.add( ar.Opportunity__c );

			LogAdditionalRevenue__c la = new LogAdditionalRevenue__c();
			if( Trigger.isInsert ) {
				la.LogDescription__c = 'Record with AdditonalRevenueID: '+  ar.Name + ', Description: ' + ar.Description__c + ' inserted to AdditionalRevenue';
				la.ActionPerformed__c = 'INSERTED';
			} else if( Trigger.isUpdate ) {
				la.LogDescription__c = 'Record with AdditonalRevenueID: '+  ar.Name + ', Description: ' + ar.Description__c + ' updated in AdditionalRevenue';
				la.ActionPerformed__c = 'UPDATED';
			} else if( Trigger.isDelete ) {
				la.LogDescription__c = 'Record with AdditonalRevenueID: '+  ar.Name + ', Description: ' + ar.Description__c + ' deleted from AdditionalRevenue';
				la.ActionPerformed__c = 'DELETED';
        	}
        	logList.add(la);
		}

		//Add Operation log on AdditonalRevenue__c into LogAdditionalRevenue__c
		insert logList;

		//Update additional revenue count
		updateTotalAdditionalRev();

		opportunityIds.clear();
		logList.clear();

	}


	private static void updateTotalAdditionalRev() {

		if( !opportunityIds.isEmpty() ) {

			//Select all opportunities in list for bulk update
			List<Opportunity> opportunities = [
				select Id, Name, Amount, TotalAdditional__c
				from Opportunity
				where Id in :opportunityIds
			];

			//Select Opportunity IDS and their total sum of additioanl revenue
			Map<Id, double> additionalRevCounts = new Map<Id, double>();
			for (AggregateResult ar : [SELECT Opportunity__c, SUM(TopUpAmount__c) totalAmount
						FROM AdditonalRevenue__c WHERE Opportunity__c IN :opportunityIds AND IsApproved__c = true GROUP BY Opportunity__c])
				additionalRevCounts.put((ID) ar.get('Opportunity__c'), (double) ar.get('totalAmount'));

			//Update Oportunity Object with the new Sum of total additional revenue
			for(Opportunity op :opportunities)
				op.TotalAdditional__c = additionalRevCounts.get(op.Id);

			//Update all the opprotunities
			update opportunities;
		}
	}

}