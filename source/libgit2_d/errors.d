/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.errors;


/*
 * @file git2/errors.h
 * @brief Git error handling routines and variables
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Generic return codes
 */
enum git_error_code
{
	/**
	 * No error
	 */
	GIT_OK = 0,

	/**
	 * Generic error
	 */
	GIT_ERROR = -1,

	/**
	 * Requested object could not be found
	 */
	GIT_ENOTFOUND = -3,

	/**
	 * Object exists preventing operation
	 */
	GIT_EEXISTS = -4,

	/**
	 * More than one object matches
	 */
	GIT_EAMBIGUOUS = -5,

	/**
	 * Output buffer too short to hold data
	 */
	GIT_EBUFS = -6,

	/**
	 * GIT_EUSER is a special error that is never generated by libgit2
	 * code.  You can return it from a callback (e.g to stop an iteration)
	 * to know that it was generated by the callback and not by libgit2.
	 */
	GIT_EUSER = -7,

	/**
	 * Operation not allowed on bare repository
	 */
	GIT_EBAREREPO = -8,

	/**
	 * HEAD refers to branch with no commits
	 */
	GIT_EUNBORNBRANCH = -9,

	/**
	 * Merge in progress prevented operation
	 */
	GIT_EUNMERGED = -10,

	/**
	 * Reference was not fast-forwardable
	 */
	GIT_ENONFASTFORWARD = -11,

	/**
	 * Name/ref spec was not in a valid format
	 */
	GIT_EINVALIDSPEC = -12,

	/**
	 * Checkout conflicts prevented operation
	 */
	GIT_ECONFLICT = -13,

	/**
	 * Lock file prevented operation
	 */
	GIT_ELOCKED = -14,

	/**
	 * Reference value does not match expected
	 */
	GIT_EMODIFIED = -15,

	/**
	 * Authentication error
	 */
	GIT_EAUTH = -16,

	/**
	 * Server certificate is invalid
	 */
	GIT_ECERTIFICATE = -17,

	/**
	 * Patch/merge has already been applied
	 */
	GIT_EAPPLIED = -18,

	/**
	 * The requested peel operation is not possible
	 */
	GIT_EPEEL = -19,

	/**
	 * Unexpected EOF
	 */
	GIT_EEOF = -20,

	/**
	 * Invalid operation or input
	 */
	GIT_EINVALID = -21,

	/**
	 * Uncommitted changes in index prevented operation
	 */
	GIT_EUNCOMMITTED = -22,

	/**
	 * The operation is not valid for a directory
	 */
	GIT_EDIRECTORY = -23,

	/**
	 * A merge conflict exists and cannot continue
	 */
	GIT_EMERGECONFLICT = -24,

	/**
	 * A user-configured callback refused to act
	 */
	GIT_PASSTHROUGH = -30,

	/**
	 * Signals end of iteration with iterator
	 */
	GIT_ITEROVER = -31,

	/**
	 * Internal only
	 */
	GIT_RETRY = -32,

	/**
	 * Hashsum mismatch in object
	 */
	GIT_EMISMATCH = -33,

	/**
	 * Unsaved changes in the index would be overwritten
	 */
	GIT_EINDEXDIRTY = -34,

	/**
	 * Patch application failed
	 */
	GIT_EAPPLYFAIL = -35,
}

