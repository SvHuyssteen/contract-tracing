trigger ContactTrigger on Contact (after insert, after Update, after Delete, after Undelete) {
    System.debug('trigger type is: ' + Trigger.operationType);
    switch on Trigger.operationType{
        when AFTER_INSERT{
            System.debug('running after insert');
			ContactTriggerHandler.afterInsertUpdateContactActiveOnAccount(Trigger.new);
        }
        
        when AFTER_UPDATE{
            System.debug('running after update');
            list<Id> updatedContacts = new list<Id>();
            for(Contact con : Trigger.new){
                if(String.isNotBlank(con.AccountId) && Trigger.oldMap.get(con.Id).Active__c != con.Active__c){
                    updatedContacts.add(con.AccountId);
                }else if(Trigger.oldMap.get(con.Id).AccountId != con.AccountId){
                    updatedContacts.add(con.AccountId);
                    updatedContacts.add(Trigger.oldMap.get(con.Id).AccountId);
                }else{
                    System.debug('No update to run');
                }
            }

            if(updatedContacts.size()>0){
                ContactTriggerHandler.afterUpdateUpdateContactActiveOnAccount(updatedContacts);
            }
            
        }
        
        when AFTER_DELETE{
            ContactTriggerHandler.afterDeleteUpdateContactActiveOnAccount(Trigger.old);
            
        }

        when AFTER_UNDELETE{
            ContactTriggerHandler.afterUndeleteUpdateContactActiveOnAccount(Trigger.new);
        }
    }

}