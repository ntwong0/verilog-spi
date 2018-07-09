# verilog-spi
## Dependencies
1. [CMPE127-Toolkit](https://github.com/kammce/CMPE127-Toolkit.git)

## Adding this project
0. From your shell, change your working directory to the intended parent directory.
1. Download this repo using `git clone` to your project's intended parent directory, i.e. using the following command:
    * `git clone https://github.com/ntwong0/verilog-spi.git`
2. Please ensure that the dependencies listed above are also added to the parent directory.

## Initializing this project in Xilinx Vivado
You'll need to initialize this project in Xilinx Vivado if:
1. You need to edit the file structure of the project to prepare it for pushing upstream
2. You need to work directly on the project, proceeding through its RTL design flow 

To initialize, open an instance of the Xilinx Vivado GUI, and use [Tools] > [Run Tcl Script...] to run the `create_project.tcl` script located in `scripts`

***Note: The Vivado project directory created by `create_project.tcl` will bear the same name as the project.***

## Making modifications
Changes to the project's file structure
1. need to be done in Xilinx Vivado, using the [Libraries] tab of [Windows] > [Sources], and
2. need to be committed to the `create_project.tcl` using `writeout_project.tcl`.

Examples of file structure changes include:
1. Creating new files/folders
2. Renaming files/folders
3. Moving files/folders
4. Deleting files/folders

Please keep all project files in the `verilog-spi` folder, such as:
1. `*.xdc` constraint files,
2. `*.tcl` script files, 
3. `*.v` design and simulation sources,
4. `*.mem` memory files, and
5. `*.wcfg` waveform configuration files.

## Making commits, and pushing changes to remote
1. Before making your commits, be sure to refer to the previous section, *Making modifications*, before committing any modifications to the project's file structure.
2. Commits and pushes can be done the usual way. Also, be sure your fork and your `git remote` are set up.

## Pulling updates from remote
1. Use your usual `git fetch` and `git merge` routine to update the repo.
2. Then, be sure to run `create_project.tcl` to rebuild your Vivado project with the changes from upstream.

## References
1. [Using Vivado Design Suite with Version Control Systems](https://www.xilinx.com/support/documentation/application_notes/xapp1165.pdf)