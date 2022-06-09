/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.reset;


private static import libgit2_d.checkout;
private static import libgit2_d.strarray;
private static import libgit2_d.types;

/*
 * @file git2/reset.h
 * @brief Git reset management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Kinds of reset operation
 */
enum git_reset_t
{
	/**
	 * Move the head to the given commit
	 */
	GIT_RESET_SOFT = 1,

	/**
	 * SOFT plus reset index to the commit
	 */
	GIT_RESET_MIXED = 2,

	/**
	 * MIXED plus changes in working tree discarded
	 */
	GIT_RESET_HARD = 3,
}

//Declaration name in C language
enum
{
	GIT_RESET_SOFT = .git_reset_t.GIT_RESET_SOFT,
	GIT_RESET_MIXED = .git_reset_t.GIT_RESET_MIXED,
	GIT_RESET_HARD = .git_reset_t.GIT_RESET_HARD,
}

/**
 * Sets the current head to the specified commit oid and optionally
 * resets the index and working tree to match.
 *
 * SOFT reset means the Head will be moved to the commit.
 *
 * MIXED reset will trigger a SOFT reset, plus the index will be replaced
 * with the content of the commit tree.
 *
 * HARD reset will trigger a MIXED reset and the working directory will be
 * replaced with the content of the index.  (Untracked and ignored files
 * will be left alone, however.)
 *
 * TODO: Implement remaining kinds of resets.
 *
 * Params:
 *      repo = Repository where to perform the reset operation.
 *      target = Committish to which the Head should be moved to. This object must belong to the given `repo` and can either be a git_commit or a git_tag. When a git_tag is being passed, it should be dereferencable to a git_commit which oid will be used as the target of the branch.
 *      reset_type = Kind of reset operation to perform.
 *      checkout_opts = Optional checkout options to be used for a HARD reset. The checkout_strategy field will be overridden (based on reset_type). This parameter can be used to propagate notify and progress callbacks.
 *
 * Returns: 0 on success or an error code
 */
//GIT_EXTERN
int git_reset(libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_object)* target, .git_reset_t reset_type, const (libgit2_d.checkout.git_checkout_options)* checkout_opts);

/**
 * Sets the current head to the specified commit oid and optionally
 * resets the index and working tree to match.
 *
 * This behaves like `git_reset()` but takes an annotated commit,
 * which lets you specify which extended sha syntax string was
 * specified by a user, allowing for more exact reflog messages.
 *
 * See the documentation for `git_reset()`.
 *
 * @see git_reset
 */
//GIT_EXTERN
int git_reset_from_annotated(libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_annotated_commit)* commit, .git_reset_t reset_type, const (libgit2_d.checkout.git_checkout_options)* checkout_opts);

/**
 * Updates some entries in the index from the target commit tree.
 *
 * The scope of the updated entries is determined by the paths
 * being passed in the `pathspec` parameters.
 *
 * Passing a null `target` will result in removing
 * entries in the index matching the provided pathspecs.
 *
 * Params:
 *      repo = Repository where to perform the reset operation.
 *      target = The committish which content will be used to reset the content of the index.
 *      pathspecs = List of pathspecs to operate on.
 *
 * Returns: 0 on success or an error code < 0
 */
//GIT_EXTERN
int git_reset_default(libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_object)* target, const (libgit2_d.strarray.git_strarray)* pathspecs);

/* @} */
