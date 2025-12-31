public with sharing class AccountTriggetHandel {
    public static void afterupdate(List<Account> Newaccount, Map<Id, Account> oldAccountMap)   {
        List<Contact> updatedcontacts = new List<Contact>();
        Map<Id,String> accPhoneMap = new Map<Id,String>();
        for (Account acc : Newaccount) {
            system.debug('Processing Account: ' + acc);
            String newaccphone = acc.Phone;
            String oldaccphone = oldAccountMap.get(acc.Id).Phone;
            if (newaccphone != oldaccphone) {
                accPhoneMap.put(acc.Id, oldaccphone);
            }
            system.debug('Account Phone Map: ' + accPhoneMap);
    
    
        for(Account accid  : [SELECT id,phone,(select id,phone from contacts) FROM Account WHERE id in :accPhoneMap.keySet()]){
            system.debug('Account with Contacts: ' + accid);
            String oldphone = accPhoneMap.get(accid.id);
            system.debug('Old Phone: ' + oldphone);
            String newphone = accid.Phone;
            List<Contact> conlist = accid.Contacts;
            system.debug('Contacts List: ' + conlist);
            for(Contact con : conlist){
                if(String.isBlank(con.Phone) || con.Phone == oldphone){
                    con.Phone = newphone;
                    updatedcontacts.add(con);
                }
            }
        }   
        
    
        system.debug('Updated Contacts List: ' + updatedcontacts);
        if(!updatedcontacts.isEmpty()){
            try{
                update updatedcontacts;
            }
            catch(Exception e){
                System.debug('Error updating contacts: ' + e.getMessage());
            }         
    }
}
    }
}