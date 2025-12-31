trigger AccountTrigger on Account (After update) {
    if(trigger.isAfter && trigger.isUpdate){
        AccountTriggetHandel.afterupdate(Trigger.new, Trigger.oldMap);
    }
system.debug('Account Trigger Executed');
}