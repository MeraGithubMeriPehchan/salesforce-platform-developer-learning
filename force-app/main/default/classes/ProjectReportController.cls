public with sharing class ProjectReportController {

    public List<Project__c> projects { get; private set; }

    public ProjectReportController() {
        projects = [
            SELECT Name, Status__c, Budget__c, Account__r.Name
            FROM Project__c
            ORDER BY Name
            LIMIT 50
        ];
    }
}