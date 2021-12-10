public class AccountController {
    public static List<Account> insertAccounts(List<Account> accountsToInsert){
        insert accountsToInsert;
        return accountsToInsert;
	}
    public static List<Account> getAllAccounts(){
        List<Account> accounts = [SELECT Name, Phone FROM Account];
        return accounts;
    }
    
    public static void printAllAccounts(){
        List<Account> accounts = getAllAccounts();
        for(Account account: accounts){
            System.debug('Account Name: '+ account.Name);
        }
    }
    
    public static Account insertAccount(Account accountToInsert){
        insert accountToInsert;
        return accountToInsert;
    }
    
    public static Integer getAccountSize(){
        Integer accSize = getAllAccounts().size();
        return accSize;
    }
    
       public static void updateAvgCaseResolutionDays(List<Id> listAccId){
         // Retrieve the accounts
         List<Account> accList = [Select Id, Name, updateAvgCaseResolutionDays__c FROM Account WHERE Id IN: listAccId];
        // retrive all the cases for these account
        List<Case> accCases = [Select Id, CreatedDate, ClosedDate, AccountId FROM Case WHERE IsClosed=true AND AccountId IN: listAccId];
            System.debug('List of accounts before update: ' + accList);
           System.debug('List of cases before update: ' + accCases);
           
           //Loop through all accounts on list
           for (Account acc : accList){
               //Initialize counter variables
               Integer totalDays = 0, totalCases = 0;
               //Loop through all cases in list and find cases related to account in higher loop.
               for(Case cas: accCases){
                   if(acc.Id == cas.AccountId){
                       totalCases ++;
                       totalDays += cas.CreatedDate.date().daysBetween(cas.ClosedDate.date());
                       System.debug('Acc Name: ' + acc.Name + 'Total days: ' + totalDays);
                   }
               }
               if(totalCases == 0){
                   acc.updateAvgCaseResolutionDays__c = null;
               }else{
                   acc.updateAvgCaseResolutionDays__c = totalDays/totalCases;
               }
               
               
           }
           System.debug('List of accounts after update: ' + accList);
           
           update accList;

        /*// get resolution days for each account (ClosedDate - CreatedDate)
        for(Case caseObj : [SELECT Id, CreatedDate, ClosedDate
                             FROM Case
                             WHERE IsClosed=true
                            	AND AccountId =: accountId]){
            // increase number of cases
            totalCases++;
            // get duration in days and add it to totalDays
            totalDays += caseObj.CreatedDate.date().daysBetween(caseObj.ClosedDate.date());
        }
           if(totalCases < 1){
               System.debug('No cases');
           }else{
               Decimal resolutionDays = totalDays/totalCases;
               // update account object
               Account acc = new Account(Id=accountId, updateAvgCaseResolutionDays__c = resolutionDays);
               update acc;    
                }
*/

			
     
    }

}