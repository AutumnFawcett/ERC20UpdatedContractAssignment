//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ERC20 {
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


    string public name;
    string public symbol;
    uint8 immutable public decimals;
    uint256 public totalSupply;

    address public owner;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address => uint256)) public allowance;

    constructor(address _owner, string memory _name, string memory _symbol, uint8 _decimals){
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = _owner;

    } 

    function transfer(address to, uint256 value) external returns (bool) {
        
        return _transfer(msg.sender, to, value);
    }

    function _mint(address to, uint256 value) private {
        balanceOf[to] += value;
        totalSupply += value;

        emit Transfer(address(0), to, value);
    }

    function mint(address to, uint256 value) external onlyOwner {
        _mint(to, value);
    }

    function _burn(address from, uint256 value) private {
        require(balanceOf[from]>= value,"ERC20: Insufficient Burn Balance");
        balanceOf[from] -= value;
        totalSupply -= value;

        emit Transfer(from, address(0), value);

    }

    function burn(address from, uint256 value) external onlyOwner {
        _burn(from, value);
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(allowance[from][msg.sender] >= value, "ERC20: Insufficient Allowance"); 
        
        allowance[from][msg.sender] -= value;
        
        emit Approval(from, msg.sender, allowance[from][msg.sender]);

        return _transfer(from, to, value);
    }

    function _transfer(address from, address to, uint256 value) private returns (bool) {
        require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");

        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);

        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] += value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    // ✅ New function: deposit Ether and mint same amount of tokens
    function deposit() external payable {
        require(msg.value > 0, "Must send Ether to deposit");
        _mint(msg.sender, msg.value);
    }

    // ✅ New function: redeem tikens and get back ETH
    function redeem(uint256 amount) external {
        require(allowance[msg.sender][address(this)] >= amount, "Contract not approved to spend tokens");
        require(balanceOf[msg.sender] >= amount, "Not enough tokens");

        // Transfer tokens to the contract
        allowance[msg.sender][address(this)] -= amount;
        _transfer(msg.sender, address(this), amount);

        // Burn the tokens from the contract's balance
        _burn(address(this), amount);

        // Send Eth back to the user
        payable(msg.sender).transfer(amount);
    }

}