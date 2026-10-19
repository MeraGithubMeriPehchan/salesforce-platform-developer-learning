@IsTest
private class AccountTriggerTest {

    @IsTest
    static void insertBlankDescription_setsDefault() {
        Account acc = new Account(Name = 'Trigger Test');
        insert acc;

        Account saved = [SELECT Description FROM Account WHERE Id = :acc.Id];
        Assert.isTrue(saved.Description.startsWith('Created via trigger'));
    }

    @IsTest
    static void insertWithDescription_keepsIt() {
        Account acc = new Account(Name = 'Has Description', Description = 'My own text');
        insert acc;

        Account saved = [SELECT Description FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('My own text', saved.Description);
    }

    @IsTest
    static void insertBulk_all200Updated() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accs.add(new Account(Name = 'Bulk ' + i));
        }
        insert accs;

        List<Account> saved = [SELECT Id, Description FROM Account WHERE Name LIKE 'Bulk %'];
        Assert.areEqual(200, saved.size(), 'Expected 200 accounts');

        Integer updated = 0;
        for (Account a : saved) {
            if (a.Description != null && a.Description.startsWith('Created via trigger')) {
                updated++;
            }
        }
        Assert.areEqual(200, updated, 'Trigger should set Description on all 200');
    }

    @IsTest
    static void updateName_setsChangeMessage() {
        Account acc = new Account(Name = 'Old Name');
        insert acc;

        acc.Name = 'New Name';
        update acc;

        Account saved = [SELECT Description FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('Name changed from Old Name to New Name', saved.Description);
    }

    @IsTest
    static void updateOtherField_leavesDescriptionAlone() {
        Account acc = new Account(Name = 'Stable Name', Description = 'Original');
        insert acc;

        acc.Industry = 'Technology';
        update acc;

        Account saved = [SELECT Description FROM Account WHERE Id = :acc.Id];
        Assert.areEqual('Original', saved.Description);
    }
}