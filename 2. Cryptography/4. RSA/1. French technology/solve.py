from Crypto.Util.number import long_to_bytes

# given values
n = 17898028240830814136434787407852442663239728391134776310533753763258523791465145947321086853292608375964370070398263
c = 5740196029944570285461595789387642615026206835758048500685342416498085007060475130355254601538690350792607830802905
e = 65537

# factored primes
p = 3471990687824593680273251255463630853556792715805318789409
q = 5154975876978800665290208266910928152604080453168333003607

# standard RSA decrypt
phi = (p-1)*(q-1)
d = pow(e, -1, phi)
m = pow(c, d, n)

prefix = int.from_bytes(b"SK-CERT{", "big")
suffix = ord("}")
inv256 = pow(256, -1, n)

for L in range(49,120):
    mid_len = L - 9
    rhs = (m - prefix * pow(256, L-8, n) - suffix) % n
    mid = rhs * inv256 % n
    if mid < 256**mid_len:
        middle = mid.to_bytes(mid_len,"big")
        if all(32 <= b <= 126 for b in middle):
            flag = b"SK-CERT{" + middle + b"}"
            print(flag.decode())
