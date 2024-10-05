// import {
//   Approval as ApprovalEvent,
//   OwnershipTransferred as OwnershipTransferredEvent,
//   Transfer as TransferEvent
// } from "../generated/BridgeERC20/BridgeERC20"
// import { Approval, OwnershipTransferred, Transfer } from "../generated/schema"

// export function handleApproval(event: ApprovalEvent): void {
//   let entity = new Approval(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   )
//   entity.owner = event.params.owner
//   entity.spender = event.params.spender
//   entity.value = event.params.value

//   entity.blockNumber = event.block.number
//   entity.blockTimestamp = event.block.timestamp
//   entity.transactionHash = event.transaction.hash

//   entity.save()
// }

// export function handleOwnershipTransferred(
//   event: OwnershipTransferredEvent
// ): void {
//   let entity = new OwnershipTransferred(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   )
//   entity.previousOwner = event.params.previousOwner
//   entity.newOwner = event.params.newOwner

//   entity.blockNumber = event.block.number
//   entity.blockTimestamp = event.block.timestamp
//   entity.transactionHash = event.transaction.hash

//   entity.save()
// }

// export function handleTransfer(event: TransferEvent): void {
//   let entity = new Transfer(
//     event.transaction.hash.concatI32(event.logIndex.toI32())
//   )
//   entity.from = event.params.from
//   entity.to = event.params.to
//   entity.value = event.params.value

//   entity.blockNumber = event.block.number
//   entity.blockTimestamp = event.block.timestamp
//   entity.transactionHash = event.transaction.hash

//   entity.save()
// }


import {
    Transfer 
  } from "../generated/BridgeERC20/BridgeERC20"
import { BigInt } from "@graphprotocol/graph-ts"
import { User } from "../generated/schema"
import { loadOrCreateUser } from "./utils";

export function handleTransfer(event: Transfer): void {
 


  let sender = loadOrCreateUser(event.transaction.from.toHexString());
  let receiver = loadOrCreateUser(event.params.to.toHexString());

  let amount = event.params.value;
  sender.balance = sender.balance.minus(amount);
  receiver.balance = receiver.balance.plus(amount);

  sender.save();
  receiver.save();
}

