@IsTest
private class ProjectSkillTest {

    @IsTest
    static void junction_linksProjectsAndSkills() {
        Account a = new Account(Name = 'Junction Co');
        insert a;

        Project__c p1 = new Project__c(Name = 'P1', Account__c = a.Id);
        Project__c p2 = new Project__c(Name = 'P2', Account__c = a.Id);
        insert new List<Project__c>{ p1, p2 };

        Skill__c skillRec = new Skill__c(Name = 'Apex');
        insert skillRec;

        insert new List<Project_Skill__c>{
            new Project_Skill__c(Project__c = p1.Id, Skill__c = skillRec.Id),
            new Project_Skill__c(Project__c = p2.Id, Skill__c = skillRec.Id)
        };

        List<Project_Skill__c> links = [
            SELECT Project__r.Name, Skill__r.Name
            FROM Project_Skill__c
            WHERE Skill__c = :skillRec.Id
            ORDER BY Project__r.Name
        ];
        Assert.areEqual(2, links.size(), 'One skill linked to two projects');
        Assert.areEqual('P1', links[0].Project__r.Name);

        delete skillRec;
        Integer remaining = [SELECT COUNT() FROM Project_Skill__c];
        Assert.areEqual(0, remaining, 'Deleting a master removes its junction rows');
    }
}