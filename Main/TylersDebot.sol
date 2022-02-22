pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "include.sol";

contract AuthDebot is Debot {
    // Node
    string[] nodes = ["https://testnet-tezos.giganode.io",
 //   "https://mainnet-node.madfish.solutions",
    "https://mainnet.smartpy.io",
    "https://rpc.tzbeta.net",
    "https://mainnet.api.tez.ie",
    "https://granadanet.smartpy.io",
    "https://hangzhounet.smartpy.io"
    //,"https://rpc.tzkt.io/idiazabalnet"
   ];
    uint32 idNode = 0;
    bytes m_icon;
    //Transaction
    string s_hash_wallet= "";
    string d_hash_wallet = "";
    string private_key = "";
    string value_t = "";
    function start() public override {
        _startMenu();
    }
    /// @notice Returns Metadata about DeBot.
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Tyler";
        version = "0.1.3";
        publisher = "Tyler's team";
        key = "Interaction with Tezos Wallet";
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
        Terminal.print(0,"Selected node:\""+nodes[idNode]+"\"");
        Menu.select("Main Menu", "What do you want to do?", [
            MenuItem("Get balance", "", tvm.functionId(get_B)),
            MenuItem("Make transaction","",tvm.functionId(menuTransaction)),
            MenuItem("Choose tezos node","",tvm.functionId(set_Net))
        ]);
    }

    //GetBalance
    function get_B(uint32 index) public{ // Get Balance
     Terminal.input(tvm.functionId(getHash_B),"Write hash of wallet:",false);
    }
    function getHash_B(string value) public{
        string path = nodes[idNode]+"/chains/main/blocks/head/context/contracts/"+value+"/balance";
        Network.get(tvm.functionId(getResponse_B),path,['']);
    }
    function getResponse_B(int32 statusCode, string[] retHeaders, string content) public{
        retHeaders;
        content;
        //
        if (statusCode == 200) {
            Terminal.print(0,"Balance:"+content+"microtez");
        } else {
            Terminal.print(0,"Error :( We can\'t get balance.");
        }
        _startMenu();
    }
    //Transaction
    function menuTransaction(uint32 index) public{
        Terminal.input(tvm.functionId(setS_Hash),"Write hash of your wallet:",false);
        Terminal.input(tvm.functionId(setP_Key),"Write private key of your wallet:",false);
        Terminal.input(tvm.functionId(setD_Hash),"Write hash of target wallet:",false);
        Terminal.input(tvm.functionId(setW_Hash),"Write value of TEZ for transaction:",false);
    }
    function setS_Hash(string value) public{
        s_hash_wallet = value;
         Terminal.print(0,s_hash_wallet);
    }
    function setP_Key(string value) public{
        d_hash_wallet = value;
        Terminal.print(0,d_hash_wallet);
    }
    function setD_Hash(string value) public{
        private_key = value;
        Terminal.print(0,private_key);
    }
    function setW_Hash(string value) public{
        value_t = value;
        Terminal.print(0,value_t);
    }
    //Node
    function set_Net() public{
            Menu.select("Node Selector", "Select node:", [
            MenuItem( "https://testnet-tezos.giganode.io", "",tvm.functionId(set_Node)),
            MenuItem("https://mainnet-node.madfish.solutions","", tvm.functionId(set_Node)),
            MenuItem( "https://mainnet.smartpy.io","", tvm.functionId(set_Node)),
            MenuItem("https://rpc.tzbeta.net","", tvm.functionId(set_Node)),
            MenuItem("https://mainnet.api.tez.ie","", tvm.functionId(set_Node)),
            MenuItem("https://granadanet.smartpy.io","", tvm.functionId(set_Node)),
            MenuItem("https://hangzhounet.smartpy.io","", tvm.functionId(set_Node)),
            MenuItem("https://rpc.tzkt.io/idiazabalnet","", tvm.functionId(set_Node))
        ]);
    }
    function set_Node(uint32 index) public {
        idNode = index;
        _startMenu();
    }
    
}
