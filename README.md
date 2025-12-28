# pocqtquick

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

### Project Overview
**pocqtquick** is a Proof of Concept (PoC) application demonstrating the integration of **Qt Quick (QML)** with a **C++** backend. This can be considered as a template repository for desktop application development. The project includes basic `dev`, `test`, `production` deployment yamls with a proper branch protection strategy and  deployment policies, to ensure smooth deployment and validation across each environment.

**Key Features:**
* `installer/` - Resources and scripts for creating the application installer.
* `scripts/` - Helper scripts for build automation and setup.
* `source/` - Core application source code (C++ and QML).
* `test/` - Unit tests for validating application logic.
* `CMakeLists.txt` - Main CMake configuration file.

### Project Structure
```
root
├──.github
│   ├──pull_request_template.md
│   ├──ISSUE_TEMPLATE
│   │  └──bug_report.md
│   └──workflows
│      ├──deploy-dev.yaml
│      ├──deploy-prod.yaml
│      ├──deploy-test.yaml
│      └──validate.yaml
├──installer
│   ├──config
│   │  └──config.xml
│   └──packages
│       └──com.pocqtquick
│           └──meta
│               ├──installscript.qs
│               └──package.xml
├──scripts
│  ├──build-windows-app.bat
│  └──build-windows-installer.bat
├──source
│   ├──CMakeLists.txt
│   ├──main.cpp
│   ├──qml.qrc
│   ├──backend
│   │  ├──counter.cpp
│   │  └──counter.h
│   └───ui
│       └──Main.qml
├──test
│   ├──CMakeLists.txt
│   ├──backend
│   │  └──counterTest.cpp
│   └──ui
│      └──MainQmlTest.cpp
├──.gitignore
├──CMakeLists.txt
├──CODE_OF_CONDUCT.md
├──CONTRIBUTING.md
├──LICENSE
├──README.md
└──SECURITY.md
```

### Prerequisites
Before building the project, ensure you have the following installed:
* **C++ Compiler**: MSVC (supporting C++17 or later).
* **Qt SDK**: (Version 6.10.1 recommended) with Qt Quick and Qt Qml modules.
* **CMake**: Version 3.16 or higher.

### Build Instructions
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Debashis08/pocqtquick.git
    cd pocqtquick
    ```
2.  **Create a build directory:**
    ```bash
    mkdir build
    cd build
    ```
3.  **Configure the project:**
    ```bash
    cmake ..
    # If Qt is not in your PATH, you may need to specify the prefix path:
    # cmake -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x.x/gcc_64 ..
    ```
4.  **Build:**
    ```bash
    cmake --build .
    ```

### Running Tests
To run the unit tests included in the `test/` directory:

```bash
cd build
ctest --output-on-failure