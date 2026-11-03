public with sharing class OverdueFollowUpBatch
    implements Database.Batchable<SObject> {
public Database.QueryLocator start(Database.BatchableContext bc) {
     return Database.getQueryLocator([
        SELECT Id, Name, Follow_up_Date__c, Application_Status__c
        FROM Job_Application__c
        WHERE Follow_up_Date__c <= :Date.today()
        AND Application_Status__c != 'Rejected'
        AND Application_Status__c != 'Withdrawn'
    ]);
    
}
public void execute(
    Database.BatchableContext bc,
    List<Job_Application__c> scope
) {
    System.debug('Applications in this batch: ' + scope.size());
}
public void finish(Database.BatchableContext bc) {
    System.debug('Overdue Follow-Up Batch completed.');
}
}