trigger OpportunityTrigger on Opportunity (before delete, before insert, after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            OpportunityTriggerHandler.beforeDelete(Trigger.old);
        }
        if (Trigger.isInsert) {
            OpportunityTriggerHandler.beforeInsert(Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            OpportunityTriggerHandler.afterInsertUpdateUndelete(Trigger.new);
        }
        if (Trigger.isDelete) {
            OpportunityTriggerHandler.afterDelete(Trigger.old);
        }
    }
}
