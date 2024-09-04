# Essbase Client Wallet Rotation
Script to automate Essbase Client Wallet Rotation


### Needs:

- Test Connection 
>> - [Essbase Documentation for Testing with Swagger](https://docs.oracle.com/en/database/other-databases/essbase/21/essrt/quick-start.html) 

### TODOS:

- Authentication for OAuth (See Documentation Below)
>> * [Authenticate REST API for Oracle Essbase](https://docs.oracle.com/en/database/other-databases/essbase/21/essrt/authenticate.html#:~:text=You%20access%20Oracle%20Essbase%20REST%20resources%20over%20HTTPS%2C,the%20base64-encoding%20of%20%3Cusername%3E%3A%3Cpassword%3E%2C%20specified%20in%20the%20format%3A)
>> * [Using OAuth 2 to Access the Rest API](https://docs.oracle.com/en-us/iaas/Content/Identity/api-getstarted/OATOAuthClientWebApp.htm)
>> * [Create Confidential IDCS Application Documentation](https://docs.oracle.com/en/database/other-databases/essbase/19.3/essad/create-confidential-identity-cloud-service-application.html)
        
>>- [Add Confidential Application](https://docs.oracle.com/en/cloud/paas/identity-cloud/uaids/add-confidential-application.html)


- Catergorize Connection Type to grab correct wallet
- Refactor Upload Wallet Function - change to Update call with EOF