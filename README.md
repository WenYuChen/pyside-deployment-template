# PySide GUI

---

A project architecture for developing PySide GUI which can generate executable and installer rapidly.

## Platform

Windows 7 / 10 / 11

## Getting Started

1. Install python 3.10.

2. Install requirements:
    ```
    pip install -r requirements.txt
    ```

3. Install ```Makefile```.

4. Install ```NSIS```

5. Execute GUI:
    ```
    python src/gui.py
    ```

## How to Deploy

1. Change directory to project root, and execute the following command:
   ```
   make
   ```

2. Wait until the installer is generated, which can be found in the directory ```installer```.

## AUTHORS

* Jesse Chen
