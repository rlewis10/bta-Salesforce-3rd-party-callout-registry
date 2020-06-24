public class LeadHandler {
    
    public static void btaCreateStudent(List<Lead> leads) {
    
        List<Lead> btaLeads = new List<Lead>();
        
        for(Lead l : leads)
            {   
                if(l.Blockchain_Free__c != null || l.Blockchain_Full__c != null)
                    {       
                        btaLeads.add(l);
                    }
            }
        System.enqueueJob(new btaWebCallout(btaLeads));
    }
        
}