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

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   | GET /applications.json            |                                                                                                                                                                            |                  |
| CREATE  | POST /applications.json           | application[name]\*: Application name <br>application[description]: Application description <br>application[url]\*: Application URL <br>application[callback_url]\*: Application callback |
| READ    | GET /applications/#{slug}.json    | slug: Slug identifier of the application.                                                                                                                                  |
| UPDATE  | PUT /applications/#{slug}.json    | application[name]\*: Application name <br>application[description]: Application description <br>application[url]\*: Application URL <br>application[callback_url]\*: Application callback |
| DELETE  | DELETE /applications/#{slug}.json | slug: Slug identifier of the application.                                                                                                                                  |
| ADD USER  | POST  /applications/#{slug}/add_user.json | Add a user to the application with a specific role.<br>slug: Slug identifier of the application.<br>actor_slug: Slug identifier of the actor (user or organization).<br>role_id: Identifier of the role.<br>  |



3. Organizations API:
--------------------------

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   | GET /organizations.json            |                                                                                                                                                                            |                  |
| CREATE  | POST /organizations.json           | organization[name]\*: Organization name<br> organization[owners]: Owners list<br>organization[description]: Description<br> |
| READ    | GET /organizations/#{slug}.json    | slug: Slug identifier of the organization.                                                                                                                                  |
| UPDATE  | PUT /organizations/#{slug}.json    | organization[name]*: Organization name<br>organization[owners]: Owners list<br>organization[description]: Description |
| DELETE  | DELETE /organizations/#{slug}.json | slug: Slug identifier of the organization.                                                                                                                                  |



4. Users API:
--------------------------

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   | GET /users.json            |    No soportado (Usar SCIM API)                                                                                                                                                                        |                  |
| CREATE  | POST /users.json           | No soportado (Usar SCIM API) |
| READ    | GET /users/#{slug}.json    | slug: Slug identifier of the user.                                                                                                                                  |
| UPDATE  | PUT /users/#{slug}.json    | user[name]: User name <br>user[password]: User password <br>user[email]: User email |
| DELETE  | DELETE /users/#{slug}.json | slug: Slug identifier of the user.                                                                                                                                  |




