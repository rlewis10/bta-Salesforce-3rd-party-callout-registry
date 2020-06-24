@isTest
public class btaWebCalloutTest {
    
    @isTest static void registerStudentsTest() {
        
        List<Lead> testLeads = new List<Lead>();
        testLeads = [Select id, FirstName, LastName, Email From Lead];
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new btaRegisterStudentMock());
        btaWebCallout responses = new btaWebCallout(testLeads);
        
        
        for(Lead l : testLeads)
        {        
            HttpResponse response = responses.registerStudent(l);
            // Verify that the response received contains fake values
            String contentType = response.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = response.getBody();
            System.debug(response.getBody());
            String expectedValue = '{email=test@test.com, first_name=BTA, id=7234, last_name=Test}';
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, response.getStatusCode());  
    
        }
        Test.StopTest();
    }
    
    @isTest static void registerStudentsCourseTest() {
        
        List<Lead> testLeads = new List<Lead>();
        testLeads = [Select id, FirstName, LastName, Email, BTA_Student_ID__c From Lead];
        
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new btaRegisterStudentClassMock());
        btaWebCallout responses = new btaWebCallout(testLeads);
        
        for(Lead l : testLeads)
        {        
            HttpResponse response = responses.registerStudentToCourse(l.BTA_Student_ID__c, '10');
            // Verify that the response received contains fake values
            String contentType = response.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = response.getBody();
            System.debug(response.getBody());
            String expectedValue = '{"message": "success"}';
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, response.getStatusCode());  
    
        }
        Test.StopTest();
    }
        
    @isTest static void newcallout() {
            
           List<Lead> Leadstoinsert = new List<Lead>();
                
           for(Integer i=0;i<10;i++){
                    Lead l = new Lead(lastname = 'testlastname'+i, company = 'testcompany'+i, email = 'email'+i+'@gmail.com', Blockchain_Free__c = '10', BTA_Student_ID__c = String.valueOf(i));
                    Leadstoinsert.add(l);
                }
        	insert Leadstoinsert;
    		
        	Test.startTest(); 
        	btaWebCallout responses = new btaWebCallout(Leadstoinsert);

        	for(Lead l : Leadstoinsert)
                {   
                    // Create our Queueable instance
                    // startTest/stopTest block to force async processes to run
                    Test.setMock(HttpCalloutMock.class, new btaQueueableClassMock());
                    System.enqueueJob(responses);      
                } 
            Test.stopTest(); 
        }
   
}