@IsTest
private class ProjectAsyncTest {

    @IsTest
    static void queueable_createsFollowUpTasks() {
        Account a = new Account(Name = 'Task Co');
        insert a;

        Test.startTest();
        System.enqueueJob(new AccountTaskQueueable(new List<Id>{ a.Id }));
        Test.stopTest();

        Integer taskCount = [SELECT COUNT() FROM Task WHERE WhatId = :a.Id];
        Assert.areEqual(1, taskCount);
    }

    @IsTest
    static void batch_marksExpiredActiveProjectsDone() {
        Account a = new Account(Name = 'Async Co');
        insert a;

        insert new List<Project__c>{
            new Project__c(
                Name = 'Expired', Account__c = a.Id, Status__c = 'Active',
                Start_Date__c = Date.today().addDays(-10),
                End_Date__c = Date.today().addDays(-1)
            ),
            new Project__c(
                Name = 'Running', Account__c = a.Id, Status__c = 'Active',
                Start_Date__c = Date.today().addDays(-10),
                End_Date__c = Date.today().addDays(10)
            )
        };

        Test.startTest();
        Database.executeBatch(new ProjectCompletionBatch());
        Test.stopTest();

        Map<String, Project__c> byName = new Map<String, Project__c>();
        for (Project__c p : [SELECT Name, Status__c FROM Project__c]) {
            byName.put(p.Name, p);
        }
        Assert.areEqual('Done', byName.get('Expired').Status__c);
        Assert.areEqual('Active', byName.get('Running').Status__c);
    }

    @IsTest
    static void scheduler_createsScheduledJob() {
        Test.startTest();
        String jobId = System.schedule(
            'Test project completion', '0 0 2 * * ?', new ProjectCompletionScheduler()
        );
        Test.stopTest();

        CronTrigger ct = [SELECT CronExpression, TimesTriggered FROM CronTrigger WHERE Id = :jobId];
        Assert.areEqual('0 0 2 * * ?', ct.CronExpression);
        Assert.areEqual(0, ct.TimesTriggered);
    }
}