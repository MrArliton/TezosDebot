pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "include.sol";

contract AuthDebot is Debot {

    string node = "https://testnet-tezos.giganode.io";
    bytes m_icon;

    function start() public override {
        _startMenu();
    }
    /// @notice Returns Metadata about DeBot.
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "";
        version = "0.1.1";
        publisher = "Tyler's teams";
        key = "Interaction with tezos wallet";
        author = "Tyler's teams";
        support = address.makeAddrStd(0,0x841288ed3b55d9cdafa806807f02a0ae0c169aa5edfe88a789a6482429756a94);
        hello = "Hello. I help you to interract with Tezos wallet.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID, 
            Network.ID, Base64.ID, UserInfo.ID, SigningBoxInput.ID  ];
    }

    function _startMenu() private inline {
   
        Menu.select("Main Menu", "What do you want to do?", [
            MenuItem("Get balance", "", tvm.functionId(get_B)),
            MenuItem("Make transaction","",tvm.functionId(menuTransaction)),
            MenuItem("Choose tezos node","",tvm.functionId(set_N))
        ]);
    }


    function get_B(uint32 index) public{ // Get Balance
     Terminal.input(tvm.functionId(getHash_B),"Write hash of wallet:",false);
    }
    function getHash_B(string value) public{
        string path = node+"/chains/main/blocks/head/context/contracts/"+value+"/balance";
        Network.get(tvm.functionId(getResponse_B),path,['']);
    }
    function getResponse_B(int32 statusCode, string[] retHeaders, string content) public{
        retHeaders;
        content;
        //
        bytes balance = new bytes(bytes(content).length-2);
        for(uint i = 1;i<bytes(content).length-1;i++){
            balance[i] = bytes(content)[i];
        }
        if (statusCode == 200) {
            Terminal.print(0,"Balance:"+string(balance)+"microtez");
        } else {
            Terminal.print(0,"Error :( We can\'t get balance.");
        }
    }
    function menuTransaction(uint32 index) public{
        Terminal.print(0, "Transact");
    }
    function set_N() public{

    }
    
}
