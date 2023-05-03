/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.cherrypick;


private static import libgit2.checkout;
private static import libgit2.merge;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/cherrypick.h
 * @brief Git cherry-pick routines
 * @defgroup git_cherrypick Git cherry-pick routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Cherry-pick options
 */
struct git_cherrypick_options
{
	uint version_;

	/**
	 * For merge commits, the "mainline" is treated as the parent.
	 */
	uint mainline;

	/**
	 * Options for the merging
	 */
	libgit2.merge.git_merge_options merge_opts;

	/**
	 * Options for the checkout
	 */
	libgit2.checkout.git_checkout_options checkout_opts;
}

enum GIT_CHERRYPICK_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_cherrypick_options GIT_CHERRYPICK_OPTIONS_INIT()

	do
	{
		.git_cherrypick_options OUTPUT =
		{
			version_: .GIT_CHERRYPICK_OPTIONS_VERSION,
			mainline: 0,
			merge_opts: libgit2.merge.GIT_MERGE_OPTIONS_INIT(),
			checkout_opts: libgit2.checkout.GIT_CHECKOUT_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_cherrypick_options structure
 *
 * Initializes a `git_cherrypick_options` with default values. Equivalent to creating
 * an instance with GIT_CHERRYPICK_OPTIONS_INIT.
 *
 * Params:
 *      opts = The `git_cherrypick_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_CHERRYPICK_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_cherrypick_options_init(.git_cherrypick_options* opts, uint version_);

/**
 * Cherry-picks the given commit against the given "our" commit, producing an
 * index that reflects the result of the cherry-pick.
 *
 * The returned index must be freed explicitly with `git_index_free`.
 *
 * Params:
 *      out_ = pointer to store the index result in
 *      repo = the repository that contains the given commits
 *      cherrypick_commit = the commit to cherry-pick
 *      our_commit = the commit to cherry-pick against (eg, HEAD)
 *      mainline = the parent of the `cherrypick_commit`, if it is a merge
 *      merge_options = the merge options (or null for defaults)
 *
 * Returns: zero on success, -1 on failure.
 */
@GIT_EXTERN
int git_cherrypick_commit(libgit2.types.git_index** out_, libgit2.types.git_repository* repo, libgit2.types.git_commit* cherrypick_commit, libgit2.types.git_commit* our_commit, uint mainline, const (libgit2.merge.git_merge_options)* merge_options);

/**
 * Cherry-pick the given commit, producing changes in the index and working
 * directory.
 *
 * Params:
 *      repo = the repository to cherry-pick
 *      commit = the commit to cherry-pick
 *      cherrypick_options = the cherry-pick options (or null for defaults)
 *
 * Returns: zero on success, -1 on failure.
 */
@GIT_EXTERN
int git_cherrypick(libgit2.types.git_repository* repo, libgit2.types.git_commit* commit, const (.git_cherrypick_options)* cherrypick_options);

/* @} */
