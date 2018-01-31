## Creating ABC Corp

The following code snippets can be used to create and get information for a manufacturer on the blockchain. These use the *CompanyDirectory.sol* smart contract.

#### 1. Register ABC Corp

The MediLedger Blockchain registers new manufacturers with the following function.

```
CompanyDirectory.register(
  ["gs1:company_prefix"],                     // _type_urns
  ["0123"],                                   // _ids
  "ABC Corp",                                 // _name
  1,                                          // _permissions
  0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db  // _owner_address
)
```
The following event is triggered by the successful execution of the function above:

```
CompanyDirectory.CompanyRegistered(
  ["gs1:company_prefix"]                      // identity_type_urns
  ["0123"],                                   // identity_ids
  "ABC Corp",                                 // name
  1,                                          // permissions
  0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db  // owner_address
)
```
#### 2. Set security certificate for ABC Corp

This can only be set by the company that owns the certificate (i.e. ABC Corp this case):
```
CompanyDirectory.setCertificate(_certificate_data)
```
The following event is triggered by the successful execution of the above function:

```
CompanyDirectory.CertificateUpdated(
  "gs1:company_prefix",                       // _id type
  "0123",                                     // _id value
  _certificate_data                           // certificate
)
```

#### 3. Add/Update Endpoint
These functions can only be called by the company that owns the endpoint (i.e. ABC Corp in this case):
```
CompanyDirectory.addEndpoint(
  1,                                          // endpoint id
  "www.abc_corp.com/verifyURL"                // url
)
CompanyDirectory.updateEndpoint(
  1,                                          // endpoint id
  "www.abc_corp.com/updated_verifyURL"        // url
)
```
The following events are triggered by each of the above functions upon successful execution:

```
CompanyDirectory.EndpointCreated(
  "gs1:company_prefix",                       // identity_type_urn
  "0123",                                     // identity_id
  1,                                          // endpoint_id
  "www.abc_corp.com/verifyURL",               // url
)

CompanyDirectory.EndpointUpdated(
  "gs1:company_prefix",                       // identity_type_urn
  "0123",                                     // identity_id
  1,                                          // endpoint_id
  "www.abc_corp.com/updated_verifyURL",       // url
)
```

#### 4. Test whether ABC Corp and endpoint 1 successfully created

```
CompanyDirectory.companyExists("gs1:company_prefix", "0123")     // returns bool

CompanyDirectory.getEndpointUrl("gs1:company_prefix", "0123", 1) // call with identity id, returns "www.abc_corp.com/updated_verifyURL"
```

## 5. Create XYZ Corp

Like step 1, create XYZ Corp on the blockchain. Use the following arguments for this demo script:

XYZ Corp:

| Argument      | Value         |
| ------------- |-------------|
|Company prefix | 0789|
|Name | XYZ Corp |
|Permission| 1 |
|Address| 0xdd870fa1b7c4700f2bd7f44238821c26f7392148 |
|Certificate data| test_data |
|End point url | www.xyz_corp.com/verify   (corresponds to id = 2) |

