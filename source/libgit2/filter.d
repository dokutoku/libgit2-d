/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.filter;


private static import libgit2.buffer;
private static import libgit2.oid;
private static import libgit2.sys.filter;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/filter.h
 * @brief Git filter APIs
 *
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Filters are applied in one of two directions: smudging - which is
 * exporting a file from the Git object database to the working directory,
 * and cleaning - which is importing a file from the working directory to
 * the Git object database.  These values control which direction of
 * change is being applied.
 */
enum git_filter_mode_t
{
	GIT_FILTER_TO_WORKTREE = 0,
	GIT_FILTER_SMUDGE = GIT_FILTER_TO_WORKTREE,
	GIT_FILTER_TO_ODB = 1,
	GIT_FILTER_CLEAN = GIT_FILTER_TO_ODB,
}

//Declaration name in C language
enum
{
	GIT_FILTER_TO_WORKTREE = .git_filter_mode_t.GIT_FILTER_TO_WORKTREE,
	GIT_FILTER_SMUDGE = .git_filter_mode_t.GIT_FILTER_SMUDGE,
	GIT_FILTER_TO_ODB = .git_filter_mode_t.GIT_FILTER_TO_ODB,
	GIT_FILTER_CLEAN = .git_filter_mode_t.GIT_FILTER_CLEAN,
}

/**
 * Filter option flags.
 */
enum git_filter_flag_t
{
	GIT_FILTER_DEFAULT = 0u,

	/**
	 * Don't error for `safecrlf` violations, allow them to continue.
	 */
	GIT_FILTER_ALLOW_UNSAFE = 1u << 0,

	/**
	 * Don't load `/etc/gitattributes` (or the system equivalent)
	 */
	GIT_FILTER_NO_SYSTEM_ATTRIBUTES = 1u << 1,

	/**
	 * Load attributes from `.gitattributes` in the root of HEAD
	 */
	GIT_FILTER_ATTRIBUTES_FROM_HEAD = 1u << 2,

	/**
	 * Load attributes from `.gitattributes` in a given commit.
	 * This can only be specified in a `git_filter_options`.
	 */
	GIT_FILTER_ATTRIBUTES_FROM_COMMIT = 1u << 3,
}

//Declaration name in C language
enum
{
	GIT_FILTER_DEFAULT = .git_filter_flag_t.GIT_FILTER_DEFAULT,
	GIT_FILTER_ALLOW_UNSAFE = .git_filter_flag_t.GIT_FILTER_ALLOW_UNSAFE,
	GIT_FILTER_NO_SYSTEM_ATTRIBUTES = .git_filter_flag_t.GIT_FILTER_NO_SYSTEM_ATTRIBUTES,
	GIT_FILTER_ATTRIBUTES_FROM_HEAD = .git_filter_flag_t.GIT_FILTER_ATTRIBUTES_FROM_HEAD,
	GIT_FILTER_ATTRIBUTES_FROM_COMMIT = .git_filter_flag_t.GIT_FILTER_ATTRIBUTES_FROM_COMMIT,
}

/**
 * Filtering options
 */
struct git_filter_options
{
	uint version_;

	/**
	 * See `git_filter_flag_t` above
	 */
	uint flags;

	version (GIT_DEPRECATE_HARD) {
		void* reserved;
	} else {
		libgit2.oid.git_oid* commit_id;
	}

	/**
	 * The commit to load attributes from, when
	 * `GIT_FILTER_ATTRIBUTES_FROM_COMMIT` is specified.
	 */
	libgit2.oid.git_oid attr_commit_id;
}

