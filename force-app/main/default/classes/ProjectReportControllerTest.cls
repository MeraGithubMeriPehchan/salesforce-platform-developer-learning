@IsTest
private class ProjectReportControllerTest {

    @IsTest
    static void controller_loadsProjects() {
        Account a = new Account(Name = 'VF Co');
        insert a;
        insert new Project__c(Name = 'VF Project', Account__c = a.Id, Budget__c = 500);

        Test.startTest();
        ProjectReportController ctrl = new ProjectReportController();
        Test.stopTest();

        Assert.isFalse(ctrl.projects.isEmpty());
        Assert.areEqual('VF Project', ctrl.projects[0].Name);
    }
}