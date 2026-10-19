public with sharing class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getRecentAccounts() {
        return [
            SELECT Id, Name, Industry, Rating
            FROM Account
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
        String key = '%' + (searchTerm == null ? '' : searchTerm) + '%';
        return [
            SELECT Id, Name, Industry, Rating
            FROM Account
            WHERE Name LIKE :key
            ORDER BY Name
            LIMIT 20
        ];
    }
}