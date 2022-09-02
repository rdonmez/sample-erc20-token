const { expect } = require("chai"); 

describe("Sample Token Contract", function(){
    let tokenName = "Sample";
    let tokenSymbol = "SMPL";
    let tokenDecimals = 18;
    let tokenTotalSupply = 1000000000;

    let deployer;

    it("Deploy and check", async function() {
        [deployer] = await ethers.getSigners();
        
        const SampleTokenFactory = await ethers.getContractFactory("SampleToken");

        SampleToken = await SampleTokenFactory.deploy(tokenName, tokenSymbol, tokenDecimals, tokenTotalSupply);

        expect(await SampleToken.name()).to.equal(tokenName);
    });

    it("check totalSupply for deployer", async function() {
        
        const deployerBalance = await SampleToken.balanceOf(deployer.address);

        expect(await SampleToken.totalSupply()).to.equal(deployerBalance);
    });
    
    it("mint and check balanceOf", async function() {
        
        const mintAmount = 1000000000;

        await SampleToken._mint(deployer.address, mintAmount);

        const deployerBalance = await SampleToken.balanceOf(deployer.address);

        expect(await SampleToken.totalSupply()).to.equal(deployerBalance);
    });

    it("burn and check balanceOf", async function() {
        
        const burnAmount = 500000000;

        await SampleToken._burn(deployer.address, burnAmount);

        const deployerBalance = await SampleToken.balanceOf(deployer.address);

        expect(await SampleToken.totalSupply()).to.equal(deployerBalance);
    });

});