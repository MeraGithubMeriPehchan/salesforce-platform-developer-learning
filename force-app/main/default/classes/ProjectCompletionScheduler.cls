public with sharing class ProjectCompletionScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ProjectCompletionBatch(), 200);
    }
}