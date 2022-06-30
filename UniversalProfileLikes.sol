// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.7;


import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/**
 * This smart contract provides a way to add likes
 * to a universal profile using another universal profile.
 *
 * @title UniversalProfileLikes
 * @author B00ste
 * @custom:verson 0.2
 */
contract UniversalProfileLikes {

    // Defining the address set.
    using EnumerableSet for EnumerableSet.AddressSet;

    // --- ATTRIBUTES.

    /**
     * @notice This set will be used to store all addresses that have likes.
     */
    EnumerableSet.AddressSet private universalProfileAddresses;

    /**
     * @notice This mapping will store the Universal Profiles liked by an Universal Profile.
     */
    mapping (address => EnumerableSet.AddressSet) private likedUniversalProfiles;

    /**
     * @notice This mapping will store the Universal Profiles that liked an Universal Profile.
     */
    mapping (address => EnumerableSet.AddressSet) private likedByUniversalProfiles;

    // --- MODIFIERS.

    /**
     * @notice Verifies that the `likedUniversalProfileAddress` isn't liked by `universalProfileAddress` yet.
     *
     * @param universalProfileAddress The address of a Universal Profile that likes another Universal Profile.
     * @param likedUniversalProfileAddress The address of a Universal profile that is about to be liked.
     */
    modifier UniversalProfileNotLikedBy(address universalProfileAddress, address likedUniversalProfileAddress) {
        require(
            !likedUniversalProfiles[universalProfileAddress].contains(likedUniversalProfileAddress) &&
            !likedByUniversalProfiles[likedUniversalProfileAddress].contains(universalProfileAddress),
            "The Universal Profile is already liked."
        );
        _;
    }

    /**
     * @notice Verifies that `likedUniversalProfileAddress` is liked by `universalProfileAddress`.
     *
     * @param universalProfileAddress The address of a Universal Profile that likes another Universal Profile.
     * @param likedUniversalProfileAddress The address of a Universal profile that is about to be liked.
     */
    modifier UniversalProfileLikedBy(address universalProfileAddress, address likedUniversalProfileAddress) {
        require(
            likedUniversalProfiles[universalProfileAddress].contains(likedUniversalProfileAddress) &&
            likedByUniversalProfiles[likedUniversalProfileAddress].contains(universalProfileAddress),
            "The Universal Profile is not among the liked ones."
        );
        _;
    }

    /**
     * @notice Verifies that a Universal Porfile has att least 1 like.
     *
     * @param universalProfileAddress The address of a Universal Profile that should have likes.
     */
    modifier UniversalProfileHasLikes(address universalProfileAddress) {
        require(
            universalProfileAddresses.contains(universalProfileAddress),
            "The Universal Profile has no likes to remove."
        );
        _;
    }
    
    // --- SETTERS & GETTERS.

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
     * @notice Getter for the number of Universal Profiles that liked a Universal Profile. Aka number of likes of an Universal Profile.
     *
     * @param universalProfileAddress The address of the Universal Profile that has a number of likes.
     * @return The number of likes belonging to `universalProfileAddress` will be returned.
     */
    function getUniversalProfileLikes(address universalProfileAddress) external view returns(uint256) {
        return likedByUniversalProfiles[universalProfileAddress].length();
    }

    // --- SMART CONTRACT METHODS.

    /**
     * @notice Method used for liking an Universal Profile.
     *
     * @param universalProfileAddress The address of an Universal Profile that likes another Universal Profile.
     * @param likedUniversalProfileAddress The address of an Universal Profile that is about to be liked.
     */
    function likeUniversalProfile(
        address universalProfileAddress,
        address likedUniversalProfileAddress
    )
        external
        UniversalProfileNotLikedBy(universalProfileAddress, likedUniversalProfileAddress)
    {
        if (!universalProfileAddresses.contains(likedUniversalProfileAddress)) {
            _addAddress(likedUniversalProfileAddress);
        }
        _addToLikedAddresses(universalProfileAddress, likedUniversalProfileAddress);
    }

    /**
     * @notice Method used for unliking an Universal Profile.
     *
     * @param universalProfileAddress The address of an Universal Profile that likes another Universal Profile.
     * @param likedUniversalProfileAddress The address of an Universal Profile that is about to be liked.
     */
    function unlikeUniversalProfile(
        address universalProfileAddress,
        address likedUniversalProfileAddress
    )
        external
        UniversalProfileHasLikes(likedUniversalProfileAddress)
        UniversalProfileLikedBy(universalProfileAddress, likedUniversalProfileAddress)
    {
        if (likedByUniversalProfiles[likedUniversalProfileAddress].length() == 1) {
            _removeAddress(likedUniversalProfileAddress);
        }
        _removeFromLikedAddresses(universalProfileAddress, likedUniversalProfileAddress);
    }

    // Test method.
    function getMsgSender() external view returns(address) {
        return msg.sender;
    }

}
