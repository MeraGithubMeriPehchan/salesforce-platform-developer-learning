public with sharing class AccountTriggerHandler {

    public static void beforeInsert(List<Account> newAccounts) {
        setDefaultDescription(newAccounts);
    }

    public static void beforeUpdate(List<Account> newAccounts, Map<Id, Account> oldMap) {
        trackNameChanges(newAccounts, oldMap);
    }

    public static void afterInsert(List<Account> newAccounts) {
        createPrimaryContacts(newAccounts);
    }

    private static void setDefaultDescription(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Description)) {
                acc.Description = 'Created via trigger on ' + String.valueOf(System.today());
            }
        }
    }

    private static void trackNameChanges(List<Account> newAccounts, Map<Id, Account> oldMap) {
        for (Account acc : newAccounts) {
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.Name != oldAcc.Name) {
                acc.Description = 'Name changed from ' + oldAcc.Name + ' to ' + acc.Name;
            }
        }
    }

    private static void createPrimaryContacts(List<Account> accounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : accounts) {
            contactsToInsert.add(new Contact(
                LastName = 'Primary Contact',
                AccountId = acc.Id
            ));
        }
        insert contactsToInsert;
    }
}