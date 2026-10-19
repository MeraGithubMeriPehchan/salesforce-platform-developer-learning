Account a = [SELECT Id FROM Account WHERE Name = 'PHP Learning Test' LIMIT 1];

insert new Project__c(
    Name = 'Old Project',
    Account__c = a.Id,
    Status__c = 'Active',
    Start_Date__c = Date.today().addDays(-30),
    End_Date__c = Date.today().addDays(-1),
    Budget__c = 1000
);

Id jobId = Database.executeBatch(new ProjectCompletionBatch(), 200);
System.debug('Batch job id: ' + jobId);