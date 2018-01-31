## Transfer ownership of GTIN 1 from ABC Corp to XYZ Corp

#### 1. Initiate transfer by ABC Corp

Only ABC Corp (i.e. the current owner of GTIN 1) can initiate the transfer.

```
  GtinDirectory.initTransfer(
    "00006789123456",                                     // gtin
    "0788"                                                // prefix of XYZ Corp
  )
```

#### 2. Accept transfer by XYZ Corp

Only XYZ Corp (i.e. the destination company) can accept the transfer. Moreover, XYZ Corp should own the endpoint ID supplied below.

```
  GtinDirectory.acceptTransfer(
    "00006789123456",                                     // gtin
    2,                                                    // endpoint ID owned by XYZ Corp
    "www.abc_corp.com/updated_verifyURL"                  // endpoint URL of previous owner
  )
```

Successful execution triggers the following event.

```
  GtinDirectory.Transferred(
    "00006789123456",                                     // gtin
    "0788",                                               // new company prefix
    2                                                     // new endpoint id
  )
```
