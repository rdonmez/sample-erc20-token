// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool success);
    function transferFrom(address from, address to, uint256 amount) external returns (bool success);
    function approve(address spender, uint256 amount) external returns (bool success);
    function allowance(address owner, address spender) external view returns (uint256 remaining);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}

contract SampleToken is IERC20 {

    address public _owner;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) allowances;
 
    modifier onlyOwner {
        require(_owner == msg.sender, "caller is not the owner");
        _;
    }
 
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
        _owner = msg.sender;
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _mint(_owner, totalSupply_);
    }

    function _mint(address account, uint256 amount) public onlyOwner returns (bool) {
        require(account != address(0), "ERC20: mint to the zero address");
 
        unchecked {
            balances[account] += amount;
            _totalSupply += amount;
        }

        emit Transfer(address(0), account, amount);

        return true;
    }

    function _burn(address account, uint256 amount) public onlyOwner returns (bool) {
        require(account != address(0), "ERC20: burn to the zero address");

        uint256 accountBalance = balances[account];
        require(accountBalance >= amount, "Account does not have enough token");
        
        unchecked {
            balances[account] -= amount;
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
        
        return true;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function transfer(address to, uint256 amount) external returns (bool success) {
        require(address(to) != address(0), "to address cannot be zero");
        
        address from = msg.sender;
        uint256 fromBalance = balances[from];
        require(fromBalance >= amount, "You don't have enough token");
        
        unchecked {
            balances[from] -= amount;
            balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool success) {
        require(address(from) != address(0), "from address cannot be zero");
        require(address(to) != address(0), "to address cannot be zero");

        uint256 allowed = allowances[from][msg.sender];

        require(allowed >= amount, "unsufficient amount");

        allowances[from][msg.sender] = allowed - amount;
        emit Approval(from, msg.sender, allowed - amount);

        uint256 fromBalance = balances[from];
        require(fromBalance >= amount, "From address does not have enough token");
        
        unchecked {
            balances[from] -= amount;
            balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool success) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    

    function allowance(address owner, address spender) external view returns (uint256 remaining) {
        return allowances[owner][spender];
    }
}