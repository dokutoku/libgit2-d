/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.config;


private static import libgit2.buffer;
private static import libgit2.sys.config;
private static import libgit2.types;

/*
 * @file git2/config.h
 * @brief Git config management routines
 * @defgroup git_config Git config management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Priority level of a config file.
 * These priority levels correspond to the natural escalation logic
 * (from higher to lower) when searching for config entries in git.git.
 *
 * git_config_open_default() and git_repository_config() honor those
 * priority levels as well.
 */
enum git_config_level_t
{
	/**
	 * System-wide on Windows, for compatibility with portable git
	 */
	GIT_CONFIG_LEVEL_PROGRAMDATA = 1,

	/**
	 * System-wide configuration file; /etc/gitconfig on Linux systems
	 */
	GIT_CONFIG_LEVEL_SYSTEM = 2,

	/**
	 * XDG compatible configuration file; typically ~/.config/git/config
	 */
	GIT_CONFIG_LEVEL_XDG = 3,

	/**
	 * User-specific configuration file (also called Global configuration
	 * file); typically ~/.gitconfig
	 */
	GIT_CONFIG_LEVEL_GLOBAL = 4,

	/**
	 * Repository specific configuration file; $WORK_DIR/.git/config on
	 * non-bare repos
	 */
	GIT_CONFIG_LEVEL_LOCAL = 5,

	/**
	 * Application specific configuration file; freely defined by applications
	 */
	GIT_CONFIG_LEVEL_APP = 6,

	/**
	 * Represents the highest level available config file (i.e. the most
	 * specific config file available that actually is loaded)
	 */
	GIT_CONFIG_HIGHEST_LEVEL = -1,
}

//Declaration name in C language
enum
{
	GIT_CONFIG_LEVEL_PROGRAMDATA = .git_config_level_t.GIT_CONFIG_LEVEL_PROGRAMDATA,
	GIT_CONFIG_LEVEL_SYSTEM = .git_config_level_t.GIT_CONFIG_LEVEL_SYSTEM,
	GIT_CONFIG_LEVEL_XDG = .git_config_level_t.GIT_CONFIG_LEVEL_XDG,
	GIT_CONFIG_LEVEL_GLOBAL = .git_config_level_t.GIT_CONFIG_LEVEL_GLOBAL,
	GIT_CONFIG_LEVEL_LOCAL = .git_config_level_t.GIT_CONFIG_LEVEL_LOCAL,
	GIT_CONFIG_LEVEL_APP = .git_config_level_t.GIT_CONFIG_LEVEL_APP,
	GIT_CONFIG_HIGHEST_LEVEL = .git_config_level_t.GIT_CONFIG_HIGHEST_LEVEL,
}

/**
 * An entry in a configuration file
 */
struct git_config_entry
{
	/**
	 * Name of the entry (normalised)
	 */
	const (char)* name;

	/**
	 * String value of the entry
	 */
	const (char)* value;

	/**
	 * Depth of includes where this variable was found
	 */
	uint include_depth;

	/**
	 * Which config file this was found in
	 */
	.git_config_level_t level = cast(.git_config_level_t)(0);

	/**
	 * Free function for this entry
	 */
	void function(.git_config_entry* entry) free;

	/**
	 * Opaque value for the free function. Do not read or write
	 */
	void* payload;
}

/**
 * Free a config entry
 */
//GIT_EXTERN
void git_config_entry_free(.git_config_entry*);

/**
 * A config enumeration callback
 */
/*
 * Params:
 *      entry = the entry currently being enumerated
 *      payload = a user-specified pointer
 */
alias git_config_foreach_cb = int function(const (.git_config_entry)* entry, void* payload);

/**
 * An opaque structure for a configuration iterator
 */
alias git_config_iterator = libgit2.sys.config.git_config_iterator;

/**
 * Config var type
 */
enum git_configmap_t
{
	GIT_CONFIGMAP_FALSE = 0,
	GIT_CONFIGMAP_TRUE = 1,
	GIT_CONFIGMAP_INT32,
	GIT_CONFIGMAP_STRING,
}

