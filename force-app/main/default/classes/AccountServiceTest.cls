@IsTest
private class AccountServiceTest {

    @IsTest
    static void createAccount_savesRecord() {
        Test.startTest();
        Account result = AccountService.createAccount('Test Co');
        Test.stopTest();

        Assert.isNotNull(result.Id, 'Account should have an Id after insert');
        List<Account> found = AccountService.findByName('Test Co');
        Assert.areEqual(1, found.size(), 'Expected exactly one account');
    }

    @IsTest
    static void createAccount_blankName_throws() {
        try {
            AccountService.createAccount('');
            Assert.fail('Expected an exception for a blank name');
        } catch (IllegalArgumentException e) {
            Assert.areEqual('Account name is required', e.getMessage());
        }
    }
}