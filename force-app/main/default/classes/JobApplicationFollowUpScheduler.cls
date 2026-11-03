global class JobApplicationFollowUpScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
   List<Job_Application__c> dueApplications = getDueApplications();
   System.debug(dueApplications.size());
    }
    public static List<Job_Application__c> getDueApplications() {
    List<Job_Application__c> dueApplications = [
        SELECT Id, Name, Follow_up_Date__c, Application_Status__c
        FROM Job_Application__c
        WHERE Follow_up_Date__c <= :Date.today()
        AND Application_Status__c != 'Rejected'
        AND Application_Status__c != 'Withdrawn'
    ];

    return dueApplications;
}
   
}