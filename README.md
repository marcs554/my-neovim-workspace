# my-neovim-workspace


## How to use it
1. clone repository `git clone https://github.com/marcs554/my-neovim-workspace.git`
2. Have installed `git` and `neovim`
3. Make a symbolic link so neovim can load every time is called: `ln -s /path/2/my-neovim-workspace ~/.config/nvim`


## Cheatsheet
### General
- `<leader>` Represents the space keyboardi
- `<n>` Normal mode
- `<leader> la` -> Open lazy menu
- `<leader> cd` -> Open the explorer
- `:bw` -> Close the buffer completly
- `:e /path/2/file.extension` -> Creates a new file
- `R` -> In Netrw put the cursor in the file/folder to rename
- `d </path/2/directory>` -> Create a new directory

### How to comment multiple lines
1. `<C-v>` -> Mode block mutiline
2. Select multiple lines with: `j` o `k`
3. `<Shift-i>` -> set the characters that represent the comments
4. Press `<Esc>` to perform the multiline comment

### How to uncomment multiple lines
1. `<C-v>` -> Mode block multiline
2. Select multiple lines with: `j` o `k`
3. press `d` to delete

### Telescope
- `<leader> ff` -> Open telescope and search by name or path
- `<leader> fg` -> Open telescope and search like a grep every match inside of the files of the directory
- `<leader> fb` -> shows the buffers opened
- `<leader> fh` -> Help menu

### Harpoon
- `<leader> a` -> Add file to harpoon
- `<C-e>` -> Open harpoon list
- `<leader> fl` -> open harpoon list with all files opened
- `<C-p>` -> Shows previous file
- `<C-n>` -> Shows next file

### Lsp 
- `<n> K` -> hover
- `<n> gd` -> definition
- `<n> gD` -> declaration
- `<n> gi` -> implementation
- `<n> go` -> type_definition
- `<n> gr` -> references
- `<n> gs` -> signature_help
- `<n> gl` -> diagnostic.open_float
- `<n> <F2>` -> rename
- `<n> <F4>` -> code_action

### Substitution

In **Neovim (`nvim`)**, pattern substitution is done with the `:substitute` command (`:s`).

#### Basic syntax

```
:[range]s/pattern/replacement/[flags]
```

For example, to replace all occurrences of `foo` with `bar` on the current line:

```
:s/foo/bar/g
```

The `g` flag means **replace all occurrences on the line**.

#### Common examples

- **Replace throughout the entire file:**

  ```
  :%s/foo/bar/g
  ```
- **Ask for confirmation before each replacement:**

  ```
  :%s/foo/bar/gc
  ```
   `c` = confirmation.
- **Replace only within a range of lines:**

  ```
  :10,20s/foo/bar/g
  ```
- **Ignore case:**

  ```
  :%s/foo/bar/gi
  ```
- **Replace only whole words:**

  ```
  :%s/\<foo\>/bar/g
  ```
- **Use a regular expression:**

  ```
  :%s/foo\zs.*/bar/g
  ```
   Here, `\zs` marks where the part to be replaced actually starts.

#### A very useful trick

If you want to replace text **only within selected lines**, enter Visual mode, select the lines, and type:

```
:s/foo/bar/g
```

Neovim will automatically turn the selection into something equivalent to:

```
:'<,'>s/foo/bar/g
```

If you tell me **the pattern you want to find and what you want to replace it with**, I can give you the exact Neovim command, including the regex if needed.
