public with sharing class AccountTaskQueueable implements Queueable {

    private List<Id> accountIds;

    public AccountTaskQueueable(List<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {
        List<Task> tasks = new List<Task>();
        for (Id accId : accountIds) {
            tasks.add(new Task(
                Subject = 'Review projects',
                WhatId = accId,
                ActivityDate = Date.today().addDays(7)
            ));
        }
        insert tasks;
    }
}