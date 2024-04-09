//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PropertyRegistry {
    uint256 constant MAX_PROPERTIES_SHARE = 100;   
    uint256 private property_id=1;
    struct Property {
        string name;
        string location;
        uint256 price;
        uint256 carpet_area;
        uint256 bhk;
        bool furnished;
        uint rent;
        string[] amenities;
        string[] images;
        uint256 owner_contact;
        uint256 propertyid;
        address owner;
    }

    Property[] public properties;
    
    mapping(address => mapping(uint256=>uint256)) public property_share;// address to propertyid to share
    mapping(uint256 => address[]) public property_holders;
    function registerProperty(
        string memory _name,
        string memory _location,
        uint256 _price,
        uint256 _carpet_area,
        uint256 _bhk,
        bool _furnished,
        uint _rent,
        string[] memory _amenities,
        string[] memory _images,
        uint256 _owner_contact

    ) public {
        Property memory newProperty = Property({
            name: _name,
            location: _location,
            price: _price,
            owner: msg.sender,
            carpet_area: _carpet_area,
            bhk: _bhk,
            furnished: _furnished,
            rent: _rent,
            amenities: _amenities,
            images: _images,
            owner_contact: _owner_contact,
            propertyid: property_id
        });

        properties.push(newProperty);
        property_id++;
    }

    function getPropertiesCount() public view returns (uint256) {
        return properties.length;
    }

    function getProperty(uint256 _index)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            bool,
            uint,
            string[] memory,
            string[] memory,
            uint256,
            uint256,
            address
            
        )
    {
        Property storage property = properties[_index];
        return (property.name, property.location, property.price, property.carpet_area, property.bhk, property.furnished, property.rent, property.amenities, property.images, property.owner_contact, property.propertyid, property.owner);
    }
    function getpropertyholders(uint256 _propertyid) public view returns(address[] memory){
        return property_holders[_propertyid];
    }
    function getshare(uint256 _propertyid) public view returns(uint256){
        return property_share[msg.sender][_propertyid];
    }

    function buyProperty(uint256 _index, uint256 _share) public payable {
        require(msg.value == properties[_index].price, "Invalid amount");
        require(_share <= MAX_PROPERTIES_SHARE, "Invalid share");
        require(property_share[msg.sender][_index] == 0, "Already bought");
        property_share[msg.sender][_index] = _share;
        property_holders[_index].push(msg.sender);
    }
}
