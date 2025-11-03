use dep::std;

#[recursive(verification_key = "rng_vk")]
fn verify_sub_proof(
    sub_proof: [Field; 32],
    sub_inputs: [Field; 1],
    vk: [Field; 32]
) -> pub Field {
    assert(std::verify_proof(sub_proof, sub_inputs, vk));
    1
}

fn prove_roll(
    seed: Field,
    nonce: Field,
    roll: pub Field
) -> pub [Field; 1] {
    let hash = seed * nonce;
    let result = hash % 6 + 1;
    assert(result == roll);
    [result]
}

fn main(
    seeds: [Field; 100],
    nonces: [Field; 100],
    rolls: pub [Field; 100]
) -> pub [Field; 1] {
    let mut total_wins = 0;
    for i in 0..100 {
        let sub_proof = prove_roll(seeds[i], nonces[i], rolls[i]);
        total_wins += verify_sub_proof(sub_proof, [rolls[i]], [1; 32]);
    }
    [total_wins]
}
