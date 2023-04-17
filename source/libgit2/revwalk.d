/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.revwalk;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/revwalk.h
 * @brief Git revision traversal routines
 * @defgroup git_revwalk Git revision traversal routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Flags to specify the sorting which a revwalk should perform.
 */
enum git_sort_t
{
	/**
	 * Sort the output with the same default method from `git`: reverse
	 * chronological order. This is the default sorting for new walkers.
	 */
	GIT_SORT_NONE = 0,

	/**
	 * Sort the repository contents in topological order (no parents before
	 * all of its children are shown); this sorting mode can be combined
	 * with time sorting to produce `git`'s `--date-order``.
	 */
	GIT_SORT_TOPOLOGICAL = 1 << 0,

	/**
	 * Sort the repository contents by commit time;
	 * this sorting mode can be combined with
	 * topological sorting.
	 */
	GIT_SORT_TIME = 1 << 1,

	/**
	 * Iterate through the repository contents in reverse
	 * order; this sorting mode can be combined with
	 * any of the above.
	 */
	GIT_SORT_REVERSE = 1 << 2,
}

//Declaration name in C language
enum
{
	GIT_SORT_NONE = .git_sort_t.GIT_SORT_NONE,
	GIT_SORT_TOPOLOGICAL = .git_sort_t.GIT_SORT_TOPOLOGICAL,
	GIT_SORT_TIME = .git_sort_t.GIT_SORT_TIME,
	GIT_SORT_REVERSE = .git_sort_t.GIT_SORT_REVERSE,
}

/**
 * Allocate a new revision walker to iterate through a repo.
 *
 * This revision walker uses a custom memory pool and an internal
 * commit cache, so it is relatively expensive to allocate.
 *
 * For maximum performance, this revision walker should be
 * reused for different walks.
 *
 * This revision walker is *not* thread safe: it may only be
 * used to walk a repository on a single thread; however,
 * it is possible to have several revision walkers in
 * several different threads walking the same repository.
 *
 * Params:
 *      out_ = pointer to the new revision walker
 *      repo = the repo to walk through
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_new(libgit2.types.git_revwalk** out_, libgit2.types.git_repository* repo);

/**
 * Reset the revision walker for reuse.
 *
 * This will clear all the pushed and hidden commits, and
 * leave the walker in a blank state (just like at
 * creation) ready to receive new commit pushes and
 * start a new walk.
 *
 * The revision walk is automatically reset when a walk
 * is over.
 *
 * Params:
 *      walker = handle to reset.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_reset(libgit2.types.git_revwalk* walker);

/**
 * Add a new root for the traversal
 *
 * The pushed commit will be marked as one of the roots from which to
 * start the walk. This commit may not be walked if it or a child is
 * hidden.
 *
 * At least one commit must be pushed onto the walker before a walk
 * can be started.
 *
 * The given id must belong to a committish on the walked
 * repository.
 *
 * Params:
 *      walk = the walker being used for the traversal.
 *      id = the oid of the commit to start from.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_push(libgit2.types.git_revwalk* walk, const (libgit2.oid.git_oid)* id);

/**
 * Push matching references
 *
 * The OIDs pointed to by the references that match the given glob
 * pattern will be pushed to the revision walker.
 *
 * A leading 'refs/' is implied if not present as well as a trailing
 * '/\*' if the glob lacks '?', '\*' or '['.
 *
 * Any references matching this glob which do not point to a
 * committish will be ignored.
 *
 * Params:
 *      walk = the walker being used for the traversal
 *      glob = the glob pattern references should match
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_push_glob(libgit2.types.git_revwalk* walk, const (char)* glob);

/**
 * Push the repository's HEAD
 *
 * Params:
 *      walk = the walker being used for the traversal
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_push_head(libgit2.types.git_revwalk* walk);

/**
 * Mark a commit (and its ancestors) uninteresting for the output.
 *
 * The given id must belong to a committish on the walked
 * repository.
 *
 * The resolved commit and all its parents will be hidden from the
 * output on the revision walk.
 *
 * Params:
 *      walk = the walker being used for the traversal.
 *      commit_id = the oid of commit that will be ignored during the traversal
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_hide(libgit2.types.git_revwalk* walk, const (libgit2.oid.git_oid)* commit_id);

/**
 * Hide matching references.
 *
 * The OIDs pointed to by the references that match the given glob
 * pattern and their ancestors will be hidden from the output on the
 * revision walk.
 *
 * A leading 'refs/' is implied if not present as well as a trailing
 * '/\*' if the glob lacks '?', '\*' or '['.
 *
 * Any references matching this glob which do not point to a
 * committish will be ignored.
 *
 * Params:
 *      walk = the walker being used for the traversal
 *      glob = the glob pattern references should match
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_hide_glob(libgit2.types.git_revwalk* walk, const (char)* glob);

/**
 * Hide the repository's HEAD
 *
 * Params:
 *      walk = the walker being used for the traversal
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_hide_head(libgit2.types.git_revwalk* walk);

/**
 * Push the OID pointed to by a reference
 *
 * The reference must point to a committish.
 *
 * Params:
 *      walk = the walker being used for the traversal
 *      refname = the reference to push
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_push_ref(libgit2.types.git_revwalk* walk, const (char)* refname);

/**
 * Hide the OID pointed to by a reference
 *
 * The reference must point to a committish.
 *
 * Params:
 *      walk = the walker being used for the traversal
 *      refname = the reference to hide
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_hide_ref(libgit2.types.git_revwalk* walk, const (char)* refname);

/**
 * Get the next commit from the revision walk.
 *
 * The initial call to this method is *not* blocking when
 * iterating through a repo with a time-sorting mode.
 *
 * Iterating with Topological or inverted modes makes the initial
 * call blocking to preprocess the commit list, but this block should be
 * mostly unnoticeable on most repositories (topological preprocessing
 * times at 0.3s on the git.git repo).
 *
 * The revision walker is reset when the walk is over.
 *
 * Params:
 *      out_ = Pointer where to store the oid of the next commit
 *      walk = the walker to pop the commit from.
 *
 * Returns: 0 if the next commit was found; git_error_code.GIT_ITEROVER if there are no commits left to iterate
 */
