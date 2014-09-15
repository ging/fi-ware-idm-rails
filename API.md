
IDM - REST API - VERSION 1
==================


1. Authentication
-------------------------------------------
In the first place you have to authenticate to get a valid token in the IDM.

Example of success CREATE TOKEN:
```
    client: POST /api/v1/tokens.json?email=XXX@emailservice.com&password=YYY
    Server: status =200, {“token”:”ASDERfsfgewrvsa@#$%5″}
```  
Example of success DELETE TOKEN:
```
    client: DELETE /api/v1/tokens/ASDERfsfgewrvsa@#$%5.json
    Server: status =200, {“token”:”ASDERfsfgewrvsa@#$%5″}
```

Example of error INVALID EMAIL OR PASSWORD:
```
    client: POST /api/v1/tokens.json?email=BADEMAIL@emailservice.com&password=BADPASSWD
    Server: status =401, {"message":"Invalid email or passoword."}
```

Example of error UNAUTHORIZED:
```
    client: GET /organizations.json
    Server: status=401, body={}
```


Once you have a valid token you will be able to access the different resources in the API. All of them present a REST interface with a CRUD options (Create, Read, Update, Delete).

2. Applications API:
--------------------------

| Methods | URL                               | Params                                                                                                                                                                     | Example response |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   | GET /applications.json            |                                                                                                                                                                            |                  |
| CREATE  | POST /applications.json           | application[name]*: Application name application[description]: Application description application[url]*: Application URL application[callback_url]*: Application callback |                  |
| READ    | GET /applications/#{slug}.json    | slug: Slug identifier of the application.                                                                                                                                  |                  |
| UPDATE  | PUT /applications/#{slug}.json    | application[name]*: Application name application[description]: Application description application[url]*: Application URL application[callback_url]*: Application callback |                  |
| DELETE  | DELETE /applications/#{slug}.json | slug: Slug identifier of the application.                                                                                                                                  |                  |