//Declaration name in C language
enum
{
	GIT_CONFIGMAP_FALSE = .git_configmap_t.GIT_CONFIGMAP_FALSE,
	GIT_CONFIGMAP_TRUE = .git_configmap_t.GIT_CONFIGMAP_TRUE,
	GIT_CONFIGMAP_INT32 = .git_configmap_t.GIT_CONFIGMAP_INT32,
	GIT_CONFIGMAP_STRING = .git_configmap_t.GIT_CONFIGMAP_STRING,
}

/**
 * Mapping from config variables to values.
 */
struct git_configmap
{
	.git_configmap_t cvar_type;
	const (char)* str_match;
	int map_value;
}

/**
 * Locate the path to the global configuration file
 *
 * The user or global configuration file is usually
 * located in `$HOME/.gitconfig`.
 *
 * This method will try to guess the full path to that
 * file, if the file exists. The returned path
 * may be used on any `git_config` call to load the
 * global configuration file.
 *
 * This method will not guess the path to the xdg compatible
 * config file (.config/git/config).
 *
 * Params:
 *      out_ = Pointer to a user-allocated git_buf in which to store the path
 *
 * Returns: 0 if a global configuration file has been found. Its path will be stored in `out`.
 */
//GIT_EXTERN
int git_config_find_global(libgit2.buffer.git_buf* out_);

/**
 * Locate the path to the global xdg compatible configuration file
 *
 * The xdg compatible configuration file is usually
 * located in `$HOME/.config/git/config`.
 *
 * This method will try to guess the full path to that
 * file, if the file exists. The returned path
 * may be used on any `git_config` call to load the
 * xdg compatible configuration file.
 *
 * Params:
 *      out_ = Pointer to a user-allocated git_buf in which to store the path
 *
 * Returns: 0 if a xdg compatible configuration file has been found. Its path will be stored in `out`.
 */
//GIT_EXTERN
int git_config_find_xdg(libgit2.buffer.git_buf* out_);

/**
 * Locate the path to the system configuration file
 *
 * If /etc/gitconfig doesn't exist, it will look for
 * %PROGRAMFILES%\Git\etc\gitconfig.
 *
 * Params:
 *      out_ = Pointer to a user-allocated git_buf in which to store the path
 *
 * Returns: 0 if a system configuration file has been found. Its path will be stored in `out`.
 */
//GIT_EXTERN
int git_config_find_system(libgit2.buffer.git_buf* out_);

/**
 * Locate the path to the configuration file in ProgramData
 *
 * Look for the file in %PROGRAMDATA%\Git\config used by portable git.
 *
 * Params:
 *      out_ = Pointer to a user-allocated git_buf in which to store the path
 *
 * Returns: 0 if a ProgramData configuration file has been found. Its path will be stored in `out`.
 */
//GIT_EXTERN
int git_config_find_programdata(libgit2.buffer.git_buf* out_);

/**
 * Open the global, XDG and system configuration files
 *
 * Utility wrapper that finds the global, XDG and system configuration files
 * and opens them into a single prioritized config object that can be
 * used when accessing default config data outside a repository.
 *
 * Params:
 *      out_ = Pointer to store the config instance
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_open_default(libgit2.types.git_config** out_);

/**
 * Allocate a new configuration object
 *
 * This object is empty, so you have to add a file to it before you
 * can do anything with it.
 *
 * Params:
 *      out_ = pointer to the new configuration
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_new(libgit2.types.git_config** out_);

/**
 * Add an on-disk config file instance to an existing config
 *
 * The on-disk file pointed at by `path` will be opened and
 * parsed; it's expected to be a native Git config file following
 * the default Git config syntax (see man git-config).
 *
 * If the file does not exist, the file will still be added and it
 * will be created the first time we write to it.
 *
 * Note that the configuration object will free the file
 * automatically.
 *
 * Further queries on this config object will access each
 * of the config file instances in order (instances with
 * a higher priority level will be accessed first).
 *
 * Params:
 *      cfg = the configuration to add the file to
 *      path = path to the configuration file to add
 *      level = the priority level of the backend
 *      force = replace config file at the given priority level
 *      repo = optional repository to allow parsing of conditional includes
 *
 * Returns: 0 on success, git_error_code.GIT_EEXISTS when adding more than one file for a given priority level (and force_replace set to 0), git_error_code.GIT_ENOTFOUND when the file doesn't exist or error code
 */
