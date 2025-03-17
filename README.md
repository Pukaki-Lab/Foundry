<p align="left">
  <img width="147" src="https://github.com/user-attachments/assets/ccbaffb0-45d0-4703-abf8-b3ffdf68c281" />
  <h1>Foundry - Start building your own App Factory</h1>
</p>

<br><br>

**Pukaki's Foundry** is a meta-template tool that uses [Tuist](https://tuist.io/) to quickly build multi-app projects and automatically generate a custom workspace.

<br><br>

## Features

- 🏭 **Instant Workspace Setup**: <br>
  Clone the repository and run `./install` to start creating your own App Factory Workspace effortlessly.<br>
  <br>
- 🔧 **Makefile-based Project Management**:<br>
  Easily add Frameworks, Libraries, Apps, and Micro Architecture Features with simple commands. <br>
  <br>
- ⚡ **Multi-App Support**:<br>
  Designed for handling multiple apps within a single workspace efficiently.<br>
  <br>

<br><br>

## Getting Started

### 1. Clone the Repository

```sh
git clone https://github.com/Pukaki-Lab/Foundry.git
cd Foundry
```

<br><br>

### 2. Install and Initialize

Run the installation script to generate your workspace:

```sh
./install
```

<br><br>

This will guide you through setting up your first app inside the workspace.

### 3. Add Components

You can extend your workspace by adding different components using `make` commands:

```sh
make framework name=MyFramework
make library name=MyLibrary
make app name=MyApp
make microService_feature name=MyFeature
make mono_feature name=MyFeature
make clean_feature name=MyFeature
```

<br><br>

## Why Use Foundry?

- **Fast and Consistent**: Eliminates repetitive setup steps, letting you focus on development.
- **Flexible**: Supports various architectures and scaling needs.
- **Powered by Tuist**: Leverages Tuist’s power to manage Xcode projects seamlessly.

<br><br>

## Contributing

If you find a bug or want to enhance Foundry, feel free to open an issue or submit a pull request.

<br><br>

## License

This project is licensed under [MIT License](LICENSE).

<br><br>

---

<br><br>

Start building your own App Factory with Foundry today! 🚀

<br><br>

