// SPDX-License-Identifier: MIT 

pragma solidity^0.8.20 ;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import "forge-std/console.sol";

contract DeployMoodNFT is Script{

    function run() external returns (MoodNFT){
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");
        console.log("SAD");
        console.log(sadSvg);
        console.log("HAPPY");
        console.log(happySvg);
        vm.startBroadcast();
        MoodNFT moodNft = new MoodNFT(svgToImageURI(sadSvg), svgToImageURI(happySvg));
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory){
        //example
        //It takes: <svg width="1024px" height="10.........
        //It returns: data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwM
        //Now we don't have to use the terminal everytime and write Base64 -i fileName
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}