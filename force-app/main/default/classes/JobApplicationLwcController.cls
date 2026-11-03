public with sharing class JobApplicationLwcController {
    @AuraEnabled(cacheable=true)
public static List<Job_Application__c> getApplications() {
    return [
        SELECT Id, Name, Job_Posting__c,
               Application_Status__c,
               Applied_Date__c, Follow_up_Date__c
        FROM Job_Application__c
        WITH USER_MODE
        ORDER BY Follow_up_Date__c ASC
        LIMIT 100
    ];
}
}