public class ContactTriggerHandler {

    public static void handleAfterInsert(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();

        for (Contact c : newContacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = [
            SELECT Id, Last_Contact_Date__c
            FROM Account
            WHERE Id IN :accountIds
        ];

        for (Account acc : accountsToUpdate) {
            acc.Last_Contact_Date__c = Date.today();
        }

        update accountsToUpdate;
    }
}