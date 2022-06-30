import React from 'react';

const Connect = ({ setAccount, web3 }) => {

  const connect = async () => {
    const accounts = await web3.eth.requestAccounts();
    setAccount(accounts[0]);
  }

  return(
    <button onClick={() => connect()}>Connect</button>
  )
}

export default Connect;