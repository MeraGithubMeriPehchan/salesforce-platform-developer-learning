@IsTest
private class AccountFactoryTest {

    @TestSetup
    static void setup() {
        TestDataFactory.createAccounts(5, true);
    }

    @IsTest
    static void searchAccounts_findsSetupData() {
        Test.startTest();
        List<Account> result = AccountController.searchAccounts('Factory Account');
        Test.stopTest();

        Assert.areEqual(5, result.size(), 'Expected the 5 accounts from @TestSetup');
    }

    @IsTest
    static void eachAccount_hasPrimaryContact() {
        Integer contacts = [
            SELECT COUNT() FROM Contact WHERE Account.Name LIKE 'Factory Account%'
        ];
        Assert.areEqual(5, contacts, 'Trigger should create one contact per account');
    }

    @IsTest
    static void runAsStandardUser_canCreateAndSearch() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            Alias = 'stdusr',
            Email = 'stduser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Tester',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Kolkata',
            Username = 'stduser' + System.currentTimeMillis() + '@example.com'
        );
        insert u;

        System.runAs(u) {
            insert new Account(Name = 'RunAs Account');
            List<Account> result = AccountController.searchAccounts('RunAs Account');
            Assert.areEqual(1, result.size());
        }
    }
}