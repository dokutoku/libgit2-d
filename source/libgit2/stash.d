/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.stash;


private static import libgit2.checkout;
private static import libgit2.oid;
private static import libgit2.strarray;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/stash.h
 * @brief Git stash management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Stash flags
 */
enum git_stash_flags
{
	/**
	 * No option, default
	 */
	GIT_STASH_DEFAULT = 0,

	/**
	 * All changes already added to the index are left intact in
	 * the working directory
	 */
	GIT_STASH_KEEP_INDEX = 1 << 0,

	/**
	 * All untracked files are also stashed and then cleaned up
	 * from the working directory
	 */
	GIT_STASH_INCLUDE_UNTRACKED = 1 << 1,

	/**
	 * All ignored files are also stashed and then cleaned up from
	 * the working directory
	 */
	GIT_STASH_INCLUDE_IGNORED = 1 << 2,

	/**
	 * All changes in the index and working directory are left intact
	 */
	GIT_STASH_KEEP_ALL = 1 << 3,
}

//Declaration name in C language
enum
{
	GIT_STASH_DEFAULT = .git_stash_flags.GIT_STASH_DEFAULT,
	GIT_STASH_KEEP_INDEX = .git_stash_flags.GIT_STASH_KEEP_INDEX,
	GIT_STASH_INCLUDE_UNTRACKED = .git_stash_flags.GIT_STASH_INCLUDE_UNTRACKED,
	GIT_STASH_INCLUDE_IGNORED = .git_stash_flags.GIT_STASH_INCLUDE_IGNORED,
	GIT_STASH_KEEP_ALL = .git_stash_flags.GIT_STASH_KEEP_ALL,
}

/**
 * Save the local modifications to a new stash.
 *
 * Params:
 *      out_ = Object id of the commit containing the stashed state. This commit is also the target of the direct reference refs/stash.
 *      repo = The owning repository.
 *      stasher = The identity of the person performing the stashing.
 *      message = Optional description along with the stashed state.
 *      flags = Flags to control the stashing process. (see GIT_STASH_* above)
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND where there's nothing to stash, or error code.
 */
@GIT_EXTERN
int git_stash_save(libgit2.oid.git_oid* out_, libgit2.types.git_repository* repo, const (libgit2.types.git_signature)* stasher, const (char)* message, uint flags);

/**
 * Stash save options structure
 *
 * Initialize with `GIT_STASH_SAVE_OPTIONS_INIT`. Alternatively, you can
 * use `git_stash_save_options_init`.
 *
 */
struct git_stash_save_options
{
	uint version_;

	/**
	 * Flags to control the stashing process. (see GIT_STASH_* above)
	 */
	uint flags;

	/**
	 * The identity of the person performing the stashing.
	 */
	const (libgit2.types.git_signature)* stasher;

	/**
	 * Optional description along with the stashed state.
	 */
	const (char)* message;

	/**
	 * Optional paths that control which files are stashed.
	 */
	libgit2.strarray.git_strarray paths;
}

