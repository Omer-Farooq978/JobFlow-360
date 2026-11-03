@isTest
private class OverdueFollowUpBatchTest {

    @isTest
    static void testOverdueFollowUpBatch() {
   Job_Posting__c job = new Job_Posting__c();
   job.Name = 'Test Batch Job';
   insert job;

    Job_Application__c app = new Job_Application__c();
 app.Job_Posting__c = job.Id;
 app.Application_Status__c = 'Applied';
 app.Applied_Date__c = Date.today().addDays(-2);
 app.Follow_up_Date__c = Date.today().addDays(-1);
 insert app;   
Test.startTest();
Id batchJobId = Database.executeBatch(
    new OverdueFollowUpBatch(),
    200
);
Test.stopTest();
System.assertNotEquals(null, batchJobId);

    }
}