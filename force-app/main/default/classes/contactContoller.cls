public with sharing class contactContoller {
    @AuraEnabled(cacheable=true)
    public static List<contact> getcontacts(String accid){
        try {
            return [SELECT AccountId, Id, Name, Email 
            FROM Contact 
            WHERE AccountId = :accid
            with SECURITY_ENFORCED];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public contactContoller() {

    }
}