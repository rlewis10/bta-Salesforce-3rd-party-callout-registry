@isTest global class btaRegisterStudentMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{email=test@test.com, first_name=BTA, id=7234, last_name=Test}');
        response.setStatusCode(200);
        return response; 
    }
}