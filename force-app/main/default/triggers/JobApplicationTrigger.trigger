trigger JobApplicationTrigger on Job_Application__c (after update) {

JobApplicationTriggerHandler.handleAfterUpdate (
    Trigger.new,
    Trigger.oldMap
     );

}