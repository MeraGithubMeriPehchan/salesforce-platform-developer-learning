@IsTest
private class ProjectTest {

    @IsTest
    static void endBeforeStart_isRejected() {
        Account a = new Account(Name = 'Validation Co');
        insert a;

        Project__c p = new Project__c(
            Name = 'Bad Dates',
            Account__c = a.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(-1)
        );

        try {
            insert p;
            Assert.fail('Expected a validation error');
        } catch (DmlException e) {
            Assert.isTrue(
                e.getMessage().contains('End date must be on or after the start date'),
                'Unexpected message: ' + e.getMessage()
            );
        }
    }

    @IsTest
    static void rollUp_sumsProjectBudgets() {
        Account a = new Account(Name = 'Rollup Co');
        insert a;

        insert new List<Project__c>{
            new Project__c(Name = 'P1', Account__c = a.Id, Budget__c = 1000),
            new Project__c(Name = 'P2', Account__c = a.Id, Budget__c = 2000)
        };

        Account result = [SELECT Total_Project_Budget__c FROM Account WHERE Id = :a.Id];
        Assert.areEqual(3000.00, result.Total_Project_Budget__c);
    }

    @IsTest
    static void relationshipQuery_readsParentName() {
        Account a = new Account(Name = 'Parent Co');
        insert a;
        insert new Project__c(Name = 'Child', Account__c = a.Id);

        Project__c p = [SELECT Account__r.Name FROM Project__c WHERE Name = 'Child'];
        Assert.areEqual('Parent Co', p.Account__r.Name);
    }
}