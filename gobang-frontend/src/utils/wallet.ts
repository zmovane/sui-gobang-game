import { fromB64 } from "@mysten/bcs";
import { Ed25519Keypair, JsonRpcProvider, RawSigner } from "@mysten/sui.js";

export function fromSecretKey(secretKey: string) {
  const buffer = fromB64(secretKey);
  const array = Array.from(buffer);
  array.shift(); // shift the scheme flag byte which should be 0 since it is ed25519
  const privkey = Uint8Array.from(array.slice(32, 64));
  const keypair = Ed25519Keypair.fromSeed(privkey);
  const provider = new JsonRpcProvider();
  return new RawSigner(keypair, provider);
}