enum GIT_FILTER_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_filter_options GIT_FILTER_OPTIONS_INIT()

	do
	{
		.git_filter_options OUTPUT =
		{
			version_: .GIT_FILTER_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * A filter that can transform file data
 *
 * This represents a filter that can be used to transform or even replace
 * file data.  Libgit2 includes one built in filter and it is possible to
 * write your own (see git2/sys/filter.h for information on that).
 *
 * The two builtin filters are:
 *
 * * "crlf" which uses the complex rules with the "text", "eol", and
 *   "crlf" file attributes to decide how to convert between LF and CRLF
 *   line endings
 * * "ident" which replaces "$Id$" in a blob with "$Id: <blob OID>$" upon
 *   checkout and replaced "$Id: <anything>$" with "$Id$" on checkin.
 */
alias git_filter = libgit2.sys.filter.git_filter;

/**
 * List of filters to be applied
 *
 * This represents a list of filters to be applied to a file / blob.  You
 * can build the list with one call, apply it with another, and dispose it
 * with a third.  In typical usage, there are not many occasions where a
 * git_filter_list is needed directly since the library will generally
 * handle conversions for you, but it can be convenient to be able to
 * build and apply the list sometimes.
 */
struct git_filter_list;

/**
 * Load the filter list for a given path.
 *
 * This will return 0 (success) but set the output git_filter_list to null
 * if no filters are requested for the given file.
 *
 * Params:
 *      filters = Output newly created git_filter_list (or null)
 *      repo = Repository object that contains `path`
 *      blob = The blob to which the filter will be applied (if known)
 *      path = Relative path of the file to be filtered
 *      mode = Filtering direction (WT->ODB or ODB->WT)
 *      flags = Combination of `git_filter_flag_t` flags
 *
 * Returns: 0 on success (which could still return null if no filters are needed for the requested file), <0 on error
 */
@GIT_EXTERN
int git_filter_list_load(.git_filter_list** filters, libgit2.types.git_repository* repo, libgit2.types.git_blob* blob, /* can be null */
                     const (char)* path, .git_filter_mode_t mode, uint flags);

/**
 * Load the filter list for a given path.
 *
 * This will return 0 (success) but set the output git_filter_list to null
 * if no filters are requested for the given file.
 *
 * Params:
 *      filters = Output newly created git_filter_list (or null)
 *      repo = Repository object that contains `path`
 *      blob = The blob to which the filter will be applied (if known)
 *      path = Relative path of the file to be filtered
 *      mode = Filtering direction (WT->ODB or ODB->WT)
 *      opts = The `git_filter_options` to use when loading filters
 *
 * Returns: 0 on success (which could still return null if no filters are needed for the requested file), <0 on error
 */
@GIT_EXTERN
int git_filter_list_load_ext(.git_filter_list** filters, libgit2.types.git_repository* repo, libgit2.types.git_blob* blob, const (char)* path, .git_filter_mode_t mode, .git_filter_options* opts);

/**
 * Query the filter list to see if a given filter (by name) will run.
 * The built-in filters "crlf" and "ident" can be queried, otherwise this
 * is the name of the filter specified by the filter attribute.
 *
 * This will return 0 if the given filter is not in the list, or 1 if
 * the filter will be applied.
 *
 * Params:
 *      filters = A loaded git_filter_list (or null)
 *      name = The name of the filter to query
 *
 * Returns: 1 if the filter is in the list, 0 otherwise
 */
@GIT_EXTERN
int git_filter_list_contains(.git_filter_list* filters, const (char)* name);

/**
 * Apply filter list to a data buffer.
 *
 * Params:
 *      out_ = Buffer to store the result of the filtering
 *      filters = A loaded git_filter_list (or null)
 *      in_ = Buffer containing the data to filter
 *      in_len = The length of the input buffer
 *
 * Returns: 0 on success, an error code otherwise
 */
@GIT_EXTERN
int git_filter_list_apply_to_buffer(libgit2.buffer.git_buf* out_, .git_filter_list* filters, const (char)* in_, size_t in_len);

/**
 * Apply a filter list to the contents of a file on disk
 *
 * Params:
 *      out_ = buffer into which to store the filtered file
 *      filters = the list of filters to apply
 *      repo = the repository in which to perform the filtering
 *      path = the path of the file to filter, a relative path will be taken as relative to the workdir
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_filter_list_apply_to_file(libgit2.buffer.git_buf* out_, .git_filter_list* filters, libgit2.types.git_repository* repo, const (char)* path);

/**
 * Apply a filter list to the contents of a blob
 *
 * Params:
 *      out_ = buffer into which to store the filtered file
 *      filters = the list of filters to apply
 *      blob = the blob to filter
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_filter_list_apply_to_blob(libgit2.buffer.git_buf* out_, .git_filter_list* filters, libgit2.types.git_blob* blob);

/**
 * Apply a filter list to an arbitrary buffer as a stream
 *
 * Params:
 *      filters = the list of filters to apply
 *      data = the buffer to filter
 *      len = the size of the buffer
 *      target = the stream into which the data will be written
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_filter_list_stream_buffer(.git_filter_list* filters, const (char)* data, size_t len, libgit2.types.git_writestream* target);

/**
 * Apply a filter list to a file as a stream
 *
 * Params:
 *      filters = the list of filters to apply
 *      repo = the repository in which to perform the filtering
 *      path = the path of the file to filter, a relative path will be taken as relative to the workdir
 *      target = the stream into which the data will be written
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_filter_list_stream_file(.git_filter_list* filters, libgit2.types.git_repository* repo, const (char)* path, libgit2.types.git_writestream* target);

/**
 * Apply a filter list to a blob as a stream
 *
 * Params:
 *      filters = the list of filters to apply
 *      blob = the blob to filter
 *      target = the stream into which the data will be written
 *
 * Returns: 0 or an error code.
 */
@GIT_EXTERN
int git_filter_list_stream_blob(.git_filter_list* filters, libgit2.types.git_blob* blob, libgit2.types.git_writestream* target);

/**
 * Free a git_filter_list
 *
 * Params:
 *      filters = A git_filter_list created by `git_filter_list_load`
 */
@GIT_EXTERN
void git_filter_list_free(.git_filter_list* filters);

/* @} */
