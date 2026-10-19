@IsTest
private class ProjectSecurityTest {

    private static User newStandardUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            Alias = 'secusr',
            Email = 'secuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'SecTester',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Kolkata',
            Username = 'secuser' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
        return u;
    }

    @IsTest
    static void withoutPermissionSet_userModeInsertIsBlocked() {
        User u = newStandardUser();

        System.runAs(u) {
            Account a = new Account(Name = 'Sec Co');
            insert a;

            Boolean blocked = false;
            try {
                Database.insert(
                    new Project__c(Name = 'No Access', Account__c = a.Id),
                    AccessLevel.USER_MODE
                );
            } catch (Exception e) {
                blocked = true;
            }
            Assert.isTrue(blocked, 'A user with no Project access should be blocked');
        }
    }

    @IsTest
    static void withPermissionSet_userModeInsertWorks() {
        User u = newStandardUser();
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Project_Manager' LIMIT 1];
        insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);

        System.runAs(u) {
            Account a = new Account(Name = 'Sec Co');
            insert a;

            Database.SaveResult result = Database.insert(
                new Project__c(Name = 'Has Access', Account__c = a.Id),
                AccessLevel.USER_MODE
            );
            Assert.isTrue(result.isSuccess(), 'Permission set should allow creating Projects');
        }
    }
}