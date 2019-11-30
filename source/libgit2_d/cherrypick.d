/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.cherrypick;


private static import libgit2_d.checkout;
private static import libgit2_d.merge;
private static import libgit2_d.types;

/**
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
	libgit2_d.merge.git_merge_options merge_opts;

	/**
	 * Options for the checkout
	 */
	libgit2_d.checkout.git_checkout_options checkout_opts;
}

enum GIT_CHERRYPICK_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_cherrypick_options GIT_CHERRYPICK_OPTIONS_INIT()

	do
	{
		.git_cherrypick_options OUTPUT =
		{
			version_: .GIT_CHERRYPICK_OPTIONS_VERSION,
			mainline: 0,
			merge_opts: libgit2_d.merge.GIT_MERGE_OPTIONS_INIT(),
			checkout_opts: libgit2_d.checkout.GIT_CHECKOUT_OPTIONS_INIT(),
		};

		return OUTPUT;
	}

/**
 * Initialize git_cherrypick_options structure
 *
 * Initializes a `git_cherrypick_options` with default values. Equivalent to creating
 * an instance with GIT_CHERRYPICK_OPTIONS_INIT.
 *
 * @param opts The `git_cherrypick_options` struct to initialize.
 * @param version The struct version; pass `GIT_CHERRYPICK_OPTIONS_VERSION`.
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_cherrypick_options_init(.git_cherrypick_options* opts, uint version_);

/**
 * Cherry-picks the given commit against the given "our" commit, producing an
 * index that reflects the result of the cherry-pick.
 *
 * The returned index must be freed explicitly with `git_index_free`.
 *
 * @param out_ pointer to store the index result in
 * @param repo the repository that contains the given commits
 * @param cherrypick_commit the commit to cherry-pick
 * @param our_commit the commit to revert against (eg, HEAD)
 * @param mainline the parent of the revert commit, if it is a merge
 * @param merge_options the merge options (or null for defaults)
 * @return zero on success, -1 on failure.
 */
//GIT_EXTERN
int git_cherrypick_commit(libgit2_d.types.git_index** out_, libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* cherrypick_commit, libgit2_d.types.git_commit* our_commit, uint mainline, const (libgit2_d.merge.git_merge_options)* merge_options);

/**
 * Cherry-pick the given commit, producing changes in the index and working
 * directory.
 *
 * @param repo the repository to cherry-pick
 * @param commit the commit to cherry-pick
 * @param cherrypick_options the cherry-pick options (or null for defaults)
 * @return zero on success, -1 on failure.
 */
//GIT_EXTERN
int git_cherrypick(libgit2_d.types.git_repository* repo, libgit2_d.types.git_commit* commit, const (.git_cherrypick_options)* cherrypick_options);

/** @} */
