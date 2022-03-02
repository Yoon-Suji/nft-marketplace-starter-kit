const KryptoBird = artifacts.require("KryptoBird"); //contract name

module.exports = function(deployer) {
    deployer.deploy(KryptoBird);
}