@IsTest
public class TestDataFactory {

    public static List<Account> createAccounts(Integer count, Boolean doInsert) {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accs.add(new Account(Name = 'Factory Account ' + i));
        }
        if (doInsert) {
            insert accs;
        }
        return accs;
    }
}