List<Account> accs = [
    SELECT Name, (SELECT LastName FROM Contacts)
    FROM Account
    WHERE Name LIKE 'Manual Trigger%'
];
for (Account a : accs) {
    System.debug(a.Name + ' has ' + a.Contacts.size() + ' contact(s)');
}

List<Contact> cons = [SELECT LastName, Account.Name FROM Contact LIMIT 5];
System.debug('Contacts found: ' + cons.size());