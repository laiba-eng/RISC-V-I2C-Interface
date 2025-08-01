# RISC-V-I2C-Interface
This project implements an I2C communication protocol using memory-mapped I/O with single-cycle RISC-V. A structured FSM enables master/slave data transfer with features like start/stop conditions, acknowledgments, and clock stretching. Performance metrics such as maximum clock frequency, data transfer rate, and system efficiency were analyzed.

# Key Features

- RISC-V and I2C integration via memory-mapped registers
- Start/Stop condition handling, Acknowledgment, and Clock Stretching
- FSM-based control logic for efficient data transfers
- Simulation and analysis of performance metrics like max clock frequency and throughput

Perfect for embedded systems requiring efficient processor-to-peripheral communication over I2C.

# I2C Module Requirements: 
The I2C module is made to support essential features depending on whether it is in master or slave mode. 
## Master Mode: 
- Clock Generation: To synchronise data transactions, the master creates the SCL clock signal. Transaction Initiation: To initiate communication, the master sends a start condition with the target device address. 
- Data Transmission and Acknowledgement: It transmits data bytes and watches for the receiving device to acknowledge them. The master may attempt again or terminate the conversation if the acknowledgement is not received. 
- Stop Condition: A stop condition is sent by the master to terminate the conversation. 
- Clock Stretching: To synchronise communication, the master can suspend SCL (clock stretching) when a slave requires more processing time. 
## Slave Mode: 
- Address Recognition: The slave keeps an eye on the bus and detects when the master broadcasts its address. 
- Data Reception and Acknowledgement: The slave acknowledges every byte of data that is sent to it by the master. The slave will return data and wait for acknowledgement if the master demands it. 
- Clock Stretching: To show that processing the received data takes longer than expected, the slave might keep the SCL line low. 


# Interfacing I2C With RISC-V Processor Using Memory Mapped I/O


| Register Name     | Address  |
|-------------------|----------|
| Control Register  | `7'h40`   |
| Status Register   | `7'h44`   |
| Data Register     | `7'h48`   |

# Instructions Used

| Instruction              | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `ADDI x1, x0, 0x10`      | Adds immediate `0x10` (16 in decimal) to `x0` and stores result in `x1`.     |
| `ADDI x2, x0, 0x20`      | Adds immediate `0x20` (32 in decimal) to `x0` and stores result in `x2`.     |
| `SW x1, 0x40(x0)`        | It takes the value stored in register x1 and writes it to the memory address 0x40. This is  the address of the I2C control register.   |
| `SW x2, 0x48(x0)`        | It takes the value stored in register x2 and writes it to the memory address 0x48. This is  the address of the I2C data register.      |
| `LW x3, 0x44(x0)`        | It loads the value stored at memory address 0x44      |

# RISC-V Interfaced With I2C RTL Diagram
<img width="1191" height="483" alt="image" src="https://github.com/user-attachments/assets/29ae67e7-c36c-44c7-98b9-a66272d8e88e" />

# State Diagram

<img width="800" height="400" alt="image" src="https://github.com/user-attachments/assets/a55853c9-9438-455b-bfdd-a4587168e0b7" />

# Simulation

<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/b0fdc054-e313-4a33-9314-7238242daa1e" />

