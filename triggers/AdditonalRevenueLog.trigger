trigger AdditonalRevenueLog on AdditonalRevenue__c (after insert, after delete, after update) {
    TriggerContrlAdditionalRev.handleTrigger();
}