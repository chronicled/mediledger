# Smart Contract Example
The following steps give an example of using the smart contracts to perform the following steps:
1. Create 2 manufacturers (ABC Corp, XYZ Corp) and set security certificates and end point urls for each of them
2. Enable ABC Corp to create GTIN 1 and link it to an end point owned by ABC Corp
3. Enable a user to lookup the end points associated with GTIN 1
4. Enable ABC Corp to transfer ownership of GTIN 1 to XYZ Corp

## 1. Create ABC Corp

The following code snippets can be used to create and get information for an organization (manufacturer, distributor, and dispenser) on the blockchain. These use the CompanyDirectory smart contract.

#### 1.1 Register ABC Corp

The following function can only be called by the central utility. The central utility decides which industry participants are members of the private blockchain and what their respective permissions are. The central utility maybe replaced by smart contracts in the future.

```
//CompanyDirectory.sol

register  (
  ["gs1:company_prefix"]                      //_id types
  ["0123"],                                   //_id values
  "ABC Corp",                             //_name
  1,                                          //_permissions
  0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db  //_owner_address on blockchain
)
```
The following event is triggered by the successful execution of the function above:

```
//CompanyDirectory.sol

CompanyRegistered (
  ["gs1:company_prefix"]                      //_id types
  ["0123"],                                   //_id values
  "ABC Corp",                             //_name
  1,                                          //_permissions
  0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db  //_owner_address
)
```
#### 1.2 Set security certificate for ABC Corp

This can only be set by the company that owns the certificate (i.e. ABC Corp this case):
```
//CompanyDirectory.sol

setCertificate ( _certificate_data )
```
The following event is triggered by the successful execution of the function above:

```
CertificateUpdated (
  "gs1:company_prefix",                       //_id type
  "0123",                                     //_id value
  _certificate_data                           //certificate
)
```

#### 1.3 Add/Update Endpoint
These functions can only called by the company that owns the endpoint (i.e. ABC Corp this case):
```
//CompanyDirectory.sol

addEndpoint (
  1,                                          //end point id
  "www.abc_corp.com/verifyURL"           //url

updateEndpoint (
  1,                                          //end point id
  "www.abc_corp.com/updated_verifyURL"   //url
)
```
The following events are triggered by each of the above functions upon successful execution:

```
//CompanyDirectory.sol

EndpointCreated (
  "gs1:company_prefix",                       //_id type
  "0123",                                     //_company_prefix
  1,                                          //end point id
  "www.abc_corp.com/verifyURL",               //end point url
)

EndpointUpdated (
  "gs1:company_prefix",                       //_id type
  "0123",                                     //_company_prefix
  1,                                          //end point id
  "www.abc_corp.com/updated_verifyURL",       //end point url
)
```

#### 1.4 Test whether ABC Corp and endpoint 1 successfully created

```
//CompanyDirectory.sol

companyExists ( "gs1:company_prefix", "0123" )  //returns bool

getEndpointUrl ( "gs1:company_prefix", "0123", 1 ) //call with end point id, returns "www.abc_corp.com/updated_verifyURL"

```

## 2. Create XYZ Corp

Like step 1, create XYZ Corp and distributor 1 on the blockchain. Use the following arguments for this demo script:

XYZ Corp:

```
Company prefix: "0789"
Name: "XYZ Corp"
Permission: 1
Address: 0xdd870fa1b7c4700f2bd7f44238821c26f7392148
Certificate data: test_data
End point url: "www.xyz_corp.com/verify"   (corresponds to id = 2)
```

## 3. Register GTIN 1

The GTIN is registered to the manufacturer (i.e. ABC Corp in this case) who calls the function.

```
//GtinDirectory.sol

register  (
  "00006789123456",                           // gtin
  1,                                          // endpoint id
)
```
The following event is triggered by the successful execution of the function above:

```
Registered (
  "00006789123456",                           //GTIN
  "0123",                                     //company prefix of ABC Corp  1,                                          // endpoint id
)
```

## 4. Look up url for GTIN 1

```
//GtinDirectory.sol

endpoint_id = getEndpointId( "00006789123456" );              //gtin

owner_prefix = getOwner( "00006789123456" );

url = getEndpointUrl( "gs1:company_prefix", owner_prefix, endpoint_id )

```

## 5. Transfer ownership of GTIN 1 from ABC Corp to XYZ Corp

#### 5.1 Initiate transfer by ABC Corp

Only ABC Corp (i.e. the current owner of GTIN1) can initiate the transfer.

```
//GtinDirectory.sol

  initTransfer (
    "00006789123456",                                     // gtin
    "0788"                                                // prefix of XYZ Corp
  )
```

#### 5.2 Accept transfer by XYZ Corp

Only XYZ Corp (i.e. the destination company) can accept the transfer. Moreover, XYZ Corp should own the end point id supplied below.

```
//GtinDirectory.sol

  acceptTransfer (
    "00006789123456",                                     // gtin
    2,                                                     // end point id owned by XYZ Corp
    "www.abc_corp.com/updated_verifyURL"              //endpoint url of previous owner
  )
```

Successful execution triggers the following event:

```
  Transferred(
    "00006789123456",                                     // gtin
    "0788",                                               // new owner
    2                                                     // new endpoint id
  )
```