//Declaration name in C language
enum
{
	GIT_OK = .git_error_code.GIT_OK,
	GIT_ERROR = .git_error_code.GIT_ERROR,
	GIT_ENOTFOUND = .git_error_code.GIT_ENOTFOUND,
	GIT_EEXISTS = .git_error_code.GIT_EEXISTS,
	GIT_EAMBIGUOUS = .git_error_code.GIT_EAMBIGUOUS,
	GIT_EBUFS = .git_error_code.GIT_EBUFS,
	GIT_EUSER = .git_error_code.GIT_EUSER,
	GIT_EBAREREPO = .git_error_code.GIT_EBAREREPO,
	GIT_EUNBORNBRANCH = .git_error_code.GIT_EUNBORNBRANCH,
	GIT_EUNMERGED = .git_error_code.GIT_EUNMERGED,
	GIT_ENONFASTFORWARD = .git_error_code.GIT_ENONFASTFORWARD,
	GIT_EINVALIDSPEC = .git_error_code.GIT_EINVALIDSPEC,
	GIT_ECONFLICT = .git_error_code.GIT_ECONFLICT,
	GIT_ELOCKED = .git_error_code.GIT_ELOCKED,
	GIT_EMODIFIED = .git_error_code.GIT_EMODIFIED,
	GIT_EAUTH = .git_error_code.GIT_EAUTH,
	GIT_ECERTIFICATE = .git_error_code.GIT_ECERTIFICATE,
	GIT_EAPPLIED = .git_error_code.GIT_EAPPLIED,
	GIT_EPEEL = .git_error_code.GIT_EPEEL,
	GIT_EEOF = .git_error_code.GIT_EEOF,
	GIT_EINVALID = .git_error_code.GIT_EINVALID,
	GIT_EUNCOMMITTED = .git_error_code.GIT_EUNCOMMITTED,
	GIT_EDIRECTORY = .git_error_code.GIT_EDIRECTORY,
	GIT_EMERGECONFLICT = .git_error_code.GIT_EMERGECONFLICT,
	GIT_PASSTHROUGH = .git_error_code.GIT_PASSTHROUGH,
	GIT_ITEROVER = .git_error_code.GIT_ITEROVER,
	GIT_RETRY = .git_error_code.GIT_RETRY,
	GIT_EMISMATCH = .git_error_code.GIT_EMISMATCH,
	GIT_EINDEXDIRTY = .git_error_code.GIT_EINDEXDIRTY,
	GIT_EAPPLYFAIL = .git_error_code.GIT_EAPPLYFAIL,
}

/**
 * Structure to store extra details of the last error that occurred.
 *
 * This is kept on a per-thread basis if GIT_THREADS was defined when the
 * library was build, otherwise one is kept globally for the library
 */
struct git_error
{
	char* message;
	int klass;
}

/**
 * Error classes
 */
enum git_error_t
{
	GIT_ERROR_NONE = 0,
	GIT_ERROR_NOMEMORY,
	GIT_ERROR_OS,
	GIT_ERROR_INVALID,
	GIT_ERROR_REFERENCE,
	GIT_ERROR_ZLIB,
	GIT_ERROR_REPOSITORY,
	GIT_ERROR_CONFIG,
	GIT_ERROR_REGEX,
	GIT_ERROR_ODB,
	GIT_ERROR_INDEX,
	GIT_ERROR_OBJECT,
	GIT_ERROR_NET,
	GIT_ERROR_TAG,
	GIT_ERROR_TREE,
	GIT_ERROR_INDEXER,
	GIT_ERROR_SSL,
	GIT_ERROR_SUBMODULE,
	GIT_ERROR_THREAD,
	GIT_ERROR_STASH,
	GIT_ERROR_CHECKOUT,
	GIT_ERROR_FETCHHEAD,
	GIT_ERROR_MERGE,
	GIT_ERROR_SSH,
	GIT_ERROR_FILTER,
	GIT_ERROR_REVERT,
	GIT_ERROR_CALLBACK,
	GIT_ERROR_CHERRYPICK,
	GIT_ERROR_DESCRIBE,
	GIT_ERROR_REBASE,
	GIT_ERROR_FILESYSTEM,
	GIT_ERROR_PATCH,
	GIT_ERROR_WORKTREE,
	GIT_ERROR_SHA1,
	GIT_ERROR_HTTP,
	GIT_ERROR_INTERNAL,
}

