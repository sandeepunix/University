/**
 * @description Handler for Contact trigger. Maintains Account.Contact_Count__c
 *              as the COUNT of related Contacts for each Account.
 * @requirements
 *  - Bulkified, no SOQL/DML in loops
 *  - Handle insert, update (including re-parent), delete, undelete
 *  - Respect sharing (with sharing) and run DML in USER_MODE
 *  - Return-early pattern and exception safety
 */
public with sharing class ContactTriggerHandler {

    // Enum for field API names to avoid hardcoded strings
    //public enum CONTACT_FIELDS { ACCOUNTID }
    //public enum ACCOUNT_FIELDS { CONTACT_COUNT__C }

    public static void afterInsert(List<Contact> newContacts) {
        if (newContacts == null || newContacts.isEmpty()) return;
        Set<Id> accountIds = collectAccountIds(newContacts, null);
        recalcAndUpdateAccounts(accountIds);
    }

    public static void afterUpdate(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        if (newContacts == null || newContacts.isEmpty()) return;
        // Recalculate for both old and new AccountIds to handle re-parenting and amount changes
        Set<Id> accountIds = collectAccountIds(newContacts, oldMap);
        recalcAndUpdateAccounts(accountIds);
    }

    public static void afterDelete(List<Contact> oldContacts) {
        if (oldContacts == null || oldContacts.isEmpty()) return;
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : oldContacts) {
            if (c.AccountId != null) accountIds.add(c.AccountId);
        }
        recalcAndUpdateAccounts(accountIds);
    }

    public static void afterUndelete(List<Contact> newContacts) {
        if (newContacts == null || newContacts.isEmpty()) return;
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : newContacts) {
            if (c.AccountId != null) accountIds.add(c.AccountId);
        }
        recalcAndUpdateAccounts(accountIds);
    }

    // Collect AccountIds from new and old values (for update/reparent support)
    private static Set<Id> collectAccountIds(List<Contact> newList, Map<Id, Contact> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact cNew : newList) {
            if (cNew.AccountId != null) accountIds.add(cNew.AccountId);
            if (oldMap != null) {
                Contact cOld = oldMap.get(cNew.Id);
                if (cOld != null && cOld.AccountId != null) accountIds.add(cOld.AccountId);
            }
        }
        return accountIds;
    }

    // Recalculate COUNT(Contacts) per Account and update Account.Contact_Count__c
    private static void recalcAndUpdateAccounts(Set<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) return;

        // Aggregate counts by AccountId; ignore Contacts without Account
        Map<Id, Integer> countsByAccount = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId aId, COUNT(Id) total
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            Id aId = (Id) ar.get('aId');
            Integer total = (Integer) ar.get('total');
            countsByAccount.put(aId, total == null ? 0 : total);
        }

        // Prepare Account updates; set zero when no contacts remain
        List<Account> toUpdate = new List<Account>();
        for (Id aId : accountIds) {
            Account acc = new Account(Id = aId);
            Integer val = countsByAccount.containsKey(aId) ? countsByAccount.get(aId) : 0;
            // Dynamic assignment to avoid compilation issues if field metadata isn't present locally
            acc.put('Contact_Count__c', val);
            toUpdate.add(acc);
        }

        if (toUpdate.isEmpty()) return;

        // Update in USER_MODE per org security requirements; capture errors
        Database.SaveResult[] results = Database.update(toUpdate, /*allOrNone*/ false, AccessLevel.USER_MODE);
        // Optionally collect failures in a platform event or custom log if needed
    }
}
