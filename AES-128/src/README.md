
# 📂 Source Files – AES-128 Verilog RTL

This folder contains all synthesizable Verilog modules used in the AES-128 encryption design.

---

## 📌 Module Overview

### sub_bytes.v
Implements byte substitution using AES S-Box.

### shift_rows.v
Performs row-wise permutation of the state matrix.

### mix_columns.v
Implements Galois Field multiplication for column mixing.

### key_expand.v
Generates round keys from initial 128-bit key.

### aes_round.v
Combines core AES transformations for one encryption round.

### aes_top.v
Controls full encryption process across all rounds.

### aes_wrapper.v
Top-level FPGA integration module connecting:
- Clock
- Reset
- Start input
- Done output
- Display interface

---

## 🧠 Design Approach

- Modular architecture
- Synthesizable RTL
- Hardware-oriented design
- Clear separation of AES functional blocks

Each module is reusable and independently testable.
