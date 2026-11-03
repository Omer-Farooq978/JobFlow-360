@isTest 
public class JobApplicationTriggerHandlerTest {

    @isTest
    static void testInterviewCreation(){

Job_Posting__c job = new Job_Posting__c(
     
    Job_Ttile__c = 'salesforce Developer',
    Name = 'Test Job Posting'

);
insert job;
Job_Application__c app = new Job_Application__c(
    Name = 'Salesforce Developer Test',
    Job_Posting__c = job.Id,
    Application_Status__c = 'Applied'
);

insert app;
Test.startTest();

app.Application_Status__c = 'Interview';
update app;

Test.stopTest();
List<Interview__c> interviews = [
    SELECT Id, Job_Application__c, Interview_Round__c
    FROM Interview__c
    WHERE Job_Application__c = :app.Id
];
System.assertEquals(1, interviews.size());
System.assertEquals(app.Id, interviews[0].Job_Application__c);
System.assertEquals('HR', interviews[0].Interview_Round__c);
    }
@isTest
static void testBulkInterviewCreation() {
Job_Posting__c job = new Job_Posting__c(
    Name = 'Bulk Test Job'
);

insert job;
List<Job_Application__c> applications =
        new List<Job_Application__c>();
for (Integer i = 0; i < 5; i++) {

    Job_Application__c app = new Job_Application__c(
        Name = 'Bulk Application ' + i,
        Job_Posting__c = job.Id,
        Application_Status__c = 'Applied'
    );

    applications.add(app);
}
insert applications;
Test.startTest();
for (Job_Application__c app : applications) {
    app.Application_Status__c = 'Interview';
}
update applications;
Test.stopTest();
List<Interview__c> interviews = [
    SELECT Id, Job_Application__c, Interview_Round__c
    FROM Interview__c
    WHERE Job_Application__c IN :applications
];
System.assertEquals(5, interviews.size());
for (Interview__c interview : interviews) {
    System.assertEquals('HR', interview.Interview_Round__c);
}
}
@isTest
static void testNoDuplicateInterview(){

Job_Posting__c job = new Job_Posting__c (

Name = 'Salesforce Developer Test'
);
insert job;
Job_Application__c app = new Job_Application__c(
 Name = 'Bulk Application',
 Job_Posting__c = job.Id,
 Application_Status__c = 'Applied'
);
insert app;
if(app.Application_status__c == 'Applied'){
    app.Application_Status__c = 'Interview';
}
update app;
if(app.Notes__c == null){

    app.Notes__c = 'Preparing for interview';
}
update app;
List<Interview__c> interviews = [
    SELECT Id, Job_Application__c, Interview_Round__c
    FROM Interview__c
    WHERE Job_Application__c = :app.Id
];
System.assertEquals(1, interviews.size());
}
}