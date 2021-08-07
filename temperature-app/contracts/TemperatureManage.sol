pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract TemperatureManage {
    
    uint public tempCount = 0;

    struct Temp {
        int tempCel;
        string location;
        int long;
        int lat;
        string date;
    }

    mapping(uint => Temp) public temperatures;
    
    event TempStored(
        int tempCel,
        string location,
        int long,
        int lat,
        string date,
        uint id
    );
    
    function storeTemp(
        int _tempCel, 
        string memory _location, 
        int _long, 
        int _lat, 
        string memory _date
    ) public {
        Temp memory temp = Temp(_tempCel, _location, _long, _lat, _date);
        temperatures[tempCount] = temp;
        uint id = tempCount;
        tempCount++;
        emit TempStored(_tempCel, _location, _long, _lat, _date, id);
    }

    function retrieveTemp() public view returns (Temp[] memory) {
        Temp[] memory temps = new Temp[](tempCount);
        
        for (uint i = 0; i < tempCount; i++) {
            temps[i] = temperatures[i];
        }

        return temps;
    }

}