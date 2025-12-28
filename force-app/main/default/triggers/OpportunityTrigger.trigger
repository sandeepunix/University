trigger OpportunityTrigger on Opportunity (before delete, before insert) {
    if(Trigger.isBefore) {
        if(Trigger.isDelete) {
            OpportunityTriggerHandler.beforeDelete(Trigger.old);
        }
        if(Trigger.isInsert) {
            OpportunityTriggerHandler.beforeInsert(Trigger.new);
        }
    }
}