# Verifying a SGTIN

*Distributor 1* receives a shipment of returned product. Reselling it as is would be illegal under the DCSCA 2019 law. To comply with the law, the distributor scans each data matrix code (SGTIN, lot number, expiration date) and uses a compatible client to discover and connect to a verification service URL. This client is connected to the permissioned MediLedger Blockchain and performs fast lookups because it maintains a local copy of its state. If the GTIN is not available within the MediLedger blockchain the client tries to connect to various other third-party lookup system (which will result in longer latency).

```
> GtinDirectory.getEndpointId("00006789123456");
  result = "service01"

> GtinDirectory.getOwner("00006789123456");
  result = "0351648"

> getEndpointUrl("gs1:company_prefix", "0351648", "service01");
  result = "https://www.abc-corp.com/verify"

```

The client tries to establish a connection to the verification service's URL (*https://www.abc-corp.com/verify*). The service checks the client's IP address and certificate. A set of custom rules defined by the manufacturer (whitelist, blacklist, etc.) define who has authorization to access the verification service.

After the handshake is completed, the verification service queries the serialization repository. If no external data source is available, the MediLedger lookup service can optionally maintain a serialization database itself. If the given SGTIN, lot number and expiration date is found in the database the service confirms the authenticity of the product.
