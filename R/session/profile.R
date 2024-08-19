# Source the original .Rprofile
local({
    try_source <- function(file) {
        if (file.exists(file)) {
            source(file)
            TRUE
        } else {
            FALSE
        }
    }

    # Possible related to the issue https://github.com/REditorSupport/vscode-R/issues/1425
    # 3 levels of .Rprofile's could be co-exist, but loaded in the order of: 1)System level; 2)User level; 3)Project level
    # Result the prioprity level of .Rprofile is: System level < User level < Project level, as the latter setting will overwrite the former setting.
    # System level: (system wide, wherever is definded by Sys.getenv("R_PROFILE_USER_OLD"))
    r_profile <- Sys.getenv("R_PROFILE_USER_OLD")
    Sys.setenv(
        R_PROFILE_USER_OLD = "",
        R_PROFILE_USER = r_profile
    )
    if (nzchar(r_profile)) {
        try_source(r_profile)
    }
    # User level: (home dirctory, wherever is definded by Sys.getenv("HOME"))
    try_source(file.path("~", ".Rprofile"))
    # Project level: (current working directory, where VSCode is opened)
    try_source(".Rprofile")

    invisible()
})

# Run vscode initializer
local({
    init_file <- Sys.getenv("VSCODE_INIT_R")
    if (nzchar(init_file)) {
        source(init_file, chdir = TRUE, local = TRUE)
    }
})
