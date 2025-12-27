public with sharing class LeadTriggerHelper {
    public static void beforeInsert(List<Lead> newLeadList) {
        Set<String> allowwebsetName = new Set<String>();
        allowwebsetName.add('example.com');
        allowwebsetName.add('company.com');
        for(Lead l : newLeadList) {
            if(String.isNotBlank(l.Email.toLowerCase())){
                If(!allowwebsetName.contains(l.Email.toLowerCase().substringAfterLast('@'))) {
                    l.Email = null; //clearing the invalid email filed
                }
            }
    }
}
    public static void beforeUpdate(List<Lead> newLeadList, Map<Id, Lead> oldLeadMap) {
        Set<String> allowwebsetName = new Set<String>();
        allowwebsetName.add('example.com');
        allowwebsetName.add('company.com');
        for(Lead l : newLeadList) {
            String newEmail = l.Email;
            String oldEmail = oldLeadMap.get(l.Id).Email;
            if(newEmail != oldEmail && String.isNotBlank(newEmail)) {
                If(!allowwebsetName.contains(newEmail.toLowerCase().substringAfterLast('@'))) {
                    l.Email = null; //clearing the invalid email filed
                }
            }
    
    }
}
}