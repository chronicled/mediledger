# MediLedger

[MediLedger](https://www.mediledger.com/) is an initiative to create a blockchain-based supply chain solution for the pharmaceutical industry and establish an interoperable platform for the 2023 milestone of [DSCSA](https://www.fda.gov/Drugs/DrugSafety/DrugIntegrityandSupplyChainSecurity/DrugSupplyChainSecurityAct/). The current phase involves developing a blockchain-based solution that enables saleable returns under the 2019 milestone for DSCSA regulation. This document outlines the technical architecture utilized in MediLedger.

## Introduction

The US pharmaceutical supply chain includes manufacturers, repackagers, distributors and dispensers (hospital, pharmacy etc.).  In some cases the dispenser receives the wrong drug, has too much inventory, or has product which cannot be sold, so they send it back to the distributor.

Today, the distributor can resell returned drugs. However, with the new Drug Supply Chain and Security Act (DSCSA) all returns have to be verified before they are saleable. This means that the distributor must use the unique identifiers on the product to verify that the product is valid. If the product is not in the distributor's systems, then the distributor must contact the Marketing Authorization Holder (manufacturer) and request that they verify the authenticity of the product.

The MediLedger system enables an authorized requestor to check the authenticity of a product in milliseconds. To do this, it maintains a decentralized lookup directory. For every product (GTIN), a lookup service address is supplied by the Marketing Authorization Holder (manufacturer). The lookup service checks the SGTIN, lot number and expiration date as well as the requestor's authorization. The product's authenticity is determined from a serialized repository and a response is sent to the requestor.

## Use cases

While every manufacturer maintains a serialized database with valid SGTINs, only few manufacturers track their shipments on an SGTIN-level.
Some proposed solutions are:

1. Distributors establish a local serialized database of received products.
2. Manufacturers share shipped SGTINs with distributors (by means of EPCIS events).
3. Manufacturers share their product repository with a centralized trusted third party.

In many cases these solutions are not feasable because they are incompatible with existing infrastructure.
MediLedger solves the problem by connecting to the manufacturer's existing product repository in a secure and decentralized manner.

The MediLegder solution provides following functions:
1. Distributors can verify the returned products based on SGTIN, lot number and expiration date by connecting directly to the responsible party (manufacturer or repackager).
2. The system is fast enough for a fully automated line.
3. Manufacturers can commission, withdraw, and transfer ownership of GTINs.

## Solution Overview

The MediLedger solution comprises of the following three key components:
1. Blockchain: A private blockchain is used to store a lookup directory between a GTIN and a set of URLs. The URLs for a GTIN can be used to validate an SGTIN associated with the GTIN. The lookup directory is implemented using two smart contracts as described later.
2. Client: The client serves as the interface between industry participants' internal systems and the blockchain. The clients also can interact with each other to query for the status of an SGTIN.
3. Internal systems: These are the manufacturers' internal systems such as SAP and TraceLink. These store confidential information pertaining to the list of SGTINs manufactured by the manufacturer and can be used to verify a particular SGTIN.

The following diagram illustrates the three components as well as the flow of information in two key use cases: transfer of GTIN and validating an SGTIN.

![Solution diagram](Design.png)

#### Smart Contract

The system utilizes the following two smart contracts:

* CompanyDirectory
This smart contract is used to define a directory of companies (manufacturers and distributors). For each company, the directory stores metadata such as:
  * Company Ids: A company can have multiple ids, such as a GTIN prefix
  * Security Certificate: The certificate used to authenticate the company. (X509 / DER format)
  * Lookup service URLs: The URLs to query a manufacturer for the status of a GTIN

* GtinDirectory
This smart contract is used to define a directory of GTINs. For each GTIN, the directory stores metadata such as:
  * Current owner: The manufacturer that currently owns it
  * Creator: The manufacturer that originally created/registered the GTIN
  * Lookup service URLs: A list of all relevant URLs to be used to verify the GTIN. These can span across manufacturers since the GTIN could have been transferred across manufacturers.


## Glossary of key terms

* DSCSA: Drug Supply Chain Security Act
* GTIN: The GTIN is a globally unique 14-digit number used to identify trade items, products, or services. In this case, an example might be a 20 pack of Aspirin.
* SGTIN: Unique identifier for a specific instance of a GTIN product. It consists of the GTIN and unique product identifier.

## Relevant Links

1. [MediLedger Website](https://www.mediledger.com/)
2. [DSCSA](https://www.fda.gov/Drugs/DrugSafety/DrugIntegrityandSupplyChainSecurity/DrugSupplyChainSecurityAct/)


## License

Copyright (C) Chronicled Inc. This project may not be copied, reproduced, or modified without explicit permission of Chronicled. All rights reserved.
