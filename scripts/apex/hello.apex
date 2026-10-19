Account a = [SELECT Id FROM Account WHERE Name = 'PHP Learning Test' LIMIT 1];

insert new Project__c(
    Name = 'Website Rebuild',
    Account__c = a.Id,
    Status__c = 'Active',
    Budget__c = 50000,
    Start_Date__c = Date.today(),
    End_Date__c = Date.today().addDays(30)
);

List<Project__c> projects = [
    SELECT Name, Status__c, Budget__c, Account__r.Name
    FROM Project__c
];
for (Project__c p : projects) {
    System.debug(p.Name + ' / ' + p.Account__r.Name + ' / ' + p.Budget__c);
}

Account total = [SELECT Total_Project_Budget__c FROM Account WHERE Id = :a.Id];
System.debug('Total budget: ' + total.Total_Project_Budget__c);