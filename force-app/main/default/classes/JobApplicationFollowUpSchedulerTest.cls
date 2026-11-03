
@isTest
private class JobApplicationFollowUpSchedulerTest {

    @isTest
    static void testGetDueApplications() {

    Job_Posting__c job = new Job_Posting__c();
    job.Name = 'Test Salesforce Developer Job';
    insert job;
    Job_Application__c app1 = new Job_Application__c();
    app1.job_Posting__c = job.Id;
    app1.Application_Status__c = 'Applied';
    app1.Follow_up_Date__c = Date.today().addDays(-1);
    app1.Applied_Date__c = Date.today().addDays(-2);
    insert app1;
    Job_Application__c app2 = new Job_Application__c();
    app2.Job_Posting__c = job.Id;
    app2.Application_Status__c = 'Rejected';
    app2.Follow_up_Date__c = Date.today().addDays(-1);
    app2.Applied_Date__c = Date.today().addDays(-2);
    insert app2;
    List<Job_Application__c> results =
    JobApplicationFollowUpScheduler.getDueApplications();
    System.assertEquals(1, results.size());
    System.assertEquals(app1.Id, results[0].Id);
    }
    @isTest
static void testScheduledExecution() {
    Test.startTest();

    String jobId = System.schedule(
        'Test JobFlow Follow Up',
        '0 0 0 15 12 ? 2099',
        new JobApplicationFollowUpScheduler()
    );

    Test.stopTest();

    System.assertNotEquals(null, jobId);
}
}