@GIT_EXTERN
int git_revwalk_next(libgit2.oid.git_oid* out_, libgit2.types.git_revwalk* walk);

/**
 * Change the sorting mode when iterating through the
 * repository's contents.
 *
 * Changing the sorting mode resets the walker.
 *
 * Params:
 *      walk = the walker being used for the traversal.
 *      sort_mode = combination of GIT_SORT_XXX flags
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_sorting(libgit2.types.git_revwalk* walk, uint sort_mode);

/**
 * Push and hide the respective endpoints of the given range.
 *
 * The range should be of the form
 *   <commit>..<commit>
 * where each <commit> is in the form accepted by 'git_revparse_single'.
 * The left-hand commit will be hidden and the right-hand commit pushed.
 *
 * Params:
 *      walk = the walker being used for the traversal
 *      range = the range
 *
 * Returns: 0 or an error code
 *
 */
@GIT_EXTERN
int git_revwalk_push_range(libgit2.types.git_revwalk* walk, const (char)* range);

/**
 * Simplify the history by first-parent
 *
 * No parents other than the first for each commit will be enqueued.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_revwalk_simplify_first_parent(libgit2.types.git_revwalk* walk);

/**
 * Free a revision walker previously allocated.
 *
 * Params:
 *      walk = traversal handle to close. If null nothing occurs.
 */
@GIT_EXTERN
void git_revwalk_free(libgit2.types.git_revwalk* walk);

/**
 * Return the repository on which this walker
 * is operating.
 *
 * Params:
 *      walk = the revision walker
 *
 * Returns: the repository being walked
 */
@GIT_EXTERN
libgit2.types.git_repository* git_revwalk_repository(libgit2.types.git_revwalk* walk);

/**
 * This is a callback function that user can provide to hide a
 * commit and its parents. If the callback function returns non-zero value,
 * then this commit and its parents will be hidden.
 */
/*
 * Params:
 *      commit_id = oid of Commit
 *      payload = User-specified pointer to data to be passed as data payload
 */
alias git_revwalk_hide_cb = int function(const (libgit2.oid.git_oid)* commit_id, void* payload);

/**
 * Adds, changes or removes a callback function to hide a commit and its parents
 *
 * Params:
 *      walk = the revision walker
 *      hide_cb = callback function to hide a commit and its parents
 *      payload = data payload to be passed to callback function
 */
@GIT_EXTERN
int git_revwalk_add_hide_cb(libgit2.types.git_revwalk* walk, .git_revwalk_hide_cb hide_cb, void* payload);

/* @} */
