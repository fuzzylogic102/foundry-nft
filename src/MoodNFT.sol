// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import "forge-std/console.sol";

contract MoodNFT is ERC721{
    error MoodNFT_CantFlipoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood{
        HAPPY,
        SAD
    }

    mapping(uint256 =>Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN"){
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    function mintNft() public{
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        //only want the NFT owner to be able to change the mood
        if(!_isAuthorized(msg.sender, msg.sender, tokenId)){
            revert MoodNFT_CantFlipoodIfNotOwner();
        }
        if(s_tokenIdToMood[tokenId]==Mood.HAPPY){
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }else{
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory){
        string memory imageURI;

        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            imageURI = s_happySvgImageUri;
            console.log("THIS IS HAPPY");
            console.log(imageURI);
        }else{
                imageURI = s_sadSvgImageUri;
                console.log("THIS IS SAD");
                console.log(imageURI);
            }
        
        //We finally turn everything into a string data type
        return string(
            //We then abi.encode it so the twos trings are now as one
            abi.encodePacked(
                //We call the _baseURI function which returns data:application/json;base64,
                _baseURI(),
                //We encode it using Base64
                Base64.encode(
                    //Then we change it into bytes so we can use open zeppelin Base64 encoder
                    bytes(
                        //First we abi encode the data so we put them together in one big string
                        abi.encodePacked(
                            '{"name": "', 
                            name(), 
                            '", "description":"An NFT that reflects the owners mood.", ',
                            '"attributes":[{"trait_type": "moodiness", "value": 100}], ',
                            '"image":"', 
                            imageURI, //This will print out an image URI and then plug it into the browser to see the SVG image
                            '"}'
                        )
                    )
                )
            )
        );
    } 
}