@IsTest
private class ContactTriggerTest {

    @IsTest
    static void contactInsert_setsLastContactDateOnAccount() {
        Account acc = new Account(Name = 'Trigger Test Co');
        insert acc;

        Contact c = new Contact(LastName = 'Smith', AccountId = acc.Id);
        insert c;

        Account updated = [
            SELECT Last_Contact_Date__c
            FROM Account
            WHERE Id = :acc.Id
        ];
        Assert.areEqual(Date.today(), updated.Last_Contact_Date__c,
            'Account Last_Contact_Date__c should be set to today');
    }

    @IsTest
    static void contactWithoutAccount_doesNotFail() {
        Contact orphan = new Contact(LastName = 'NoAccount');
        insert orphan;
        // Reaching this line without an exception = pass
        Assert.areNotEqual(null, orphan.Id);
    }

    @IsTest
    static void bulkInsert_updatesAllAccounts() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Bulk Co ' + i));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(new Contact(LastName = 'Bulk ' + acc.Name, AccountId = acc.Id));
        }
        insert contacts;

        List<Account> updated = [
            SELECT Last_Contact_Date__c
            FROM Account
            WHERE Id IN :accounts
        ];
        for (Account acc : updated) {
            Assert.areEqual(Date.today(), acc.Last_Contact_Date__c,
                'Every account should get today\'s date');
        }
    }
}