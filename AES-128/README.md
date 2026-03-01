# 🔐 AES-128 Encryption – FPGA Implementation

This folder contains the complete RTL implementation and FPGA deployment files for AES-128 encryption.

---

## 📂 Folder Structure

```
AES-128/
│
├── Constraints/   → XDC pin configuration file
├── src/           → Verilog source files
├── output/        → Hardware demonstration video
└── README.md
```

---

# ⚙️ Step-by-Step Implementation Guide

## Step 1 – Create New Vivado Project

1. Open Vivado.
2. Click Create Project.
3. Select RTL Project.
4. Do NOT add sources initially.
5. Choose the correct Spartan-7 device/board.
6. Finish project setup.

---

## Step 2 – Add Design Sources

1. Go to Flow Navigator → Add Sources.
2. Select Add or Create Design Sources.
3. Add all `.v` files from the `src/` folder.
4. Click Finish.

---

## Step 3 – Set Top Module

1. In Sources panel,
2. Right-click `aes_wrapper.v`
3. Select Set as Top.

---

## Step 4 – Add Constraints

1. Go to Add Sources → Add Constraints.
2. Add the `.xdc` file from the `Constraints/` folder.
3. Verify proper pin mapping for:
   - Clock
   - Reset
   - Start switch
   - Done LED
   - Seven-segment outputs

---

## Step 5 – Run Design Flow

- Run Synthesis
- Run Implementation
- Generate Bitstream

Expected Result:
- No critical errors
- Timing met
- Bitstream generated successfully

---

## Step 6 – Program FPGA

1. Open Hardware Manager.
2. Open target.
3. Program device.
4. Observe hardware behavior.

---

## 🎥 Hardware Verification

Refer to the `output/` folder for demonstration video showing:

- Reset behavior
- Start trigger
- Encryption completion
- Done LED indication
- Display output

---

## ✅ Expected Behavior

- Reset initializes system.
- Start signal begins encryption.
- Done LED turns ON after completion.
- Encrypted output visible on display.
