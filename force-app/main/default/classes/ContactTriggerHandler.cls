public with sharing class ContactTriggerHandler {
    public ContactTriggerHandler() {

    }

    public static void afterInsertUpdateContactActiveOnAccount(List<Contact> newContacts){
        //get list of Ids for all the contacts sent through
        Set<Id> parentAccountIds = new Set<Id>();
        for(Contact cont : newContacts){
            parentAccountIds.add(cont.AccountId);
        }

        //only execute if there is account parent ids
        if(parentAccountIds.size() > 0){
            //Create a list of all the parent accounts of the new contacts coming through, since we are using sets this wil be unique. also pull through all associated contacts.
        List<Account> parentAccounts = [SELECT Id, Name, Active_Contacts__c, (SELECT Id, FirstName, LastName, Active__c FROM Contacts) FROM Account WHERE Id IN: parentAccountIds];
        //loop through each parent Account 
        for(Account parentAccount : parentAccounts){
            //initiate the count on active contacts within parent by setting the count to 0
            Integer countOfActive = 0;
            //loop through all related contacts and for each one active add 1 to count
            for(Contact cont: parentAccount.Contacts){
                if(cont.Active__c == true){
                    countOfActive ++;
                }
            }

            //save account record new value
            System.debug('total active contacts for: ' + parentAccount.Name + ' is ' + countOfActive);
            parentAccount.Active_Contacts__c = countOfActive;
        }

        //use DML statement on list of parent Accounts to update all accounts with new values of active contacts
        update parentAccounts;

        }


        
    }

    public static void afterUpdateUpdateContactActiveOnAccount(List<Id> newAccounts){
        //get list of Ids for all the contacts sent through
        Set<Id> parentAccountIds = new Set<Id>();
        for(Id acc : newAccounts){
            parentAccountIds.add(acc);
        }


        //only execute if there is account parent ids
        if(parentAccountIds.size() > 0){
            //Create a list of all the parent accounts of the new contacts coming through, since we are using sets this wil be unique. also pull through all associated contacts.
            List<Account> parentAccounts = [SELECT Id, Name, Active_Contacts__c, (SELECT Id, FirstName, LastName, Active__c FROM Contacts) FROM Account WHERE Id IN: parentAccountIds];
            //loop through each parent Account 
            for(Account parentAccount : parentAccounts){
                //initiate the count on active contacts within parent by setting the count to 0
                Integer countOfActive = 0;
                //loop through all related contacts and for each one active add 1 to count
                for(Contact cont: parentAccount.Contacts){
                    if(cont.Active__c == true){
                        countOfActive ++;
                    }
                }

                //save account record new value
                System.debug('total active contacts for: ' + parentAccount.Name + ' is ' + countOfActive);
                parentAccount.Active_Contacts__c = countOfActive;
            }

            //use DML statement on list of parent Accounts to update all accounts with new values of active contacts
            update parentAccounts;
        }

    }

    public static void afterDeleteUpdateContactActiveOnAccount(List<Contact> oldContacts){
        //get list of Ids for all the contacts sent through
        Set<Id> parentAccountIds = new Set<Id>();
        for(Contact cont : oldContacts){
            parentAccountIds.add(cont.AccountId);
        }
        //only execute if there is account parent ids
        if(parentAccountIds.size() > 0){
                //Create a list of all the parent accounts of the new contacts coming through, since we are using sets this wil be unique. also pull through all associated contacts.
            List<Account> parentAccounts = [SELECT Id, Name, Active_Contacts__c, (SELECT Id, FirstName, LastName, Active__c FROM Contacts) FROM Account WHERE Id IN: parentAccountIds];
            //loop through each parent Account 
            for(Account parentAccount : parentAccounts){
                //initiate the count on active contacts within parent by setting the count to 0
                Integer countOfActive = 0;
                //loop through all related contacts and for each one active add 1 to count
                for(Contact cont: parentAccount.Contacts){
                    if(cont.Active__c == true){
                        countOfActive ++;
                    }
                }

                //save account record new value
                System.debug('total active contacts for: ' + parentAccount.Name + ' is ' + countOfActive);
                parentAccount.Active_Contacts__c = countOfActive;
            }

            //use DML statement on list of parent Accounts to update all accounts with new values of active contacts
            update parentAccounts;

        }

        
        
    }

    public static void afterUndeleteUpdateContactActiveOnAccount(List<Contact> newContacts){
        //get list of Ids for all the contacts sent through
        Set<Id> parentAccountIds = new Set<Id>();
        for(Contact cont : newContacts){
            parentAccountIds.add(cont.AccountId);
        }

        //only execute if there is account parent ids
        if(parentAccountIds.size() > 0){
            //Create a list of all the parent accounts of the new contacts coming through, since we are using sets this wil be unique. also pull through all associated contacts.
            List<Account> parentAccounts = [SELECT Id, Name, Active_Contacts__c, (SELECT Id, FirstName, LastName, Active__c FROM Contacts) FROM Account WHERE Id IN: parentAccountIds];
            //loop through each parent Account 
            for(Account parentAccount : parentAccounts){
                //initiate the count on active contacts within parent by setting the count to 0
                Integer countOfActive = 0;
                //loop through all related contacts and for each one active add 1 to count
                for(Contact cont: parentAccount.Contacts){
                    if(cont.Active__c == true){
                        countOfActive ++;
                    }
                }

                //save account record new value
                System.debug('total active contacts for: ' + parentAccount.Name + ' is ' + countOfActive);
                parentAccount.Active_Contacts__c = countOfActive;
            }

            //use DML statement on list of parent Accounts to update all accounts with new values of active contacts
            update parentAccounts;

        }

        
       

    }


}
