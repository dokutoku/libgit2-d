/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.revert;


private static import libgit2_d.checkout;
private static import libgit2_d.merge;
private static import libgit2_d.types;

/*
 * @file git2/revert.h
 * @brief Git revert routines
 * @defgroup git_revert Git revert routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Options for revert
 */
struct git_revert_options
{
	uint version_;

	/**
	 * For merge commits, the "mainline" is treated as the parent.
	 */
	uint mainline;

	/**
	 * Options for the merging
	 */
	libgit2_d.merge.git_merge_options merge_opts;

	/**
	 * Options for the checkout
	 */
	libgit2_d.checkout.git_checkout_options checkout_opts;
}

enum GIT_REVERT_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_revert_options GIT_REVERT_OPTIONS_INIT()

	do
	{
		.git_revert_options OUTPUT =
		{
			version_: .GIT_REVERT_OPTIONS_VERSION,
			mainline: 0,
			merge_opts: libgit2_d.merge.GIT_MERGE_OPTIONS_INIT(),
			checkout_opts: libgit2_d.checkout.GIT_CHECKOUT_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_revert_options structure
 *
 * Initializes a `git_revert_options` with default values. Equivalent to
 * creating an instance with `GIT_REVERT_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_revert_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_REVERT_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_revert_options_init(.git_revert_options* opts, uint version_);

/**
 * Reverts the given commit against the given "our" commit, producing an
 * index that reflects the result of the revert.
 *
 * The returned index must be freed explicitly with `git_index_free`.
 *
 * Params:
 *      out_ = pointer to store the index result in
 *      repo = the repository that contains the given commits
 *      revert_commit = the commit to revert
 *      our_commit = the commit to revert against (eg, HEAD)
 *      mainline = the parent of the revert commit, if it is a merge
 *      merge_options = the merge options (or null for defaults)
 *
 * Returns: zero on success, -1 on failure.
 */
//GIT_EXTERN
int git_revert_commit(libgit2_d.types.git_index** out_, libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* revert_commit, libgit2_d.types.git_commit* our_commit, uint mainline, const (libgit2_d.merge.git_merge_options)* merge_options);

/**
 * Reverts the given commit, producing changes in the index and working
 * directory.
 *
 * Params:
 *      repo = the repository to revert
 *      commit = the commit to revert
 *      given_opts = the revert options (or null for defaults)
 *
 * Returns: zero on success, -1 on failure.
 */
//GIT_EXTERN
int git_revert(libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* commit, const (.git_revert_options)* given_opts);

/* @} */
