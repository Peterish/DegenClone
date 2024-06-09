// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

    error NotEnoughDegen(string message, uint requiredAmount);

contract DegenClone is ERC20, Ownable {

    enum RedeemItems { Missile, Drone, Chopper, RPG }

    constructor() ERC20("Degen", "DGN")Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function TransferDegen(address to, uint256 amount) external returns(bool success){
        if(amount < balanceOf(msg.sender)){
            revert NotEnoughDegen("Degen Token not enough", amount);
        }
    success = transfer(to, amount);
    }

    function burn(uint256 amount) external {
        if(amount < balanceOf(msg.sender)){
            revert NotEnoughDegen("Degen Token not enough", amount);
        }
        _burn(msg.sender, amount);
    }

    function redeemItems(RedeemItems item) external {
        uint256 price = 0;
        if (item == RedeemItems.Missile) {
            price = 4 *1e18;
        } else if (item == RedeemItems.Drone) {
            price = 3 *1e18;
        } else if (item == RedeemItems.Chopper) {
            price = 2 *1e18;
        } else if (item == RedeemItems.RPG) {
            price = 1 *1e18;
        }else{
            price = 0;
        }

        if(price > balanceOf(msg.sender)){
            revert NotEnoughDegen("Degen Token not enough", price);
        }
        _transfer(msg.sender, address(this), price);
    }

    function withdrawFunds()external onlyOwner{
        _transfer(address(this), msg.sender, balanceOf(address(this)));

    }

    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}