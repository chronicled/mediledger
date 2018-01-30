pragma solidity 0.4.19;

/**
@title Company Directory
@author Maksym Petkus, Adrian Haensler
@notice Allows network operator to register new companies.
        Companies manage their related data independently.
*/
interface CompanyDirectoryInterface {

  event CompanyRegistered (
    bytes32[] identity_type_urns,
    bytes32[] identity_ids,
    string name,
    bytes32 permissions,
    address owner_address
  );
  event CertificateUpdated (
    bytes32 identity_type_urn,
    bytes32 identity_id, bytes certificate
  );

  event EndpointCreated (
    bytes32 identity_type_urn,
    bytes32 identity_id,
    bytes32 endpoint_id,
    string url
  );
  event EndpointUpdated (
    bytes32 identity_type_urn,
    bytes32 identity_id,
    bytes32 endpoint_id,
    string url
  );

  /**
  @notice Permits execution only to the network operator
  */
  modifier onlyOrg {_;}
  /**
  @notice Permits execution only to an owner of a registered company
  */
  modifier onlyCompany {_;}
  /**
  @notice Permits execution only to an owner of a registered company with the permission
  */
  modifier onlyPermitted (uint8) {_;}

  /**
  @notice Registering a company. All identities must be unique.
  @param _type_urns Company identity type URN array, (e.g. `gs1:company-prefix`)
  @param _ids Company identity value corresponding 1-to-1 to _type_urns
  @param _name Company name
  @param _permissions 256 bits vector of company permission flags
  @param _owner_address blockchain address of initial company administrator
  */
  function register (
    bytes32[] _type_urns,
    bytes32[] _ids,
    string _name,
    bytes32 _permissions,
    address _owner_address
  )
    public
    onlyOrg();

  /**
  @notice Setting new certificate by the company owner.
  @param _certificate_data Certificate data in binary format
  */
  function setCertificate (bytes _certificate_data) public onlyCompany();

  /**
  @notice Change blockchain address of an owner to a new one
  @param _new_owner_address New address of the owner
  */
  function transferOwner (address _new_owner_address) public onlyCompany();

  /**
  @notice Verify if company is registered
  @param _type_urn Company identity type URN
  @param _id Company identity value
  @return {
    "_exists": "true if company with the identity is registered"
  }
  */
  function companyExists (bytes32 _type_urn, bytes32 _id)
    public
    constant
    returns (bool _exists);

  /**
  @notice Get all company information by its identity
  @param _type_urn Company identity type URN
  @param _id Company identity value
  @return {
    "_company_oid": "Company object id, an internal universal identity",
    "_identity_type_urns": "All company's URN identity types",
    "_identity_ids": "All company's identity values corresponding to URN types",
    "_name": "Name of the company",
    "_permissions": "A 256 bit permissions flags vector",
    "_root_certificate": "Company's root certificate data"
  }
  */
  function getCompanyByIdentity (bytes32 _type_urn, bytes32 _id)
    public
    constant
    returns (
      bytes32 _company_oid,
      bytes32[] _identity_type_urns,
      bytes32[] _identity_ids,
      string _name,
      bytes32 _permissions,
      bytes _root_certificate
    );

  /**
  @notice Get total number of registered companies
  @return {
    "_count": "Companies count"
  }
  */
  function getCompaniesCount () public constant returns (uint _count);

  /**
  @notice Get all company information by its identity
  @param _index Index of the company in the directory
  @return {
    "_company_oid": "Company object id, an internal universal identity",
    "_identity_type_urns": "All company's URN identity types",
    "_identity_ids": "All company's identity values corresponding to URN types",
    "_name": "Name of the company",
    "_permissions": "A 256 bit permissions flags vector",
    "_root_certificate": "Company's root certificate data"
  }
  */
  function getCompanyByIndex (uint _index)
    public
    constant
    returns (
      bytes32 _company_oid,
      bytes32[] _identity_type_urns,
      bytes32[] _identity_ids,
      string _name,
      bytes32 _permissions,
      bytes _root_certificate
    );

  /**
  @notice Add new endpoint to the company
  @param _id Unique identifier of an endpoint, e.g. name
  @param _url The url of the endpoint
  */
  function addEndpoint (bytes32 _id, string _url) public onlyCompany();

  /**
  @notice Update existing endpoint of the company
  @param _id Unique identifier of an endpoint, e.g. name
  @param _url New url of the endpoint
  */
  function updateEndpoint (bytes32 _id, string _url) public onlyCompany();

  /**
  @notice Retrieve company's endpoint URL
  @param _identity_type_urn Company identity type URN
  @param _identity_id  Company identity value
  @param _endpoint_id Endpoint identity
  */
  function getEndpointUrl (
    bytes32 _identity_type_urn,
    bytes32 _identity_id,
    bytes32 _endpoint_id
  )
    public
    constant
    returns (string _url);
}
