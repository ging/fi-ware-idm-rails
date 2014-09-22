IDM - REST API - VERSION 1
==================


1. Authentication/Session Token
-------------------------------------------
In the first place you have to authenticate to get a valid token in the IDM.

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| CREATE   | POST /api/v1/tokens.json            |    email\*: User email <br> password\*: User password                                                                                                                                                                        |                  |
| DELETE  | DELETE /api/v1/tokens/{token}.json           | token\*: User Token |


**Example of success CREATE TOKEN:**
```
    request: POST /api/v1/tokens.json?email=XXX@emailservice.com&password=YYY
    response: status=200, {“token”:”cQ9Aqz5ezhU3z6BdH1Ks″}
```  
**Example of success DELETE TOKEN:**
```
    request: DELETE /api/v1/tokens/cQ9Aqz5ezhU3z6BdH1Ks.json
    response: status=200, {“token”:”cQ9Aqz5ezhU3z6BdH1Ks″}
```

**Example of error INVALID EMAIL OR PASSWORD:**
```
    request: POST /api/v1/tokens.json?email=BADEMAIL@emailservice.com&password=BADPASSWD
    response: status=401, {"message":"Invalid email or passoword."}
```

**Example of error UNAUTHORIZED:**
```
    request: GET /organizations.json
    response: status=401, body={}
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


We need a session token before access this API methods. In the following examples we are going to suppose that we have this session token: {"token":"DtDTMSMuntmZgEgwaAhq"}.

**Example of CREATE APPLICATION:**
```
request:
POST /applications.json?auth_token=DtDTMSMuntmZgEgwaAhq
POST params
application[name]: DemoApplication
application[url]: example.com
application[callback_url]: myCallback

