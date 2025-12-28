public with sharing class OpportunityTriggerHandler {
    public static void beforeDelete(List<Opportunity> oldOpportunityList) {
        set<Id> Opportunitywithrlatedactivity = new set<Id>();
        for(Opportunity opp : [SELECT Id, (select id from tasks), (select id from events) FROM Opportunity WHERE Id IN :oldOpportunityList]){
           List<Task> tasklist = opp.tasks;
           List<Event> eventlist = opp.events;
           if(tasklist.isEmpty() || eventlist.isEmpty()) {
               Opportunitywithrlatedactivity.add(opp.id);
           }
        }
        for(Opportunity opp : oldOpportunityList) {
            if(Opportunitywithrlatedactivity.contains(opp.id)) {
                opp.addError('You cannot delete this opportunity because it has related activities');          
            }
        }
}
    public static void beforeInsert(List<Opportunity> newOpportunityList) {
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : newOpportunityList) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

    // Query related Accounts
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [
                SELECT Id,
                    BillingStreet,
                    BillingCity,
                    BillingState,
                    BillingPostalCode,
                    BillingCountry
                FROM Account
                WHERE Id IN :accountIds
            ]
        );

    // Validate Billing Address
        for (Opportunity opp : newOpportunityList) {
            if (opp.AccountId != null) {
                Account acc = accountMap.get(opp.AccountId);

                if (acc == null ||
                    String.isBlank(acc.BillingStreet) ||
                    String.isBlank(acc.BillingCity) ||
                    String.isBlank(acc.BillingState) ||
                    String.isBlank(acc.BillingPostalCode) ||
                    String.isBlank(acc.BillingCountry)
                ) {
                    opp.addError(
                        'Cannot create Opportunity. The associated Account must have a complete Billing Address.'
                    );
                }
            }
    } 
}
}