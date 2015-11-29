trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

	List<Task> tl = new List<Task>();

    for(Opportunity oppty: [SELECT AccountId, Id, StageName, Name, Type FROM Opportunity WHERE Id IN :Trigger.New AND StageName = 'Closed Won']) {
    	Task t = new Task( whatID = oppty.Id, Subject = 'Follow Up Test Task', Priority = 'Normal', Status = 'Not Started', Type = 'Action' );
    	tl.add(t);
    }

	if( tl.size() > 0 )
    	insert tl;
}