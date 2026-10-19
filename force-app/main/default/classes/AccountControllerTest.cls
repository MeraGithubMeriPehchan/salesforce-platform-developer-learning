@IsTest
private class AccountControllerTest {

    @IsTest
    static void getRecentAccounts_returnsInsertedAccount() {
        insert new Account(Name = 'LWC Test Co');

        List<Account> result = AccountController.getRecentAccounts();

        Assert.isFalse(result.isEmpty(), 'Expected at least one account');
        Assert.areEqual('LWC Test Co', result[0].Name);
    }

    @IsTest
    static void searchAccounts_findsMatch() {
        insert new Account(Name = 'Searchable Widgets Inc');

        List<Account> result = AccountController.searchAccounts('Widgets');

        Assert.areEqual(1, result.size());
        Assert.areEqual('Searchable Widgets Inc', result[0].Name);
    }

    @IsTest
    static void searchAccounts_noMatch_returnsEmpty() {
        insert new Account(Name = 'Something Else');

        List<Account> result = AccountController.searchAccounts('zzzNoSuchName');

        Assert.isTrue(result.isEmpty());
    }
}