# Neovim Configuration by Himanshu Vishwakarma

Welcome to my **Neovim configuration**! This setup is designed to provide a **minimal, stable, and highly productive IDE-like experience** for developers. Whether you're working on small scripts or large projects, this configuration has you covered.

---

## 👨‍💻 About Me

Hi, I'm **Himanshu Vishwakarma**, the developer of this Neovim configuration. I’m passionate about creating efficient and developer-friendly tools. This configuration is the result of countless hours of tweaking and optimizing Neovim to suit modern development workflows.

---

## 🚀 Features

- **Fast and Lightweight**: Built for speed and efficiency.
- **Modern UI**: Clean and intuitive interface with themes like **Tokyo Night**.
- **LSP Support**: Full Language Server Protocol (LSP) integration for autocompletion, diagnostics, and more.
- **Debugging**: Built-in support for debugging with **nvim-dap**.
- **Git Integration**: Seamless Git workflows with **gitsigns.nvim** and **lazygit**.
- **Custom Keybindings**: Optimized keybindings for productivity.
- **Extensible**: Easily add or remove plugins to suit your needs.

---

## ⚙️ Installation

### Prerequisites

- **Neovim (v0.8+)** - Ensure you have Neovim installed.
- **Git** - For cloning the repository.
- **Node.js** - For LSP support (e.g., TypeScript, JavaScript).
- **Python** - For additional plugins and tools.
- **Rust (Cargo)** - For tools like `stylua`.

---

### 1. Install Neovim

#### Linux/macOS
```bash
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout release-0.8
make CMAKE_BUILD_TYPE=Release
sudo make install