//GIT_EXTERN
int git_config_add_file_ondisk(libgit2.types.git_config* cfg, const (char)* path, .git_config_level_t level, const (libgit2.types.git_repository)* repo, int force);

/**
 * Create a new config instance containing a single on-disk file
 *
 * This method is a simple utility wrapper for the following sequence
 * of calls:
 *	- git_config_new
 *	- git_config_add_file_ondisk
 *
 * Params:
 *      out_ = The configuration instance to create
 *      path = Path to the on-disk file to open
 *
 * Returns: 0 on success, or an error code
 */
//GIT_EXTERN
int git_config_open_ondisk(libgit2.types.git_config** out_, const (char)* path);

/**
 * Build a single-level focused config object from a multi-level one.
 *
 * The returned config object can be used to perform get/set/delete operations
 * on a single specific level.
 *
 * Getting several times the same level from the same parent multi-level config
 * will return different config instances, but containing the same config_file
 * instance.
 *
 * Params:
 *      out_ = The configuration instance to create
 *      parent = Multi-level config to search for the given level
 *      level = Configuration level to search for
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND if the passed level cannot be found in the multi-level parent config, or an error code
 */
//GIT_EXTERN
int git_config_open_level(libgit2.types.git_config** out_, const (libgit2.types.git_config)* parent, .git_config_level_t level);

/**
 * Open the global/XDG configuration file according to git's rules
 *
 * Git allows you to store your global configuration at
 * `$HOME/.gitconfig` or `$XDG_CONFIG_HOME/git/config`. For backwards
 * compatibility, the XDG file shouldn't be used unless the use has
 * created it explicitly. With this function you'll open the correct
 * one to write to.
 *
 * Params:
 *      out_ = pointer in which to store the config object
 *      config = the config object in which to look
 */
//GIT_EXTERN
int git_config_open_global(libgit2.types.git_config** out_, libgit2.types.git_config* config);

/**
 * Create a snapshot of the configuration
 *
 * Create a snapshot of the current state of a configuration, which
 * allows you to look into a consistent view of the configuration for
 * looking up complex values (e.g. a remote, submodule).
 *
 * The string returned when querying such a config object is valid
 * until it is freed.
 *
 * Params:
 *      out_ = pointer in which to store the snapshot config object
 *      config = configuration to snapshot
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_snapshot(libgit2.types.git_config** out_, libgit2.types.git_config* config);

/**
 * Free the configuration and its associated memory and files
 *
 * Params:
 *      cfg = the configuration to free
 */
//GIT_EXTERN
void git_config_free(libgit2.types.git_config* cfg);

/**
 * Get the git_config_entry of a config variable.
 *
 * Free the git_config_entry after use with `git_config_entry_free()`.
 *
 * Params:
 *      out_ = pointer to the variable git_config_entry
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_entry(.git_config_entry** out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get the value of an integer config variable.
 *
 * All config files will be looked into, in the order of their
 * defined level. A higher level means a higher priority. The
 * first occurrence of the variable will be returned here.
 *
 * Params:
 *      out_ = pointer to the variable where the value should be stored
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_int32(int* out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get the value of a long integer config variable.
 *
 * All config files will be looked into, in the order of their
 * defined level. A higher level means a higher priority. The
 * first occurrence of the variable will be returned here.
 *
 * Params:
 *      out_ = pointer to the variable where the value should be stored
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_int64(long* out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get the value of a boolean config variable.
 *
 * This function uses the usual C convention of 0 being false and
 * anything else true.
 *
 * All config files will be looked into, in the order of their
 * defined level. A higher level means a higher priority. The
 * first occurrence of the variable will be returned here.
 *
 * Params:
 *      out_ = pointer to the variable where the value should be stored
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_bool(int* out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get the value of a path config variable.
 *
 * A leading '~' will be expanded to the global search path \(which
 * defaults to the user's home directory but can be overridden via
 * `git_libgit2_opts()`.
 *
 * All config files will be looked into, in the order of their
 * defined level. A higher level means a higher priority. The
 * first occurrence of the variable will be returned here.
 *
 * Params:
 *      out_ = the buffer in which to store the result
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_path(libgit2.buffer.git_buf* out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get the value of a string config variable.
 *
 * This function can only be used on snapshot config objects. The
 * string is owned by the config and should not be freed by the
 * user. The pointer will be valid until the config is freed.
 *
 * All config files will be looked into, in the order of their
 * defined level. A higher level means a higher priority. The
 * first occurrence of the variable will be returned here.
 *
 * Params:
 *      out_ = pointer to the string
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_string(const (char)** out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get the value of a string config variable.
 *
 * The value of the config will be copied into the buffer.
 *
 * All config files will be looked into, in the order of their
 * defined level. A higher level means a higher priority. The
 * first occurrence of the variable will be returned here.
 *
 * Params:
 *      out_ = buffer in which to store the string
 *      cfg = where to look for the variable
 *      name = the variable's name
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_get_string_buf(libgit2.buffer.git_buf* out_, const (libgit2.types.git_config)* cfg, const (char)* name);

/**
 * Get each value of a multivar in a foreach callback
 *
 * The callback will be called on each variable found
 *
 * The regular expression is applied case-sensitively on the normalized form of
 * the variable name: the section and variable parts are lower-cased. The
 * subsection is left unchanged.
 *
 * Params:
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      regexp = regular expression to filter which variables we're interested in. Use null to indicate all
 *      callback = the function to be called on each value of the variable
 *      payload = opaque pointer to pass to the callback
 */
