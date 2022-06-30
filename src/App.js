import React, { useState } from 'react';
import './App.css';
import Web3 from 'web3';
const web3 = new Web3(window.ethereum);

function App() {

  const [account, setAccount] = useState(undefined);

  const connect = async () => {
    const accounts = await web3.eth.requestAccounts();
    setAccount(accounts[0]);
  }

  return (
    <div className="App">
      <button onClick={() => connect()}>Connect</button>
    </div>
  );
}

export default App;
