import React from 'react';

const LikeUniversalProfile = ({ contract, account, universalProfileAddress }) => {

  const likeUniversalProfile = async () => {
    console.log(account);
    console.log(universalProfileAddress);
    const res = await contract.methods["likeUniversalProfile(address,address)"](account, universalProfileAddress).send({ from: account});
  }

  return (
    <button onClick={() => likeUniversalProfile()}>Like</button>
  );
}

export default LikeUniversalProfile;