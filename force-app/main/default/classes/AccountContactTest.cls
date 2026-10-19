@IsTest
private class AccountContactTest {

    @IsTest
    static void insertAccount_createsOneContact() {
        Account acc = new Account(Name = 'Contact Test Co');
        insert acc;

        Account result = [
            SELECT Id, (SELECT Id, LastName FROM Contacts)
            FROM Account
            WHERE Id = :acc.Id
        ];
        Assert.areEqual(1, result.Contacts.size(), 'Expected one contact');
        Assert.areEqual('Primary Contact', result.Contacts[0].LastName);
    }

    @IsTest
    static void insertBulk_createsContactForEach() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accs.add(new Account(Name = 'Bulk Contact ' + i));
        }
        insert accs;

        Set<Id> accountIds = new Map<Id, Account>(accs).keySet();
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId IN :accountIds];
        Assert.areEqual(200, contactCount, 'Each account should get one contact');
    }

    @IsTest
    static void contact_canReadParentName() {
        Account acc = new Account(Name = 'Parent Name Co');
        insert acc;

        Contact c = [SELECT LastName, Account.Name FROM Contact WHERE AccountId = :acc.Id];
        Assert.areEqual('Parent Name Co', c.Account.Name);
    }
}