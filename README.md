# ERC20UpdatedContractAssignment
This is my 3rd assignment where I am updating my ERC-20 contract to include a Deposit and a Redeem function.

### Assignment: 
 ✍️ Extend my ERC20 contract with two functions: 
 - Deposit: This is a payable fucntion that will mint the exact amount of msg.value in tokens to the sender.
 - Redeem: That is a function that will first use transferFrom to transfer apporved tokens from a user to itself and then implement a private burn function that will burn those tokens. Lastly, the redeem fucntion will transfer the burnt amoun as Ether value back to the sender.

<br>  

#### 🧪 Wrapped Ether contract (WETH)
So what I have done is add two functions to my ERC-20 token contract that let's users "wrap" and "unwrap" Ether(ETH). This means turing ETH into tokens and back again.   

Imagine you give me $10, and I give you 10 points. Later, you give me back 10 points, and I give you back your $10. That's the idea here - but with Ether and ERC-20 tokens!  

<br>

#### 🛠️ Goal: Add These Two Functions  
1. ```deposit()``` – People send ETH to the contract. The contract gives them the same number of tokens.

2. ```redeem()``` – People give the tokens back. The contract destroys (burns) those tokens and sends the ETH back to them.  

<br>

#### 💡 Concepts to Know
- ```msg.value``` → This is the amount of ETH someone sends.
- ```msg.sender```→ This is the address that initiated the contract, called the function, deployed the contract, & often considered the owner.
- ```payable``` → This means the function can receive ETH.
- ```mint()``` → This creates new tokens.
- ```burn()``` → This destroys tokens.
- ```transferFrom()``` → This lets the contract pull tokens from a user, if they approved it first.
- ```approve()``` → Users need to give permission to the contract before it can take their tokens.

  <br>

 #### 📝 What Needs to be written
 ##### 1. deposit() function
- Make it ```external``` and ```payable```.
- Use ```require``` to make sure the user sends more then 0 ETH.
- Mint the same number of tokens as the ETH sent (```msg.value)
- Send those tokens to ```msg.sender``` (the user who sent the ETH).
```
// ✅ New function: deposit Ether and mint same amount of tokens
function deposit() external payable {
        require(msg.value > 0, "Must send Ether to deposit");
        _mint(msg.sender, msg.value);
    }
```

<br>

##### 2. redeem(uint256 amount) function
- Make it ```external```.
- Use ```require``` to check that the user has approved the contract to spend their tokens.
- Also check that the user has enought tokens to redeem.
- Manually decrease the contract's allowance.
- Call ```_transfer()``` to move the tokens from the user to the contract.
- Call ```_burn()``` to destroy those tokens from the contract's balance.
- Finally, use ```payable``` to send the same amount of Ether back to the user.
```
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
```

#### ✅ Summary of Changes:
- Added ```deposit()``` to accept ETH and mint same amount of tokens.
- Added ```redeem()``` to take tokens, burn them, and send ETH back.
- Used internal ```_mint``` and ```_burn``` already in your contract.
- Included ```require()``` checks for safety and clarity.



#### 🏁 THAT'S IT!
I just created a Wrapped Ether (WETH) contract! It's super useful because now ETH behaves like a normal ERC-20 token — easy to send, trade, and use in DeFi apps.