//Declaration name in C language
enum
{
	GIT_ERROR_NONE = .git_error_t.GIT_ERROR_NONE,
	GIT_ERROR_NOMEMORY = .git_error_t.GIT_ERROR_NOMEMORY,
	GIT_ERROR_OS = .git_error_t.GIT_ERROR_OS,
	GIT_ERROR_INVALID = .git_error_t.GIT_ERROR_INVALID,
	GIT_ERROR_REFERENCE = .git_error_t.GIT_ERROR_REFERENCE,
	GIT_ERROR_ZLIB = .git_error_t.GIT_ERROR_ZLIB,
	GIT_ERROR_REPOSITORY = .git_error_t.GIT_ERROR_REPOSITORY,
	GIT_ERROR_CONFIG = .git_error_t.GIT_ERROR_CONFIG,
	GIT_ERROR_REGEX = .git_error_t.GIT_ERROR_REGEX,
	GIT_ERROR_ODB = .git_error_t.GIT_ERROR_ODB,
	GIT_ERROR_INDEX = .git_error_t.GIT_ERROR_INDEX,
	GIT_ERROR_OBJECT = .git_error_t.GIT_ERROR_OBJECT,
	GIT_ERROR_NET = .git_error_t.GIT_ERROR_NET,
	GIT_ERROR_TAG = .git_error_t.GIT_ERROR_TAG,
	GIT_ERROR_TREE = .git_error_t.GIT_ERROR_TREE,
	GIT_ERROR_INDEXER = .git_error_t.GIT_ERROR_INDEXER,
	GIT_ERROR_SSL = .git_error_t.GIT_ERROR_SSL,
	GIT_ERROR_SUBMODULE = .git_error_t.GIT_ERROR_SUBMODULE,
	GIT_ERROR_THREAD = .git_error_t.GIT_ERROR_THREAD,
	GIT_ERROR_STASH = .git_error_t.GIT_ERROR_STASH,
	GIT_ERROR_CHECKOUT = .git_error_t.GIT_ERROR_CHECKOUT,
	GIT_ERROR_FETCHHEAD = .git_error_t.GIT_ERROR_FETCHHEAD,
	GIT_ERROR_MERGE = .git_error_t.GIT_ERROR_MERGE,
	GIT_ERROR_SSH = .git_error_t.GIT_ERROR_SSH,
	GIT_ERROR_FILTER = .git_error_t.GIT_ERROR_FILTER,
	GIT_ERROR_REVERT = .git_error_t.GIT_ERROR_REVERT,
	GIT_ERROR_CALLBACK = .git_error_t.GIT_ERROR_CALLBACK,
	GIT_ERROR_CHERRYPICK = .git_error_t.GIT_ERROR_CHERRYPICK,
	GIT_ERROR_DESCRIBE = .git_error_t.GIT_ERROR_DESCRIBE,
	GIT_ERROR_REBASE = .git_error_t.GIT_ERROR_REBASE,
	GIT_ERROR_FILESYSTEM = .git_error_t.GIT_ERROR_FILESYSTEM,
	GIT_ERROR_PATCH = .git_error_t.GIT_ERROR_PATCH,
	GIT_ERROR_WORKTREE = .git_error_t.GIT_ERROR_WORKTREE,
	GIT_ERROR_SHA1 = .git_error_t.GIT_ERROR_SHA1,
	GIT_ERROR_HTTP = .git_error_t.GIT_ERROR_HTTP,
	GIT_ERROR_INTERNAL = .git_error_t.GIT_ERROR_INTERNAL,
}

/**
 * Return the last `git_error` object that was generated for the
 * current thread.
 *
 * The default behaviour of this function is to return NULL if no previous error has occurred.
 * However, libgit2's error strings are not cleared aggressively, so a prior
 * (unrelated) error may be returned. This can be avoided by only calling
 * this function if the prior call to a libgit2 API returned an error.
 *
 * Returns: A git_error object.
 */
//GIT_EXTERN
const (.git_error)* git_error_last();

/**
 * Clear the last library error that occurred for this thread.
 */
//GIT_EXTERN
void git_error_clear();

/**
 * Set the error message string for this thread.
 *
 * This function is public so that custom ODB backends and the like can
 * relay an error message through libgit2.  Most regular users of libgit2
 * will never need to call this function -- actually, calling it in most
 * circumstances (for example, calling from within a callback function)
 * will just end up having the value overwritten by libgit2 internals.
 *
 * This error message is stored in thread-local storage and only applies
 * to the particular thread that this libgit2 call is made from.
 *
 * Params:
 *      error_class = One of the `git_error_t` enum above describing the general subsystem that is responsible for the error.
 *      string_ = The formatted error message to keep
 *
 * Returns: 0 on success or -1 on failure
 */
//GIT_EXTERN
int git_error_set_str(int error_class, const (char)* string_);

/**
 * Set the error message to a special value for memory allocation failure.
 *
 * The normal `git_error_set_str()` function attempts to `strdup()` the
 * string that is passed in.  This is not a good idea when the error in
 * question is a memory allocation failure.  That circumstance has a
 * special setter function that sets the error string to a known and
 * statically allocated internal value.
 */
//GIT_EXTERN
void git_error_set_oom();

/* @} */
