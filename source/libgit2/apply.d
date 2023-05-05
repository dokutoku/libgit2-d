/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.apply;


private static import libgit2.diff;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/apply.h
 * @brief Git patch application routines
 * @defgroup git_apply Git patch application routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * When applying a patch, callback that will be made per delta (file).
 *
 * When the callback:
 * - returns < 0, the apply process will be aborted.
 * - returns > 0, the delta will not be applied, but the apply process
 *      continues
 * - returns 0, the delta is applied, and the apply process continues.
 *
 * Returns: 0 if the delta is applied, < 0 if the apply process will be aborted or > 0 if the delta will not be applied.
 */
/*
 * Params:
 *      delta = The delta to be applied
 *      payload = User-specified payload
 */
alias git_apply_delta_cb = int function(const (libgit2.diff.git_diff_delta)* delta, void* payload);

/**
 * When applying a patch, callback that will be made per hunk.
 *
 * When the callback:
 * - returns < 0, the apply process will be aborted.
 * - returns > 0, the hunk will not be applied, but the apply process
 *      continues
 * - returns 0, the hunk is applied, and the apply process continues.
 *
 * Returns: 0 if the hunk is applied, < 0 if the apply process will be aborted or > 0 if the hunk will not be applied.
 */
/*
 * Params:
 *      hunk = The hunk to be applied
 *      payload = User-specified payload
 */
alias git_apply_hunk_cb = int function(const (libgit2.diff.git_diff_hunk)* hunk, void* payload);

/**
 * Flags controlling the behavior of git_apply
 */
enum git_apply_flags_t
{
	/**
	 * Don't actually make changes, just test that the patch applies.
	 * This is the equivalent of `git apply --check`.
	 */
	GIT_APPLY_CHECK = 1 << 0,
}

//Declaration name in C language
enum
{
	GIT_APPLY_CHECK = .git_apply_flags_t.GIT_APPLY_CHECK,
}

/**
 * Apply options structure
 *
 * Initialize with `GIT_APPLY_OPTIONS_INIT`. Alternatively, you can
 * use `git_apply_options_init`.
 *
 * @see git_apply_to_tree, git_apply
 */
struct git_apply_options
{
	/**
	 * The version
	 */
	uint version_;

	/**
	 * When applying a patch, callback that will be made per delta (file).
	 */
	.git_apply_delta_cb delta_cb;

	/**
	 * When applying a patch, callback that will be made per hunk.
	 */
	.git_apply_hunk_cb hunk_cb;

	/**
	 * Payload passed to both delta_cb & hunk_cb.
	 */
	void* payload;

	/**
	 * Bitmask of git_apply_flags_t
	 */
	uint flags;
}

enum GIT_APPLY_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_apply_options GIT_APPLY_OPTIONS_INIT()

	do
	{
		.git_apply_options OUTPUT =
		{
			version_: .GIT_APPLY_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initialize git_apply_options structure
 *
 * Initialize a `git_apply_options` with default values. Equivalent to creating
 * an instance with GIT_APPLY_OPTIONS_INIT.
 *
 * Params:
 *      opts = The `git_apply_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_APPLY_OPTIONS_VERSION`
 *
 * Returns: 0 on success or -1 on failure.
 */
@GIT_EXTERN
int git_apply_options_init(.git_apply_options* opts, uint version_);

/**
 * Apply a `git_diff` to a `git_tree`, and return the resulting image
 * as an index.
 *
 * Params:
 *      out_ = the postimage of the application
 *      repo = the repository to apply
 *      preimage = the tree to apply the diff to
 *      diff = the diff to apply
 *      options = the options for the apply (or null for defaults)
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_apply_to_tree(libgit2.types.git_index** out_, libgit2.types.git_repository* repo, libgit2.types.git_tree* preimage, libgit2.diff.git_diff* diff, const (.git_apply_options)* options);

/**
 * Possible application locations for git_apply
 */
enum git_apply_location_t
{
	/**
	 * Apply the patch to the workdir, leaving the index untouched.
	 * This is the equivalent of `git apply` with no location argument.
	 */
	GIT_APPLY_LOCATION_WORKDIR = 0,

	/**
	 * Apply the patch to the index, leaving the working directory
	 * untouched.  This is the equivalent of `git apply --cached`.
	 */
	GIT_APPLY_LOCATION_INDEX = 1,

	/**
	 * Apply the patch to both the working directory and the index.
	 * This is the equivalent of `git apply --index`.
	 */
	GIT_APPLY_LOCATION_BOTH = 2,
}

//Declaration name in C language
enum
{
	GIT_APPLY_LOCATION_WORKDIR = .git_apply_location_t.GIT_APPLY_LOCATION_WORKDIR,
	GIT_APPLY_LOCATION_INDEX = .git_apply_location_t.GIT_APPLY_LOCATION_INDEX,
	GIT_APPLY_LOCATION_BOTH = .git_apply_location_t.GIT_APPLY_LOCATION_BOTH,
}

/**
 * Apply a `git_diff` to the given repository, making changes directly
 * in the working directory, the index, or both.
 *
 * Params:
 *      repo = the repository to apply to
 *      diff = the diff to apply
 *      location = the location to apply (workdir, index or both)
 *      options = the options for the apply (or null for defaults)
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_apply(libgit2.types.git_repository* repo, libgit2.diff.git_diff* diff, .git_apply_location_t location, const (.git_apply_options)* options);

/* @} */
