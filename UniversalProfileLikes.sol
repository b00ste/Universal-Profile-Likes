// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.7;


import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * This smart contract provides a way to add likes
 * to a universal profile using another universal profile.
 *
 * @title UniversalProfileLikes
 * @author B00ste
 * @custom:verson 0.1
 */
contract UniversalProfileLikes {

    // Defining the address set.
    using EnumerableSet for EnumerableSet.AddressSet;

    /**
     * @notice This set will be used to store all addresses that have likes.
     */
    EnumerableSet.AddressSet private universalProfileAddresses;

    /**
     * @notice This mapping will store a number of likes attached to an address.
     */
    mapping (address => uint256) private universalProfileLikes;

    /**
     * @notice This mapping will store the Universal Profiles liked by an Universal Profile.
     */
    mapping (address => EnumerableSet.AddressSet) private likedUniversalProfiles;

    /**
     * @notice This mapping will store the Universal Profiles that liked an Universal Profile.
     */
    mapping (address => EnumerableSet.AddressSet) private likedByUniversalProfiles;
    
    /**
     * @notice Saving an Universal Profile to the data structure `universalProfileAddresses`.
     *
     * @param universalProfileAddress The address that is to be added from the data structure.
     */
    function _addAddress(address universalProfileAddress) internal {
        universalProfileAddresses.add(universalProfileAddress);
    }
    
    /**
     * @notice Removing an Universal Profile from the data structure `universalProfileAddresses`.
     *
     * @param universalProfileAddress The address that is to be removed from the data structure.
     */
    function _removeAddress(address universalProfileAddress) internal {
        universalProfileAddresses.remove(universalProfileAddress);
    }

    /**
     * @notice Getter for the `universalProfileAddresses`.
     */
    function getUniversalProfileAddresses() external view returns(address[] memory) {
        return universalProfileAddresses.values();
    }

    /**
     * @notice Increase the number of likes of an Universal Profile by 1.
     *
     * @param universalProfileAddress The address of the Universal Profile that has a number of likes.
     */
    function _increaseLikes(address universalProfileAddress) internal {
        universalProfileLikes[universalProfileAddress] ++;
    }

    /**
     * @notice Decrease the number of likes of an Universal Profile by 1.
     *
     * @param universalProfileAddress The address of the Universal Profile that has a number of likes.
     */
    function _decreaseLikes(address universalProfileAddress) internal {
        universalProfileLikes[universalProfileAddress] --;
    }

    /**
     * @notice Getter for the `universalProfileLikes`.
     *
     * @param universalProfileAddress The address of the Universal Profile that has a number of likes.
     * @return The number of likes belonging to `universalProfileAddress` will be returned.
     */
    function getUniversalProfileLikes(address universalProfileAddress) external view returns(uint256) {
        return universalProfileLikes[universalProfileAddress];
    }

    /**
     * @notice Adding an Universal Profile to his list of liked Universal Profiles
     * and adding an Universal Profile to the list of Universal Profiles that liked an Universal Profile.
     * Profile.
     *
     * @param universalProfileAddress The address of the Universal Profile that liked another Universal Profile.
     * @param likedUniversalProfileAddress The address of an Universal Profile that is to be liked.
     */
    function _addToLikedAddresses(
        address universalProfileAddress,
        address likedUniversalProfileAddress
    ) internal {
        likedUniversalProfiles[universalProfileAddress].add(likedUniversalProfileAddress);
        likedByUniversalProfiles[likedUniversalProfileAddress].add(universalProfileAddress);
    }

    /**
     * @notice Removing an Universal Profile to his list of liked Universal Profiles
     * and removing an Universal Profile to the list of Universal Profiles that liked an Universal Profile.
     *
     * @param universalProfileAddress The address of the Universal Profile that liked another Universal Profile.
     * @param likedUniversalProfileAddress The address of an Universal Profile that is to be liked.
     */
    function _removeFromLikedAddresses(
        address universalProfileAddress,
        address likedUniversalProfileAddress
    ) internal {
        likedUniversalProfiles[universalProfileAddress].remove(likedUniversalProfileAddress);
        likedByUniversalProfiles[likedUniversalProfileAddress].remove(universalProfileAddress);
    }

    /**
     * @notice Getter for the list of Universal Profiles are liked by an Universal Profile.
     *
     * @param universalProfileAddress The address of Universal Profile.
     * @return A list of Universal Profiles liked by `universalProfileAddress`.
     */
    function getLikedUniversalProfiles(address universalProfileAddress) external view returns(address[] memory) {
        return likedUniversalProfiles[universalProfileAddress].values();
    }

    /**
     * @notice Getter for the list of Universal Profiles that liked an Universal Profiles.
     *
     * @param universalProfileAddress The address of Universal Profile.
     * @return A list of Universal Profiles liked by `universalProfileAddress`.
     */
    function getLikedByUniversalProfiles(address universalProfileAddress) external view returns(address[] memory) {
        return likedByUniversalProfiles[universalProfileAddress].values();
    }

    /**
     *
     */
    function likeUniversalProfile(address universalProfileAddress, address likedUniversalProfileAddress) external {
        require(
            !likedUniversalProfiles[universalProfileAddress].contains(likedUniversalProfileAddress) &&
            !likedByUniversalProfiles[likedUniversalProfileAddress].contains(universalProfileAddress),
            "The Universal Profile is already liked."
        );
        if (!universalProfileAddresses.contains(likedUniversalProfileAddress)) {
            _addAddress(likedUniversalProfileAddress);
        }
        _increaseLikes(likedUniversalProfileAddress);
        _addToLikedAddresses(universalProfileAddress, likedUniversalProfileAddress);
    }

    /**
     *
     */
    function unlikeUniversalProfile(address universalProfileAddress, address likedUniversalProfileAddress) external {
        require(universalProfileAddresses.contains(likedUniversalProfileAddress), "The Universal Profile is not in the data structure.");
        require(
            likedUniversalProfiles[universalProfileAddress].contains(likedUniversalProfileAddress) &&
            likedByUniversalProfiles[likedUniversalProfileAddress].contains(universalProfileAddress),
            "The Universal Profile is not among the liked ones."
        );
        _decreaseLikes(likedUniversalProfileAddress);
        _removeFromLikedAddresses(universalProfileAddress, likedUniversalProfileAddress);
    }

    // Test method.
    function getMsgSender() external view returns(address) {
        return msg.sender;
    }

}
