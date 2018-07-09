# Maintainer    ntwong0
# Version       1.4.2018-07-08-2309

# Purpose
#    This script writes the attributes and parameters of the current Vivado project out. 
#    These values are saved to the create_project.tcl script. This resulting .tcl script
#    may be used to regenerate the project in another filesystem location.

# Generate the base create_project.tcl script
set script_directory "../script"
cd [get_property DIRECTORY [current_project]]
write_project_tcl -force -all_properties -no_copy_sources -use_bd_files ./$script_directory/create_project.tcl

# The following code tackles two shortcomings with how Vivado expects users 
# to use create_project.tcl:
# 1. The base create_project.tcl expects users to perform their own `cd` commands
#    such that the current working directory is where create_project.tcl expects
#    the project's files and directories.
# 2. If the project already exists, Vivado expects users to edit the create_project.tcl
#    to include the -force flag in order to overwrite the existing project.
# 3. write_project_tcl tries to guess that the intended project directory is relative to 
#    the sources in a particular way. It is wrong.

# Initial setup
cd ../script
set timestamp [clock format [clock seconds] -format {%Y%m%d%H%M%S}]
set filename "create_project.tcl"
set temp     $filename.new.$timestamp
set backup   $filename.bak.$timestamp
set in  [open $filename r]
set out [open $temp     w]

# Tackling #1
set first_line {cd [file dirname [file normalize [info script]]]}
set second_line {cd ..}
puts $out $first_line
puts $out $second_line

# Tackling #2 and #3
# a. Read the base file, copying each line to the temporary file.
# b. If the target line is found, append the -force flag before copying
# c. Rename the temporary file as the base file
while {[gets $in line] != -1} {
    # (b), (3)
    if [regexp {create_project \$} "$line"] {
        append line " " "-force"
    } elseif [regexp {\$origin_dir/..} "$line"] {
        regsub {\$origin_dir/..} $line {$origin_dir} line
    }
    # (a)
    puts $out $line
}
close $in
close $out
# (c), also prepare a backup in case the renaming fails
if {[catch [file copy $filename $backup]] == 0} {
    if {[catch [file rename -force $temp $filename ]] == 0} {
        file delete $backup 
        puts "Script create_project.tcl is ready."
    } else {
        puts "Could not perform renaming, script saved as $temp"
    }
} else {
    puts "Could not make a copy, script saved as $temp"
}
