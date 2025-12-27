public with sharing class CaseTriggerHelper {
    public static void beforeInsert(List<Case> newCaseList) {
        Set<String> websetName = new Set<String>();
        for(Case c : newCaseList) {
            if(String.isNotBlank(c.SuppliedEmail)) {
                websetName.add(c.SuppliedEmail.toLowerCase());
            }
        }
        map<String,Id> emailtocontactmao = new map<String,Id>();
        for(Contact con : [SELECT Id, Email FROM Contact WHERE Email IN :websetName]) {
            emailtocontactmao.put(con.Email.toLowerCase(), con.Id);
        }

       for(Case caserec : newCaseList) {
           if(String.isNotBlank(caserec.SuppliedEmail)) {
               Boolean isContactFound = emailtocontactmao.containsKey(caserec.SuppliedEmail.toLowerCase());
               if(isContactFound) {
                   Id contactidofcontact = emailtocontactmao.get(caserec.SuppliedEmail.toLowerCase());
                   caserec.ContactId = contactidofcontact;
               }
           }
           }
       }
    }