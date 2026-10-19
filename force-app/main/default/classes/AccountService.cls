public with sharing class AccountService {

    public static Account createAccount(String accountName) {
        if (String.isBlank(accountName)) {
            throw new IllegalArgumentException('Account name is required');
        }
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc;
    }

    public static List<Account> findByName(String accountName) {
        return [
            SELECT Id, Name, CreatedDate
            FROM Account
            WHERE Name = :accountName
            ORDER BY CreatedDate DESC
        ];
    }
}