public with sharing class ProjectCompletionBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c
            FROM Project__c
            WHERE Status__c = 'Active' AND End_Date__c < TODAY
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Project__c> scope) {
        for (Project__c p : scope) {
            p.Status__c = 'Done';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('ProjectCompletionBatch finished');
    }
}