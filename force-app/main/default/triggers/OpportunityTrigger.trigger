trigger OpportunityTrigger on Opportunity (before delete) {
    for (Opportunity opp : Trigger.old) {
        if (opp.StageName == 'Closed Won') {
            opp.addError('Closed Won opportunities cannot be deleted.');
        }
    }

}