//GIT_EXTERN
int git_config_get_multivar_foreach(const (libgit2.types.git_config)* cfg, const (char)* name, const (char)* regexp, .git_config_foreach_cb callback, void* payload);

/**
 * Get each value of a multivar
 *
 * The regular expression is applied case-sensitively on the normalized form of
 * the variable name: the section and variable parts are lower-cased. The
 * subsection is left unchanged.
 *
 * Params:
 *      out_ = pointer to store the iterator
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      regexp = regular expression to filter which variables we're interested in. Use null to indicate all
 */
//GIT_EXTERN
int git_config_multivar_iterator_new(.git_config_iterator** out_, const (libgit2.types.git_config)* cfg, const (char)* name, const (char)* regexp);

/**
 * Return the current entry and advance the iterator
 *
 * The pointers returned by this function are valid until the iterator
 * is freed.
 *
 * Params:
 *      entry = pointer to store the entry
 *      iter = the iterator
 *
 * Returns: 0 or an error code. git_error_code.GIT_ITEROVER if the iteration has completed
 */
//GIT_EXTERN
int git_config_next(.git_config_entry** entry, .git_config_iterator* iter);

/**
 * Free a config iterator
 *
 * Params:
 *      iter = the iterator to free
 */
//GIT_EXTERN
void git_config_iterator_free(.git_config_iterator* iter);

/**
 * Set the value of an integer config variable in the config file
 * with the highest level (usually the local one).
 *
 * Params:
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      value = Integer value for the variable
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_set_int32(libgit2.types.git_config* cfg, const (char)* name, int value);

/**
 * Set the value of a long integer config variable in the config file
 * with the highest level (usually the local one).
 *
 * Params:
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      value = Long integer value for the variable
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_set_int64(libgit2.types.git_config* cfg, const (char)* name, long value);

/**
 * Set the value of a boolean config variable in the config file
 * with the highest level (usually the local one).
 *
 * Params:
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      value = the value to store
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_set_bool(libgit2.types.git_config* cfg, const (char)* name, int value);

/**
 * Set the value of a string config variable in the config file
 * with the highest level (usually the local one).
 *
 * A copy of the string is made and the user is free to use it
 * afterwards.
 *
 * Params:
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      value = the string to store.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_set_string(libgit2.types.git_config* cfg, const (char)* name, const (char)* value);

/**
 * Set a multivar in the local config file.
 *
 * The regular expression is applied case-sensitively on the value.
 *
 * Params:
 *      cfg = where to look for the variable
 *      name = the variable's name
 *      regexp = a regular expression to indicate which values to replace
 *      value = the new value.
 */
//GIT_EXTERN
int git_config_set_multivar(libgit2.types.git_config* cfg, const (char)* name, const (char)* regexp, const (char)* value);

