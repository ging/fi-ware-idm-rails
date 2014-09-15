
IDM - REST API
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


Once you have a valid token you will be able to access the different resources in the API. All of them present a REST interface

2. Applications API:
--------------------------

Index of applications:
```
    client: GET /applications.json?auth_token=yEA7ndmSsg2xQz8ypAat
    Server: status = 200, [{"id":2,"name":"my_first_app","description":"kike kike","url":"http://myfirstapp.fiware.eu"},{"id":3,"name":"my_second_app","description":"description provided","url":"http://mysecondapp.fiware.org"}]
```

Show one application:
```
    client: GET /applications/2.json?auth_token=yEA7ndmSsg2xQz8ypAat
    Server: status = 200, {"id":2,"name":"my_first_app","description":"kike kike","url":"http://myfirstapp.fiware.eu"}
```
