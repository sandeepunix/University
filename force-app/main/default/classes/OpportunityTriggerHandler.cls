/**
 * @description Handler for Opportunity trigger.
 * Enforces validations in before context and maintains Account.Max_Amount_Opportunity__c
 * with the Opportunity Name that has the maximum Amount in after contexts.
 */
public with sharing class OpportunityTriggerHandler {
    // Recursion guard for Account updates
    private static Boolean isUpdatingAccounts = false;

    public static void beforeDelete(List<Opportunity> oldOpportunityList) {
        Set<Id> Opportunitywithrlatedactivity = new Set<Id>();
        for (Opportunity opp : [
            SELECT Id, (SELECT Id FROM Tasks), (SELECT Id FROM Events)
            FROM Opportunity
            WHERE Id IN :oldOpportunityList
        ]) {
            List<Task> tasklist = opp.Tasks;
            List<Event> eventlist = opp.Events;
            if (tasklist.isEmpty() || eventlist.isEmpty()) {
                Opportunitywithrlatedactivity.add(opp.Id);
            }
        }
        for (Opportunity opp : oldOpportunityList) {
            if (Opportunitywithrlatedactivity.contains(opp.Id)) {
                opp.addError('You cannot delete this opportunity because it has related activities');
            }
        }
    }

    public static void beforeInsert(List<Opportunity> newOpportunityList) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpportunityList) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        // Query related Accounts
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingPostalCode,
                BillingCountry
            FROM Account
            WHERE Id IN :accountIds
        ]);

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
                    opp.addError('Cannot create Opportunity. The associated Account must have a complete Billing Address.');
                }
            }
        }
    }

    /**
     * After insert/update/undelete handler to recompute the max-amount Opportunity per Account.
     */
    public static void afterInsertUpdateUndelete(List<Opportunity> newList) {
        if (newList == null || newList.isEmpty()) return;
        // Collect impacted Account Ids
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity o : newList) {
            if (o.AccountId != null) accountIds.add(o.AccountId);
        }
        if (accountIds.isEmpty()) return;

        updateAccountWithMaxOppName(accountIds);
    }

    /**
     * After delete handler to recompute the max-amount Opportunity per Account.
     */
    public static void afterDelete(List<Opportunity> oldList) {
        if (oldList == null || oldList.isEmpty()) return;
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity o : oldList) {
            if (o.AccountId != null) accountIds.add(o.AccountId);
        }
        if (accountIds.isEmpty()) return;

        updateAccountWithMaxOppName(accountIds);
    }

    /**
     * Core logic: find, per Account, the Opportunity with maximum Amount and
     * write its Name into Account.Max_Amount_Opportunity__c. If none remain, clear the field.
     * Ties broken by latest CloseDate then CreatedDate.
     */
    private static void updateAccountWithMaxOppName(Set<Id> accountIds) {
        if (isUpdatingAccounts) return;
        isUpdatingAccounts = true;
        try {
            // Query all Opportunities for impacted Accounts
            // Note: adjust field API names if your org differs.
            List<Opportunity> opps = [
                SELECT Id, Name, Amount, CloseDate, CreatedDate, AccountId
                FROM Opportunity
                WHERE AccountId IN :accountIds
                ORDER BY AccountId, Amount DESC NULLS LAST, CloseDate DESC NULLS LAST, CreatedDate DESC
            ];

            // Determine max opp per account
            Map<Id, Opportunity> acctToMaxOpp = new Map<Id, Opportunity>();
            for (Opportunity o : opps) {
                if (o.AccountId == null) continue;
                if (!acctToMaxOpp.containsKey(o.AccountId)) {
                    acctToMaxOpp.put(o.AccountId, o); // first is the max due to ORDER BY
                }
            }

            // Prepare Account updates
            List<Account> updates = new List<Account>();
            for (Id accId : accountIds) {
                Opportunity maxOpp = acctToMaxOpp.get(accId);
                Account a = new Account(Id = accId);
                if (maxOpp != null) {
                    a.Maximum_Amount_Opportunity__c = maxOpp.Name; // Text field assumed
                } else {
                    a.Maximum_Amount_Opportunity__c = null; // Clear if no opps
                }
                updates.add(a);
            }

            if (!updates.isEmpty()) {
                // Update in USER_MODE and handle errors gracefully
                Database.SaveResult[] results = Database.update(updates, false, AccessLevel.USER_MODE);
                // Optional: collect errors for logging if needed (avoid System.debug in prod code)
                // for (Integer i = 0; i < results.size(); i++) { if (!results[i].isSuccess()) { /* handle */ } }
            }
        } finally {
            isUpdatingAccounts = false;
        }
    }
}