/**
 * Delete a config variable from the config file
 * with the highest level (usually the local one).
 *
 * Params:
 *      cfg = the configuration
 *      name = the variable to delete
 */
//GIT_EXTERN
int git_config_delete_entry(libgit2.types.git_config* cfg, const (char)* name);

/**
 * Deletes one or several entries from a multivar in the local config file.
 *
 * The regular expression is applied case-sensitively on the value.
 *
 * Params:
 *      cfg = where to look for the variables
 *      name = the variable's name
 *      regexp = a regular expression to indicate which values to delete
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_delete_multivar(libgit2.types.git_config* cfg, const (char)* name, const (char)* regexp);

/**
 * Perform an operation on each config variable.
 *
 * The callback receives the normalized name and value of each variable
 * in the config backend, and the data pointer passed to this function.
 * If the callback returns a non-zero value, the function stops iterating
 * and returns that value to the caller.
 *
 * The pointers passed to the callback are only valid as long as the
 * iteration is ongoing.
 *
 * Params:
 *      cfg = where to get the variables from
 *      callback = the function to call on each variable
 *      payload = the data to pass to the callback
 *
 * Returns: 0 on success, non-zero callback return value, or error code
 */
//GIT_EXTERN
int git_config_foreach(const (libgit2.types.git_config)* cfg, .git_config_foreach_cb callback, void* payload);

/**
 * Iterate over all the config variables
 *
 * Use `git_config_next` to advance the iteration and
 * `git_config_iterator_free` when done.
 *
 * Params:
 *      out_ = pointer to store the iterator
 *      cfg = where to ge the variables from
 */
//GIT_EXTERN
int git_config_iterator_new(.git_config_iterator** out_, const (libgit2.types.git_config)* cfg);

/**
 * Iterate over all the config variables whose name matches a pattern
 *
 * Use `git_config_next` to advance the iteration and
 * `git_config_iterator_free` when done.
 *
 * The regular expression is applied case-sensitively on the normalized form of
 * the variable name: the section and variable parts are lower-cased. The
 * subsection is left unchanged.
 *
 * Params:
 *      out_ = pointer to store the iterator
 *      cfg = where to ge the variables from
 *      regexp = regular expression to match the names
 */
//GIT_EXTERN
int git_config_iterator_glob_new(.git_config_iterator** out_, const (libgit2.types.git_config)* cfg, const (char)* regexp);

/**
 * Perform an operation on each config variable matching a regular expression.
 *
 * This behaves like `git_config_foreach` with an additional filter of a
 * regular expression that filters which config keys are passed to the
 * callback.
 *
 * The regular expression is applied case-sensitively on the normalized form of
 * the variable name: the section and variable parts are lower-cased. The
 * subsection is left unchanged.
 *
 * The regular expression is applied case-sensitively on the normalized form of
 * the variable name: the case-insensitive parts are lower-case.
 *
 * Params:
 *      cfg = where to get the variables from
 *      regexp = regular expression to match against config names
 *      callback = the function to call on each variable
 *      payload = the data to pass to the callback
 *
 * Returns: 0 or the return value of the callback which didn't return 0
 */
//GIT_EXTERN
int git_config_foreach_match(const (libgit2.types.git_config)* cfg, const (char)* regexp, .git_config_foreach_cb callback, void* payload);

/**
 * Query the value of a config variable and return it mapped to
 * an integer constant.
 *
 * This is a helper method to easily map different possible values
 * to a variable to integer constants that easily identify them.
 *
 * A mapping array looks as follows:
 *
 *	git_configmap[] autocrlf_mapping = {
 *		{GIT_CVAR_FALSE, null, GIT_AUTO_CRLF_FALSE},
 *		{GIT_CVAR_TRUE, null, GIT_AUTO_CRLF_TRUE},
 *		{GIT_CVAR_STRING, "input", GIT_AUTO_CRLF_INPUT},
 *		{GIT_CVAR_STRING, "default", GIT_AUTO_CRLF_DEFAULT}};
 *
 * On any "false" value for the variable (e.g. "false", "FALSE", "no"), the
 * mapping will store `GIT_AUTO_CRLF_FALSE` in the `out` parameter.
 *
 * The same thing applies for any "true" value such as "true", "yes" or "1",
 *storing the `GIT_AUTO_CRLF_TRUE` variable.
 *
 * Otherwise, if the value matches the string "input" (with case insensitive
 *comparison), the given constant will be stored in `out`, and likewise for
 *"default".
 *
 * If not a single match can be made to store in `out`, an error code will be
 * returned.
 *
 * Params:
 *      out_ = place to store the result of the mapping
 *      cfg = config file to get the variables from
 *      name = name of the config variable to lookup
 *      maps = array of `git_configmap` objects specifying the possible mappings
 *      map_n = number of mapping objects in `maps`
 *
 * Returns: 0 on success, error code otherwise
 */
