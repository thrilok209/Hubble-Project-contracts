pragma solidity ^0.5.15;
pragma experimental ABIEncoderV2;

import {Types} from "./Types.sol";


library RollupUtils {
    // ---------- Account Related Utils -------------------
    function PDALeafToHash(Types.PDALeaf memory _PDA_Leaf)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_PDA_Leaf.pubkey));
    }

    // returns a new User Account with updated balance
    function UpdateBalanceInAccount(
        Types.UserAccount memory original_account,
        uint256 new_balance
    ) public pure returns (Types.UserAccount memory updated_account) {
        original_account.balance = new_balance;
        return original_account;
    }

    function BalanceFromAccount(Types.UserAccount memory account)
        public
        pure
        returns (uint256)
    {
        return account.balance;
    }

    function HashFromAccount(Types.UserAccount memory account)
        public
        pure
        returns (bytes32)
    {
        return keccak256(BytesFromAccount(account));
    }

    function BytesFromAccount(Types.UserAccount memory account)
        public
        pure
        returns (bytes memory)
    {
        return
            abi.encode(
                account.ID,
                account.balance,
                account.nonce,
                account.tokenType
            );
    }

    function getAccountHash(
        uint256 id,
        uint256 balance,
        uint256 nonce,
        uint256 tokenType
    ) public pure returns (bytes32) {
        Types.UserAccount memory userAccount = Types.UserAccount({
            ID: id,
            tokenType: tokenType,
            balance: balance,
            nonce: nonce
        });
        return HashFromAccount(userAccount);
    }

    // ---------- Tx Related Utils -------------------

    function BytesFromTx(Types.Transaction memory _tx)
        public
        pure
        returns (bytes memory)
    {
        return
            abi.encode(_tx.fromIndex, _tx.toIndex, _tx.tokenType, _tx.amount,_tx.signature);
    }
    
    function CompressTx(Types.Transaction memory _tx) public pure returns (bytes memory){
        return
            abi.encode(_tx.fromIndex, _tx.toIndex, _tx.tokenType, _tx.amount,_tx.signature);
    }

    function HashFromTx(Types.Transaction memory _tx)
        public
        pure
        returns (bytes32)
    {
        return keccak256(BytesFromTx(_tx));
    }

    function getTxHash(
        uint256 fromIndex,
        uint256 toIndex,
        uint256 tokenType,
        uint256 amount
    ) public pure returns (bytes32) {
        bytes memory data = abi.encode(fromIndex, toIndex, tokenType, amount);
        return keccak256(data);
    }

    /**
     * @notice Calculates the address from the pubkey
     * @param pub is the pubkey
     * @return Returns the address that has been calculated from the pubkey
     */
    function calculateAddress(bytes memory pub)
        public
        pure
        returns (address addr)
    {
        bytes32 hash = keccak256(pub);
        assembly {
            mstore(0, hash)
            addr := mload(0)
        }
    }
}
