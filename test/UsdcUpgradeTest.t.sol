// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "solmate/tokens/ERC20.sol";
import {USDC_Upgrade} from "../src/USDC_Upgrade.sol";

// interface IUpgrade {
//     function upgradeTo(address newImplementation) external;
// }

contract UsdcUpgradeTest is Test {
    // the identifiers of the fork
    uint256 mainnetFork;
    uint256 BLOCK_NUMBER = 18506351; // 6083000 to early...

    // USDC upgrade contract
    USDC_Upgrade usdcUpgrade;
    USDC_Upgrade proxyUsdcUpgrade;
    // IUpgrade usdcProxy;

    // USDC admin account
    bytes32 usdcAdminValue;
    address public constant usdcAdmin =
        0x807a96288A1A408dBC13DE2b1d087d10356395d2;
    address public constant usdcProxyAddress =
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    // address public constant ERC20_USDC =
    //     0xa2327a938Febf5FEC13baCFb16Ae10EcBc4cbDCF;

    // USDC user accounts
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address owner = makeAddr("owner");

    function setUp() public {
        mainnetFork = vm.createFork(vm.envString("MAINNET_RPC_URL"));
        vm.selectFork(mainnetFork);
        // vm.rollFork(BLOCK_NUMBER);
        // usdcProxy = IUpgrade(usdcProxyAddress);

        // Set the owner of the USDC contract to usdcAdmin
        // usdcAdminValue = vm.load(
        //     usdcProxyAddress,
        //     0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b
        // );
        // usdcAdmin = address(uint160(uint256(usdcAdminValue)));
        // usdcAdmin = 0xFcb19e6a322b27c06842A71e8c725399f049AE3a;
        // usdcAdmin = 0x807a96288A1A408dBC13DE2b1d087d10356395d2;

        vm.startPrank(usdcAdmin);
        usdcUpgrade = new USDC_Upgrade();
        vm.stopPrank();
    }

    function testUsdcUpgrade() public {
        vm.startPrank(usdcAdmin);
        bytes memory func = abi.encodeWithSignature(
            "upgradeTo(address)",
            address(usdcUpgrade)
        );
        (bool success, ) = usdcProxyAddress.call(func);
        require(success, "Upgrade failed");
        // usdcProxy.upgradeTo(address(usdcUpgrade));
        vm.stopPrank();
        proxyUsdcUpgrade = USDC_Upgrade(usdcProxyAddress);
        assertEq(proxyUsdcUpgrade.version(), "3");
    }

    function testAllowList() public {
        vm.startPrank(usdcAdmin);
        bytes memory func = abi.encodeWithSignature(
            "upgradeTo(address)",
            address(usdcUpgrade)
        );
        (bool success, ) = usdcProxyAddress.call(func);
        require(success, "Upgrade failed");
        vm.stopPrank();
        vm.startPrank(owner);
        bytes memory data = abi.encodeWithSignature(
            "addToAllowList(address)",
            user1
        );
        (success, ) = usdcProxyAddress.call(data);
        require(success, "Add to allowlist failed");
        // data = abi.encodeWithSignature(
        //     "version()"
        // )
        // uint256 version = adminUpgradeProxy.upgradeToAndCall(address(usdcUpgrade), data);
        vm.stopPrank();

        proxyUsdcUpgrade = USDC_Upgrade(usdcProxyAddress);

        vm.startPrank(user1);
        proxyUsdcUpgrade.mint(1 ether);
        assertEq(proxyUsdcUpgrade.balanceOf(user1), 1 ether);
        vm.stopPrank();
        vm.startPrank(user2);
        proxyUsdcUpgrade.mint(1 ether);
        vm.expectRevert("Caller not in allowlist");
        vm.stopPrank();
    }
}
