/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* REST Callout Class for BTA Blockchain Training Alliance
*
* Accepts leads and registers a new student.
* where Blockchain_Full__c or Blockchain_Free__c contain course Id's, associates a student to a course.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Richard Lewis <richard@rlewis.me>
* @modifiedBy     Richard Lewis <richard@rlewis.me>
* @maintainedBy   Richard Lewis <richard@rlewis.me>
* @version        1.0
* @created        2019-07-02
* @modified       2019-07-02
* @systemLayer    Service
* @related        LeadHandler, LeadTrigger
* @test           btaWebCalloutTest
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class btaWebCallout implements Queueable, Database.AllowsCallouts{
    
    //list for accepting leads when new object is created
    private List<Lead> leads;
    //list for writing to DB of updated leads after api callout
    private List<Lead> newleads = new List<Lead>();
    
    // get the BTA API Token from within a list custom setting called: 'BTA Blockchain'
    bta_blockchain__c apiTokenCusSet = bta_blockchain__c.getValues('btaBlockchainApikey');
    Private final String apiToken = apiTokenCusSet.BTA_Blockchain_API_Key__c;
    
    // constructor accepting a list of leads
    public btaWebCallout(List<Lead> leads){
        
      this.leads = leads;
    }
    
    // registers a new student, accepting a lead and returning a BTA student Id
    public HttpResponse registerStudent(Lead l){
        
			Http http = new Http();
        
            // request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://btacertified.com/api/v1/studentregister');
            
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Authorization',  apiToken);
            
            // Set the body as a JSON object passed as string into the method
            req.setBody('{"first_name": "' + l.FirstName + '", "last_name": "' + l.LastName + '", "email": "' + l.Email + '", "password" : "' + passwordgen() +'"}');
             
            // response    
            HttpResponse res = new HttpResponse();
    
            try {
                res = http.send(req);
                System.debug('api success' + res.getBody());
                return res;
                } 
            
            catch(System.CalloutException e) {
                System.debug('Error: '+ e);
                return null;
                } 
    }
    
    //registers a student to a course requires BTA student Id and course Id
    public HttpResponse registerStudentToCourse(String studentId, String courseId){
        
            Http http = new Http();
            
            // request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://btacertified.com/api/v1/addcourse');
            
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('Authorization',  apiToken);
            
            // Set the body as a JSON object passed as string into the method
            req.setBody('{"student_id": "' + studentId + '", "course_id": "' + courseId + '"}');
             
            // response    
            HttpResponse res = new HttpResponse();
    
            try {
                res = http.send(req);
                System.debug('course success' + res.getBody());
                return res;
                } 
            
            catch(System.CalloutException e) {
                System.debug('Error: '+ e);
                return null;
                }
    }
    
    // generates an 8 alphanumeric random password, which is called when a new student is registered
    public static String passwordgen() {
        Integer len = 8;
		Blob blobKey = crypto.generateAesKey(128);
		String key = EncodingUtil.convertToHex(blobKey);
		String pwd = key.substring(0,len);
		return pwd;      
    }
    
    public void execute(QueueableContext context) {

        for(Lead l : leads)
            {   
                //register new student, assigning the returned Id to a variable
                HttpResponse newStudent = registerStudent(l);
                Map<String, Object> jsonStudentReg = (Map<String, Object>) JSON.deserializeUntyped(newStudent.getBody());
                String studentId = String.valueOf(jsonStudentReg.get('id'));
                
                //check if the returned student Id is not null, write a success message to a variable
                String studentResponse = null;
                if(studentId != null){
                    studentResponse = 'Success: Student Registered';
                }
                
                //if returned student Id is null, write server message to a variable and query all leads to get student Id if already registered
                else{
                    studentResponse = String.valueOf(jsonStudentReg);
                    String studentExistEmail = l.Email;
                    List<Lead> getstudentId = [Select id, BTA_Student_ID__c From Lead Where Email = :studentExistEmail AND BTA_Student_ID__c != NULL LIMIT 1];
                    	if(getstudentId.isEmpty()){
                            studentId = null;
                        }
                        else {
                            studentId = getstudentId.get(0).BTA_Student_ID__c;
                        }
                }
                
                System.debug('studentid: '+ studentId + 'studentresponse:' + studentResponse + 'blockchain course free:'+ l.Blockchain_Free__c + 'blockchain course full:'+ l.Blockchain_Full__c);
                
                //check if Blockchain_Free__c lead field is not null and numeric, ie a course Id should be present
                //register student to a course, assigning the returned message to a variable
                String courseFreeReg = null;
                if(l.Blockchain_Free__c != null && l.Blockchain_Free__c.isNumeric() && studentId != null){
                    System.debug('field blockchain free: '+ l.Blockchain_Free__c);
                    HttpResponse regBlockFree = registerStudentToCourse(studentId, l.Blockchain_Free__c);
                    Map<String, Object> jsonregBlockFree = (Map<String, Object>) JSON.deserializeUntyped(regBlockFree.getBody());
                    courseFreeReg = String.valueOf(jsonregBlockFree.get('message'));
        		}
                
                //check if Blockchain_Full__c lead field is not null and numeric, ie a course Id should be present
                //register student to a course, assigning the returned message to a variable
                String courseFullReg = null;
                if(l.Blockchain_Full__c != null && l.Blockchain_Full__c.isNumeric() && studentId != null){
                    System.debug('field blockchain full: '+ l.Blockchain_Full__c);
                    HttpResponse regBlockFull = registerStudentToCourse(studentId, l.Blockchain_Full__c);                 
                    Map<String, Object> jsonregBlockFull = (Map<String, Object>) JSON.deserializeUntyped(regBlockFull.getBody());
                    courseFullReg = String.valueOf(jsonregBlockFull.get('message'));
        		}
               
               // return messages and Id's have been assigned to variables
               // assign variables and lead Id to a new lead's fields
               Lead newl = new Lead(id = l.id, BTA_Student_Registry_Response__c = studentResponse, BTA_Student_ID__c = studentId, BTA_Course_Free_Registry_Response__c = courseFreeReg, BTA_Course_Full_Registry_Response__c = courseFullReg);
               newleads.add(newl);
            }
        
        update newleads;
    }
}