enum GIT_STASH_SAVE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_stash_save_options GIT_STASH_SAVE_OPTIONS_INIT()

	do
	{
		.git_stash_save_options OUTPUT =
		{
			version_: .GIT_STASH_SAVE_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initialize git_stash_save_options structure
 *
 * Initializes a `git_stash_save_options` with default values. Equivalent to
 * creating an instance with `GIT_STASH_SAVE_OPTIONS_INIT`.
 *
 * @param opts The `git_stash_save_options` struct to initialize.
 * @param version_ The struct version; pass `GIT_STASH_SAVE_OPTIONS_VERSION`.
 * @return Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_stash_save_options_init(.git_stash_save_options* opts, uint version_);

/**
 * Save the local modifications to a new stash, with options.
 *
 * @param out_ Object id of the commit containing the stashed state. This commit is also the target of the direct reference refs/stash.
 * @param repo The owning repository.
 * @param opts The stash options.
 * @return 0 on success, GIT_ENOTFOUND where there's nothing to stash, or error code.
 */
@GIT_EXTERN
int git_stash_save_with_opts(libgit2.oid.git_oid* out_, libgit2.types.git_repository* repo, const (.git_stash_save_options)* opts);

/**
 * Stash application flags.
 */
enum git_stash_apply_flags
{
	GIT_STASH_APPLY_DEFAULT = 0,

	/**
	 * Try to reinstate not only the working tree's changes,
	 * but also the index's changes.
	 */
	GIT_STASH_APPLY_REINSTATE_INDEX = 1 << 0,
}

//Declaration name in C language
enum
{
	GIT_STASH_APPLY_DEFAULT = .git_stash_apply_flags.GIT_STASH_APPLY_DEFAULT,
	GIT_STASH_APPLY_REINSTATE_INDEX = .git_stash_apply_flags.GIT_STASH_APPLY_REINSTATE_INDEX,
}

/**
 * Stash apply progression states
 */
enum git_stash_apply_progress_t
{
	GIT_STASH_APPLY_PROGRESS_NONE = 0,

	/**
	 * Loading the stashed data from the object database.
	 */
	GIT_STASH_APPLY_PROGRESS_LOADING_STASH,

	/**
	 * The stored index is being analyzed.
	 */
	GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX,

	/**
	 * The modified files are being analyzed.
	 */
	GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED,

	/**
	 * The untracked and ignored files are being analyzed.
	 */
	GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED,

	/**
	 * The untracked files are being written to disk.
	 */
	GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED,

	/**
	 * The modified files are being written to disk.
	 */
	GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED,

	/**
	 * The stash was applied successfully.
	 */
	GIT_STASH_APPLY_PROGRESS_DONE,
}

//Declaration name in C language
enum
{
	GIT_STASH_APPLY_PROGRESS_NONE = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_NONE,
	GIT_STASH_APPLY_PROGRESS_LOADING_STASH = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_LOADING_STASH,
	GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX,
	GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED,
	GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED,
	GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED,
	GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED,
	GIT_STASH_APPLY_PROGRESS_DONE = .git_stash_apply_progress_t.GIT_STASH_APPLY_PROGRESS_DONE,
}

/**
 * Stash application progress notification function.
 * Return 0 to continue processing, or a negative value to
 * abort the stash application.
 */
alias git_stash_apply_progress_cb = int function(.git_stash_apply_progress_t progress, void* payload);

/**
 * Stash application options structure
 *
 * Initialize with `GIT_STASH_APPLY_OPTIONS_INIT`. Alternatively, you can
 * use `git_stash_apply_options_init`.
 */
struct git_stash_apply_options
{
	uint version_;

	/**
	 * See `git_stash_apply_flags`, above.
	 */
	uint flags;

	/**
	 * Options to use when writing files to the working directory.
	 */
	libgit2.checkout.git_checkout_options checkout_options;

	/**
	 * Optional callback to notify the consumer of application progress.
	 */
	.git_stash_apply_progress_cb progress_cb;

	void* progress_payload;
}

enum GIT_STASH_APPLY_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_stash_apply_options GIT_STASH_APPLY_OPTIONS_INIT()

	do
	{
		.git_stash_apply_options OUTPUT =
		{
			version_: .GIT_STASH_APPLY_OPTIONS_VERSION,
			flags: .git_stash_apply_flags.GIT_STASH_APPLY_DEFAULT,
			checkout_options: libgit2.checkout.GIT_CHECKOUT_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_stash_apply_options structure
 *
 * Initializes a `git_stash_apply_options` with default values. Equivalent to
 * creating an instance with `GIT_STASH_APPLY_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_stash_apply_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_STASH_APPLY_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_stash_apply_options_init(.git_stash_apply_options* opts, uint version_);

/**
 * Apply a single stashed state from the stash list.
 *
 * If local changes in the working directory conflict with changes in the
 * stash then git_error_code.GIT_EMERGECONFLICT will be returned.  In this case, the index
 * will always remain unmodified and all files in the working directory will
 * remain unmodified.  However, if you are restoring untracked files or
 * ignored files and there is a conflict when applying the modified files,
 * then those files will remain in the working directory.
 *
 * If passing the git_stash_apply_flags.GIT_STASH_APPLY_REINSTATE_INDEX flag and there would be
 * conflicts when reinstating the index, the function will return
 * git_error_code.GIT_EMERGECONFLICT and both the working directory and index will be left
 * unmodified.
 *
 * Note that a minimum checkout strategy of `git_checkout_strategy_t.GIT_CHECKOUT_SAFE` is implied.
 *
 * Params:
 *      repo = The owning repository.
 *      index = The position within the stash list. 0 points to the most recent stashed state.
 *      options = Optional options to control how stashes are applied.
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if there's no stashed state for the given index, git_error_code.GIT_EMERGECONFLICT if changes exist in the working directory, or an error code
 */
@GIT_EXTERN
int git_stash_apply(libgit2.types.git_repository* repo, size_t index, const (.git_stash_apply_options)* options);

/**
 * This is a callback function you can provide to iterate over all the
 * stashed states that will be invoked per entry.
 *
 * Returns: 0 to continue iterating or non-zero to stop.
 */
/*
 * Params:
 *      index = The position within the stash list. 0 points to the most recent stashed state.
 *      message = The stash message.
 *      stash_id = The commit oid of the stashed state.
 *      payload = Extra parameter to callback function.
 */
alias git_stash_cb = int function(size_t index, const (char)* message, const (libgit2.oid.git_oid)* stash_id, void* payload);

/**
 * Loop over all the stashed states and issue a callback for each one.
 *
 * If the callback returns a non-zero value, this will stop looping.
 *
 * Params:
 *      repo = Repository where to find the stash.
 *      callback = Callback to invoke per found stashed state. The most recent stash state will be enumerated first.
 *      payload = Extra parameter to callback function.
 *
 * Returns: 0 on success, non-zero callback return value, or error code.
 */
@GIT_EXTERN
int git_stash_foreach(libgit2.types.git_repository* repo, .git_stash_cb callback, void* payload);

/**
 * Remove a single stashed state from the stash list.
 *
 * Params:
 *      repo = The owning repository.
 *      index = The position within the stash list. 0 points to the most recent stashed state.
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if there's no stashed state for the given index, or error code.
 */
@GIT_EXTERN
int git_stash_drop(libgit2.types.git_repository* repo, size_t index);

/**
 * Apply a single stashed state from the stash list and remove it from the list
 * if successful.
 *
 * Params:
 *      repo = The owning repository.
 *      index = The position within the stash list. 0 points to the most recent stashed state.
 *      options = Optional options to control how stashes are applied.
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if there's no stashed state for the given index, or error code. (see git_stash_apply() above for details)
 */
@GIT_EXTERN
int git_stash_pop(libgit2.types.git_repository* repo, size_t index, const (.git_stash_apply_options)* options);

/* @} */
