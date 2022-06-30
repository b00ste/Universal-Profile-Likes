import React, { useState } from 'react';
import './App.css';
import CONTRACT_ABI from './CONTRACT_ABI.json';
import Connect from './Components/Connect';
import UniversalProfiles from './Components/UniversalProfiles';
import LikeUniversalProfile from './Components/Like';

import Web3 from 'web3';
const web3 = new Web3(window.ethereum);
const UNIVERSAL_PROFILE_LIKES_ADDRESS = "0xa34BB42C082E2DD01A7e84399E591C4901642920";
const contract = new web3.eth.Contract(CONTRACT_ABI, UNIVERSAL_PROFILE_LIKES_ADDRESS);

function App() {

  const [account, setAccount] = useState(undefined);
  const [universalProfileAddress, setUniversalProfileAddress] = useState(undefined);
  const [universalProfilesAddresses, setUniversalProfilesAddresses] = useState(undefined);

  const saveAddress = (e) => {
    setUniversalProfileAddress(e.target.value);
    console.log(e.target.value);
  }

  return (
    <div className="App">
      <Connect setAccount={setAccount} web3={web3} />
      <UniversalProfiles
        contract={contract}
        universalProfilesAddresses={universalProfilesAddresses}
        setUniversalProfilesAddresses={setUniversalProfilesAddresses}
      />
      <input type='text' placeholder='Universal Profile Address' onChange={(e) => saveAddress(e)} />
      <LikeUniversalProfile
        contract={contract}
        account={account}
        universalProfileAddress={universalProfileAddress}
      />
      {
        account !== undefined
        ? <p>{account}</p>
        : <></>
      }
    </div>
  );
}

export default App;
