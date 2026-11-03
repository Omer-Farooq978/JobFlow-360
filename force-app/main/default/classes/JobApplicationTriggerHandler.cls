public class JobApplicationTriggerHandler {

public static void handleAfterUpdate (

List<Job_Application__c> newApplications,
Map<Id, Job_Application__c> oldMap
){

List<Interview__c> interviewsToCreate = new List<Interview__c>();

for(Job_Application__c app : newApplications){

     if(app.Application_Status__c == 'Interview' && 
     oldMap.get(app.Id).Application_Status__c != 'Interview'){

 Interview__c interview = new Interview__c (
   Job_Application__c = app.Id,
   Interview_Round__c = 'HR'

 );
 interviewsToCreate.add(interview);

 }

}
if(!interviewsToCreate.isEmpty()){

    insert interviewsToCreate;
}

}

} 