//GIT_EXTERN
int git_config_get_mapped(int* out_, const (libgit2.types.git_config)* cfg, const (char)* name, const (.git_configmap)* maps, size_t map_n);

/**
 * Maps a string value to an integer constant
 *
 * Params:
 *      out_ = place to store the result of the parsing
 *      maps = array of `git_configmap` objects specifying the possible mappings
 *      map_n = number of mapping objects in `maps`
 *      value = value to parse
 */
//GIT_EXTERN
int git_config_lookup_map_value(int* out_, const (.git_configmap)* maps, size_t map_n, const (char)* value);

/**
 * Parse a string value as a bool.
 *
 * Valid values for true are: 'true', 'yes', 'on', 1 or any
 *  number different from 0
 * Valid values for false are: 'false', 'no', 'off', 0
 *
 * Params:
 *      out_ = place to store the result of the parsing
 *      value = value to parse
 */
//GIT_EXTERN
int git_config_parse_bool(int* out_, const (char)* value);

/**
 * Parse a string value as an int32.
 *
 * An optional value suffix of 'k', 'm', or 'g' will
 * cause the value to be multiplied by 1024, 1048576,
 * or 1073741824 prior to output.
 *
 * Params:
 *      out_ = place to store the result of the parsing
 *      value = value to parse
 */
//GIT_EXTERN
int git_config_parse_int32(int* out_, const (char)* value);

/**
 * Parse a string value as an int64.
 *
 * An optional value suffix of 'k', 'm', or 'g' will
 * cause the value to be multiplied by 1024, 1048576,
 * or 1073741824 prior to output.
 *
 * Params:
 *      out_ = place to store the result of the parsing
 *      value = value to parse
 */
//GIT_EXTERN
int git_config_parse_int64(long* out_, const (char)* value);

/**
 * Parse a string value as a path.
 *
 * A leading '~' will be expanded to the global search path \(which
 * defaults to the user's home directory but can be overridden via
 * `git_libgit2_opts()`.
 *
 * If the value does not begin with a tilde, the input will be
 * returned.
 *
 * Params:
 *      out_ = placae to store the result of parsing
 *      value = the path to evaluate
 */
//GIT_EXTERN
int git_config_parse_path(libgit2.buffer.git_buf* out_, const (char)* value);

/**
 * Perform an operation on each config variable in a given config backend,
 * matching a regular expression.
 *
 * This behaves like `git_config_foreach_match` except that only config
 * entries from the given backend entry are enumerated.
 *
 * The regular expression is applied case-sensitively on the normalized form of
 * the variable name: the section and variable parts are lower-cased. The
 * subsection is left unchanged.
 *
 * Params:
 *      backend = where to get the variables from
 *      regexp = regular expression to match against config names (can be null)
 *      callback = the function to call on each variable
 *      payload = the data to pass to the callback
 */
//GIT_EXTERN
int git_config_backend_foreach_match(libgit2.types.git_config_backend* backend, const (char)* regexp, .git_config_foreach_cb callback, void* payload);

/**
 * Lock the backend with the highest priority
 *
 * Locking disallows anybody else from writing to that backend. Any
 * updates made after locking will not be visible to a reader until
 * the file is unlocked.
 *
 * You can apply the changes by calling `git_transaction_commit()`
 * before freeing the transaction. Either of these actions will unlock
 * the config.
 *
 * Params:
 *      tx = the resulting transaction, use this to commit or undo the changes
 *      cfg = the configuration in which to lock
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_config_lock(libgit2.types.git_transaction** tx, libgit2.types.git_config* cfg);

/* @} */
