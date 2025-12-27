trigger LeadTrigger on Lead (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            LeadTriggerHelper.beforeInsert(Trigger.new);
        }
        if(Trigger.isUpdate) {
            LeadTriggerHelper.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}