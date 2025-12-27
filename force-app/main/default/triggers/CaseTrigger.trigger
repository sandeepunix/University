trigger CaseTrigger on Case (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        CaseTriggerHelper.beforeInsert(trigger.new);
    }

}