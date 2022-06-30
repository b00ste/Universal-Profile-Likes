import React, { useEffect } from 'react';

const UniversalProfiles = ({ contract, universalProfilesAddresses, setUniversalProfilesAddresses }) => {

  useEffect(() => {

    const getAddresses = async () => {
      let res = await contract.methods.getUniversalProfileAddresses().call();
      setUniversalProfilesAddresses(res);
      console.log(res);
    }

    getAddresses();
  }, [contract.methods, setUniversalProfilesAddresses])
  

  return(
    <></>
  );
}

export default UniversalProfiles;