response:
{"id":61,"actor_id":140,"slug":"demoapplication-1","name":"DemoApplication","description":null,"url":"example.com","callback":"myCallback","created_at":"2014-09-22T08:27:34Z","updated_at":"2014-09-22T08:27:34Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```  
**Example of success READ Application:**
```
request:
GET /applications/demoapplication-1.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":61,"actor_id":140,"slug":"demoapplication-1","name":"DemoApplication","description":null,"url":"example.com","callback":"myCallback","created_at":"2014-09-22T08:27:34Z","updated_at":"2014-09-22T08:27:34Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

**Example of UPDATE Application:**
```
request:
PUT /applications/demoapplication-1.json?auth_token=DtDTMSMuntmZgEgwaAhq
PUT params
application[name]: DemoApplicationUpdated

response:
{"id":61,"actor_id":140,"slug":"demoapplication-1","name":"DemoApplicationUpdated","description":null,"url":"example.com","callback":"myCallback","created_at":"2014-09-22T08:27:34Z","updated_at":"2014-09-22T08:31:19Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

**Example of INDEX Applications:**
```
request:
GET /applications.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
[{"id":61,"actor_id":140,"slug":"demoapplication-1","name":"DemoApplicationUpdated","description":null,"url":"example.com","callback":"myCallback","created_at":"2014-09-22T08:27:34Z","updated_at":"2014-09-22T08:31:19Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}]
```

**Example of DELETE Application:**
```
request:
DELETE /applications/demoapplication-1.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":61,"actor_id":140,"slug":"demoapplication-1","name":"DemoApplicationUpdated","description":null,"url":"example.com","callback":"myCallback","created_at":"2014-09-22T08:27:34Z","updated_at":"2014-09-22T08:31:19Z","actors":[],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

3. Role Assignment API
--------------------------
| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX (list Actors with roles)   | GET  /applications/#{app_slug}/actors.json            |    app_slug: Slug identifier of the application.                    |
| CREATE (Add actor)  | POST  /applications/#{app_slug}/actors.json           | Add an actor (user or organization) to the application with a specific set of roles. <br> app_slug: Slug identifier of the application.<br> actor_slug: Slug identifier of the actor (user or organization).<br> role_ids: Identifier of the roles.<br> |
| READ    | GET  /applications/#{app_slug}/actors/#{actor_slug}.json | app_slug: Slug identifier of the application.<br>actor_slug: Slug identifier of the actor.<br>  |
| UPDATE  | PUT /applications/#{app_slug}/actors/#{actor_slug}.json     |Change the role assigned to an actor in an application.<br> app_slug: Slug identifier of the application.<br> actor_slug: Slug identifier of the actor (user or organization).<br> role_ids: Identifier of the new roles. |
| DELETE  | DELETE /applications/#{app_slug}/actors/#{actor_slug}.json | app_slug: Slug identifier of the application.<br>actor_slug: Slug identifier of the actor (user or organization)..    |


We need a session token before access this API methods. In the following examples we are going to suppose that we have this session token: {"token":"DtDTMSMuntmZgEgwaAhq"}.
Also, we are also going to suppose that we have the following app:
```
{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

**If we want to add the following user:**
```
	{"id"=>9,  "actor_type"=>"User",  "actor_id"=>9,  "slug"=>"sean-bowman", "name"=>"Sean Bowman",  "created_at"=>Thu, 20 Mar 2014 10:10:08 UTC +00:00,  "updated_at"=>Thu, 20 Mar 2014 10:10:28 UTC +00:00,  "applications"=>  [{"id"=>3,
    "actor_id"=>33,  "slug"=>"in-felis-donec", "name"=>"in felis donec", "description"=>"Donec dapibus. Duis at velit eu est congue elementum.", "url"=>"https://blogpad.edu",
    "callback"=>"https://blogtag.biz/callback", "created_at"=>Thu, 20 Mar 2014 10:10:35 UTC +00:00, "updated_at"=>Thu, 20 Mar 2014 10:10:35 UTC +00:00}], "language"=>nil,
 "organizations"=>[{}, {}, {}, {}, {}, {}, {}, {}, {}]}
 ```
**as Purchaser:**
```
{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"} 
```
```
request:
POST /applications/myapp/actors.json?auth_token=DtDTMSMuntmZgEgwaAhq
POST params
actor_slug: sean-bowman
role_ids: 44
response:
{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"}],"language":null},{"id":9,"actor_type":"User","actor_id":9,"slug":"sean-bowman","name":"Sean Bowman","created_at":"2014-03-20T10:10:08Z","updated_at":"2014-03-20T10:10:28Z","roles":[{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}],"language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

**If we want to READ the roles that the above user has in the previous application:**
```
request:
GET /applications/myapp/actors/sean-bowman.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":9,"actor_type":"User","actor_id":9,"slug":"sean-bowman","name":"Sean Bowman","created_at":"2014-03-20T10:10:08Z","updated_at":"2014-03-20T10:10:28Z","roles":[{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}],"language":null}
```

**If we want to change the role the above user has in the previous application, for instance, to Provider:**
```
request:
PUT /applications/myapp/actors/sean-bowman.json?auth_token=DtDTMSMuntmZgEgwaAhq
PUT params
role_ids: 34
response:
{"id":9,"actor_type":"User","actor_id":9,"slug":"sean-bowman","name":"Sean Bowman","created_at":"2014-03-20T10:10:08Z","updated_at":"2014-03-20T10:10:28Z","roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"}],"language":null}
```

**To get a list of all users with roles in the application:**
```
request:
GET /applications/myapp/actors.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"}],"language":null},{"id":9,"actor_type":"User","actor_id":9,"slug":"sean-bowman","name":"Sean Bowman","created_at":"2014-03-20T10:10:08Z","updated_at":"2014-03-20T10:10:28Z","roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"}],"language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

**Finally, to remove a user from the application:**
```
request:
DELETE /applications/myapp/actors/sean-bowman.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":9,"actor_type":"User","actor_id":9,"slug":"sean-bowman","name":"Sean Bowman","created_at":"2014-03-20T10:10:08Z","updated_at":"2014-03-20T10:10:28Z","roles":[],"language":null}
```

4. Custom Roles API:
--------------------------

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   |            |       Access an application to get a list of its roles.<br>GET /applications.json                                                                                                                                                                     |                  |
| CREATE  | POST /roles.json   | role[name]\*: Role name<br>role[app_id]: App id or role[app_slug]: App slug |
| READ    | GET /roles/#{id}.json    | id: Role id.                                                                                                                                  |
| UPDATE  | PUT /roles/#{id}.json    | id: Role id<br>role[name]\*: Role name<br>role[app_id]: App id or role[app_slug]: App slug |
| DELETE  | DELETE /roles/#{id}.json | id: Role id.    |


We need a session token before access this API methods. In the following examples we are going to suppose that we have this session token: {"token":"DtDTMSMuntmZgEgwaAhq"}.
Also, we are also going to suppose that we have the following app:
```
{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z","actors":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}],"roles":[{"id":34,"actor_id":null,"type":"Relation::Manager","name":"Provider","created_at":"2014-03-20T10:10:35Z","updated_at":"2014-03-20T10:10:35Z"},{"id":44,"actor_id":null,"type":"Relation::Purchaser","name":"Purchaser","created_at":"2014-03-20T10:38:16Z","updated_at":"2014-03-20T10:38:16Z"}]}
```

**Create a new/custom role for the above application:**
```
request:
	POST /roles.json?auth_token=DtDTMSMuntmZgEgwaAhq
POST params
role[name]: MyCustomRole
role[app_slug]: myapp
response:
{"id":101,"actor_id":141,"type":"Relation::Custom","name":"MyCustomRole","created_at":"2014-09-22T09:04:56Z","updated_at":"2014-09-22T09:04:56Z"}
```

**To read the above role:**
```
request:
	GET /roles/101.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":101,"actor_id":141,"type":"Relation::Custom","name":"MyCustomRole","created_at":"2014-09-22T09:04:56Z","updated_at":"2014-09-22T09:04:56Z"}
```

**To update the above role:**
```
request:
	PUT /roles/101.json?auth_token=DtDTMSMuntmZgEgwaAhq
PUT params
role[name]: MyCustomRoleUpdated
response:
{"id":101,"actor_id":141,"type":"Relation::Custom","name":"MyCustomRoleUpdated","created_at":"2014-09-22T09:04:56Z","updated_at":"2014-09-22T09:08:16Z"}
```

**Delete the role:**
```
request:
	DELETE /roles/101.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":101,"actor_id":141,"type":"Relation::Custom","name":"MyCustomRoleUpdated","created_at":"2014-09-22T09:04:56Z","updated_at":"2014-09-22T09:08:16Z"}
```





5. Organizations API:
--------------------------

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   | GET /organizations.json            |                                                                                                                                                                            |                  |
| CREATE  | POST /organizations.json           | organization[name]\*: Organization name<br> organization[owners]: Owners list<br>organization[description]: Description<br> |
| READ    | GET /organizations/#{slug}.json    | slug: Slug identifier of the organization.                                                                                                                                  |
| UPDATE  | PUT /organizations/#{slug}.json    | organization[name]\*: Organization name<br>organization[owners]: Owners list<br>organization[description]: Description |
| DELETE  | DELETE /organizations/#{slug}.json | slug: Slug identifier of the organization.                                                                                                                                  |

We need a session token before access this API methods. In the following examples we are going to suppose that we have this session token: {"token":"DtDTMSMuntmZgEgwaAhq"}.

**Create a new organization:**
The default owner is the user who make the request. To specify additional owners use the organization[owners] param.
```
request:
	POST /organizations.json?auth_token=DtDTMSMuntmZgEgwaAhq
POST params
organization[name]: MyDemoOrganization
response:
{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganization","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:28:07Z","applications":[],"members":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}]}
```



**Create a new organization with more owners. In this case we have to fill the owners list with the actor ids of the users.**
```
request:
	POST /organizations.json?auth_token=DtDTMSMuntmZgEgwaAhq
POST params
organization[name]: OrganizationWithSeveralOwners
organization[owners]: 9,135
response:
{"id":33,"actor_type":"Group","actor_id":151,"slug":"organizationwithseveralowners","name":"OrganizationWithSeveralOwners","created_at":"2014-09-22T09:34:32Z","updated_at":"2014-09-22T09:34:32Z","applications":[],"members":[{"id":9,"actor_type":"User","actor_id":9,"slug":"sean-bowman","name":"Sean Bowman","created_at":"2014-03-20T10:10:08Z","updated_at":"2014-03-20T10:10:28Z","language":null},{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}]}
```

**Read a organization:**
```
request:
        GET /organizations/mydemoorganization.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganization","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:28:07Z","applications":[],"members":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}]}
```

**Update a organization:**
```
request:
        PUT /organizations/mydemoorganization.json?auth_token=DtDTMSMuntmZgEgwaAhq
	PUT params
organization[name]: MyDemoOrganizationUpdated
response:
{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganizationUpdated","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:37:59Z","applications":[],"members":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}]}
```

**Delete a organization:**
```
request:
DELETE /organizations/organizationwithseveralowners.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":33,"actor_type":"Group","actor_id":151,"slug":"organizationwithseveralowners","name":"OrganizationWithSeveralOwners","created_at":"2014-09-22T09:34:32Z","updated_at":"2014-09-22T09:34:32Z","applications":[],"members":[]}
```

**Index organizations:**
```
request:
GET /organizations.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
[{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganizationUpdated","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:37:59Z","applications":[],"members":[{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","language":null}]}]
```

6. Users API:
--------------------------

| Methods | URL                               | Params                                                                                                                                                                     |
|---------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| INDEX   | GET /users.json            |    No soportado (Usar SCIM API)                                                                                                                                                                        |                  |
| CREATE  | POST /users.json           | No soportado (Usar SCIM API) |
| READ    | GET /users/#{slug}.json    | slug: Slug identifier of the user.                                                                                                                                  |
| UPDATE  | PUT /users/#{slug}.json    | user[name]: User name <br>user[password]: User password <br>user[email]: User email |
| DELETE  | DELETE /users/#{slug}.json | slug: Slug identifier of the user.                                                                                                                                  |

We need a session token before access this API methods. In the following examples we are going to suppose that we have this session token: {"token":"DtDTMSMuntmZgEgwaAhq"}.


**Read a user:**
```
request:
	GET /users/demo-2.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"Demo","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T08:04:39Z","applications":[{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z"}],"language":null,"organizations":[{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganizationUpdated","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:37:59Z"}]}
```

**Update a user:**
```
request:
	PUT /users/demo-2.json?auth_token=DtDTMSMuntmZgEgwaAhq
	PUT params
	user[name]: DemoUpdated
response:
{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"DemoUpdated","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T09:48:23Z","applications":[{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z"}],"language":null,"organizations":[{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganizationUpdated","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:37:59Z"}]}
```

**Delete a user (only authorized for admins).**
```
request:
	DELETE /users/demo-2.json?auth_token=DtDTMSMuntmZgEgwaAhq
response:
{"id":26,"actor_type":"User","actor_id":135,"slug":"demo-2","name":"DemoUpdated","created_at":"2014-09-22T08:04:39Z","updated_at":"2014-09-22T09:48:23Z","applications":[{"id":62,"actor_id":141,"slug":"myapp","name":"MyApp","description":null,"url":"myURL","callback":"myCallback","created_at":"2014-09-22T08:35:47Z","updated_at":"2014-09-22T08:35:47Z"}],"language":null,"organizations":[{"id":29,"actor_type":"Group","actor_id":147,"slug":"mydemoorganization","name":"MyDemoOrganizationUpdated","created_at":"2014-09-22T09:28:07Z","updated_at":"2014-09-22T09:37:59Z"}]}
```


