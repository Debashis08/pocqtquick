# pocqtquick

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Qt](https://img.shields.io/badge/Qt-6.10-green.svg)](https://www.qt.io/)

### Project Overview
**pocqtquick** is a Proof of Concept (PoC) application demonstrating the integration of **Qt Quick (QML)** with a **C++** backend. This can be considered as a template repository for desktop application development. The project includes basic `dev`, `test`, `production` deployment yamls with a proper branch protection strategy and  deployment policies, to ensure smooth deployment and validation across each environment.

### Architecture
The project follows a **Layered Architecture** to ensure modularity:

* **UI Layer (`src/ui`)**: Pure QML. No business logic.
* **ViewModel Layer (`src/backend/viewmodels`)**: Adapters that expose C++ data to QML.
* **Service Layer (`src/backend/services`)**: Pure C++ business logic (File I/O, Networking).
* **Core Layer (`src/backend/core`)**: Infrastructure (Logging, Service Locator).

### Project Structure
```text
pocqtquick
├── .github
│   ├── workflows                   # CI/CD (Build, Test, Deploy)
│   └── pull_request_template.md
├── cmake
│   └── TestUtils.cmake             # Shared CMake functions for testing
├── installer
│   └── windows-setup.iss           # Inno Setup script for generating .exe installer
├── scripts
│   ├── build-app-windows.bat       # Automates the build process
│   └── build-installer-windows.bat # Automates installer generation
├── src
│   ├── CMakeLists.txt
│   ├── main.cpp                    # Entry point
│   ├── qtquickcontrols2.conf       # Global UI styling configuration
│   ├── backend
│   │   ├── core                    # Infrastructure (Logger, Locator)
│   │   ├── services                # Business Logic (CounterService)
│   │   └── viewmodels              # QML Adapters (CounterViewModel)
│   └── ui
│       ├── components              # Reusable UI elements (Buttons)
│       └── pages                   # Full-screen views
└── tests
    ├── backend                     # C++ Unit Tests (QTest)
    └── ui                          # QML Integration Tests (QQuickTest)
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