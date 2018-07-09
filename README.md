# verilog-spi
## Using this project repo as a stand-alone local project
### Adding this project
0. From your shell, change your working directory to the intended parent directory.
1. Download this repo using `git clone` to your project's intended parent directory, with folder name `verilog-spi_vcs`. Use the following command:
    * `git clone https://github.com/ntwong0/verilog-spi.git verilog-spi_vcs`
2. Open an instance of the Xilinx Vivado GUI, and use [Tools] > [Run Tcl Script...] to run the `create_project.tcl` script located in `verilog-spi/scripts`

### Making modifications
Changes to the project's file structure
1. need to be done in Xilinx Vivado, using the [Libraries] tab of [Windows] > [Sources], and
2. need to be committed to the `create_project.tcl` using `writeout_project.tcl`.

Examples of file structure changes include:
1. Creating new files/folders
2. Renaming files/folders
3. Moving files/folders
4. Deleting files/folders

Please keep all project files in the `verilog-spi_vcs` folder, such as:
1. `*.xdc` constraint files,
2. `*.tcl` script files, 
3. `*.v` design and simulation sources,
4. `*.mem` memory files, and
5. `*.wcfg` waveform configuration files.

### Making commits, and pushing changes to remote
1. Before making your commits, be sure to refer to the previous section, *Making modifications*, before committing any modifications to the project's file structure.
2. Commits and pushes can be done the usual way. Also, be sure your fork and your `git remote` are set up.

### Pulling updates from remote
1. Use your usual `git fetch` and `git merge` routine to update the repo.
2. Then, be sure to run `create_project.tcl` to rebuild your Vivado project with the changes from upstream.

## Using this project repo as a sub-directory of your project
### Adding this project
0. From your shell, change your wokring directory to your existing project's directory (**not** *your project's* **parent** *directory*).
1. First, add this project as a remote:
    *  `git remote add -f verilog-spi_vcs https://github.com/ntwong0/verilog-spi.git`
2. Then, add this project as a subtree:
    * `git subtree add --prefix ../verilog-spi_vcs verilog-spi_vcs master --squash`

### Pulling updates from remote
Use the following commands to update this project:
* `git fetch verilog-spi_vcs master`
* `git subtree pull --prefix ../verilog-spi_vcs verilog-spi_vcs master --squash`

### Contributing back upstream
1. Open an instance of the Xilinx Vivado GUI, and use [Tools] > [Run Tcl Script...] to run the `create_project.tcl` script located in `verilog-spi/scripts`
2. Before making your commits, be sure to refer to the previous section, *Making modifications*, before committing any modifications to the project's file structure.
3. Also, be sure your fork and your `git remote` are set up. You can add your fork's remote URL the usual way, i.e.:
    * `git remote add verilog-spi_vcs https://github.com/ntwong0/verilog-spi.git`
4. You can push upstream using the following command (assuming you've named your remote `verilog-spi_vcs`)
    * `git subtree push --prefix=../verilog-spi_vcs verilog-spi_vcs master`

## References
1. [Git subtree: the alternative to Git submodule](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree)
2. [Using Vivado Design Suite with Version Control Systems](https://www.xilinx.com/support/documentation/application_notes/xapp1165.pdf)