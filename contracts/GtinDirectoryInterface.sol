pragma solidity 0.4.19;

/**
@title GTIN Directory
@author Maksym Petkus, Adrian Haensler
@notice Companies registered in Company Directory can register their related
        products GTINs and transfer ownership to a third-party.
*/
interface GtinDirectoryInterface {
  event Registered (
    bytes32 gtin,
    bytes32 company_prefix,
    bytes32 endpoint_id
  );

  event Transferred (
    bytes32 gtin,
    bytes32 new_company_prefix,
    bytes32 new_endpoint_id
  );

  event EndpointUpdated (
    bytes32 gtin,
    bytes32 new_endpoint_id    // the endpoint id (in the company directory)]
  );

  /**
  @notice Permits execution only to an owner of a registered company
  */
  modifier onlyCompany {_;}
  /**
  @notice Permits execution only to an owner of the GTIN
  */
  modifier onlyOwner (bytes32 _gtin) {_;}
  /**
  @notice Permits execution only to an owner of a registered company with the permission
  */
  modifier onlyPermitted (uint8 _permission) {_;}


  /**
  @notice Register product's GTIN
  @param _gtin GTIN-13 of the product, must match company's prefix
  @param _endpoint_id Company's endpoint identity to assign
  */
  function register (bytes32 _gtin, bytes32 _endpoint_id)
    public
    onlyPermitted(1);

  /**
  @notice Set a new endpoint identity to the GTIN
  @param _gtin GTIN-13 of the product
  @param _new_endpoint_id Company's endpoint identity to assign
  */
  function updateEndpointId (bytes32 _gtin, bytes32 _new_endpoint_id) // update the last endpoint (created by the owner), an endpoint_id of zero means that it is deleted
    public
    onlyOwner(_gtin);

  /**
  @notice Initiate GTIN transfer to another company by the GTIN owner
  @param _gtin GTIN-13 of the product to transfer
  @param _company_prefix_dest GS1 company prefix of the destination company
  */
  function initTransfer (
    bytes32 _gtin,
    bytes32 _company_prefix_dest
  )
    public
    onlyOwner(_gtin);

  /**
  @notice Accept transfer of GTIN by the destination company
  @param _gtin GTIN-13 of the product to accept
  @param _endpoint_id New company's endpoint identity to assign to the GTIN
  @param _previous_endpoint_url URL of the current GTIN owner company endpoint
          to be saved as a snapshot. Required here due to limitation of Solidity.
  */
  function acceptTransfer (
    bytes32 _gtin,
    bytes32 _endpoint_id,
    string _previous_endpoint_url
  )
    public
    onlyCompany();

  /**
  @notice Retrieve current owner company of the GTIN
  @param _gtin GTIN-13 of the product
  @return {
    "_owner_company_prefix": "GS1 company prefix"
  }
  */
  function getOwner (bytes32 _gtin)
    public
    constant
    returns (bytes32 _owner_company_prefix);

  /**
  @notice Get information about GTIN
  @param _query_gtin GTIN-13 of the product
  @return {
    "_gtin": "GTIN-13 of the product",
    "_owners_count": "Total number of the GTIN owners (previous ones and the current)",
    "_owners_company_prefix": "Company prefixes of all the owners, last one is the current",
    "_current_endpoint_id": "Endpoint identity of the current owner company assigned to the GTIN"
  }
  */
  function get (bytes32 _query_gtin)
    public
    constant
    returns (
      bytes32 _gtin,
      // Convenience for other contracts, since arrays are not accessible
      uint _owners_count,
      bytes32[] _owners_company_prefix,
      bytes32 _current_endpoint_id
    );

  /**
  @notice Get number of registered GTINs
  @return {
    "_total_gtins": "Total number of GTINs"
  }
  */
  function getCount ()
    public
    constant
    returns (uint _total_gtins);

  /**
  @notice Get information about GTIN by the index
  @param _index Index of the GTIN in the Directory
  @return {
    "_gtin": "GTIN-13 of the product",
    "_owners_count": "Total count of the owners in the history of the GTIN",
    "_owners_company_prefix": "GS1 company prefixes of all the owners in the history of GTIN, last is the current owner",
    "_current_endpoint_id": "Endpoint identity of the current owner company assigned to the GTIN"
  }
  */
  function get (uint _index)
    public
    constant
    returns (
      bytes32 _gtin,
      uint _owners_count,
      bytes32[] _owners_company_prefix,
      bytes32 _current_endpoint_id
    );

  /**
  @notice Retrieve endpoint identity of the current owner company of the GTIN
  @param _gtin GTIN-13 of the product
  */
  function getEndpointId (bytes32 _gtin)
    constant
    public
    returns (bytes32);

  /**
  @notice Retrieve endpoint snapshot URL of the previous GTIN owner companies
  @param _gtin GTIN-13 of the product
  @param _owner_index Index of the ownership (0 - manufacturer)
  @return {
    "_endpoint_url": "Endpoint URL snapshot"
  }
  */
  function getPrevEndpointUrl (bytes32 _gtin, uint _owner_index)
    constant
    public
    returns (string _endpoint_url);

  /**
  @notice Update endpoint snapshot URL of the previous owner
  @param _gtin GTIN-13 of the product
  @param _owner_index Index of the ownership (0 - manufacturer)
  @param _endpoint_url New endpoint URL value
  */
  function updatePrevEndpointUrl (bytes32 _gtin, uint _owner_index, string _endpoint_url)
    public
    onlyOwner(_gtin);
}
