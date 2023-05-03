/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.worktree;


private static import libgit2.buffer;
private static import libgit2.strarray;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/worktrees.h
 * @brief Git worktree related functions
 * @defgroup git_commit Git worktree related functions
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * List names of linked working trees
 *
 * The returned list should be released with `git_strarray_free`
 * when no longer needed.
 *
 * Params:
 *      out_ = pointer to the array of working tree names
 *      repo = the repo to use when listing working trees
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_worktree_list(libgit2.strarray.git_strarray* out_, libgit2.types.git_repository* repo);

/**
 * Lookup a working tree by its name for a given repository
 *
 * Params:
 *      out_ = Output pointer to looked up worktree or `null`
 *      repo = The repository containing worktrees
 *      name = Name of the working tree to look up
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_worktree_lookup(libgit2.types.git_worktree** out_, libgit2.types.git_repository* repo, const (char)* name);

/**
 * Open a worktree of a given repository
 *
 * If a repository is not the main tree but a worktree, this
 * function will look up the worktree inside the parent
 * repository and create a new `git_worktree` structure.
 *
 * Params:
 *      out_ = Out-pointer for the newly allocated worktree
 *      repo = Repository to look up worktree for
 */
@GIT_EXTERN
int git_worktree_open_from_repository(libgit2.types.git_worktree** out_, libgit2.types.git_repository* repo);

/**
 * Free a previously allocated worktree
 *
 * Params:
 *      wt = worktree handle to close. If null nothing occurs.
 */
@GIT_EXTERN
void git_worktree_free(libgit2.types.git_worktree* wt);

/**
 * Check if worktree is valid
 *
 * A valid worktree requires both the git data structures inside
 * the linked parent repository and the linked working copy to be
 * present.
 *
 * Params:
 *      wt = Worktree to check
 *
 * Returns: 0 when worktree is valid, error-code otherwise
 */
@GIT_EXTERN
int git_worktree_validate(const (libgit2.types.git_worktree)* wt);

/**
 * Worktree add options structure
 *
 * Initialize with `GIT_WORKTREE_ADD_OPTIONS_INIT`. Alternatively, you can
 * use `git_worktree_add_options_init`.
 */
struct git_worktree_add_options
{
	uint version_;

	/**
	 * lock newly created worktree
	 */
	int lock;

	/**
	 * reference to use for the new worktree HEAD
	 */
	libgit2.types.git_reference* ref_;
}

enum GIT_WORKTREE_ADD_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_worktree_add_options GIT_WORKTREE_ADD_OPTIONS_INIT()

	do
	{
		.git_worktree_add_options OUTPUT =
		{
			version_: .GIT_WORKTREE_ADD_OPTIONS_VERSION,
			lock: 0,
			ref_: null,
		};

		return OUTPUT;
	}

/**
 * Initialize git_worktree_add_options structure
 *
 * Initializes a `git_worktree_add_options` with default values. Equivalent to
 * creating an instance with `GIT_WORKTREE_ADD_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_worktree_add_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_WORKTREE_ADD_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_worktree_add_options_init(.git_worktree_add_options* opts, uint version_);

/**
 * Add a new working tree
 *
 * Add a new working tree for the repository, that is create the
 * required data structures inside the repository and check out
 * the current HEAD at `path`
 *
 * Params:
 *      out_ = Output pointer containing new working tree
 *      repo = Repository to create working tree for
 *      name = Name of the working tree
 *      path = Path to create working tree at
 *      opts = Options to modify default behavior. May be null
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_worktree_add(libgit2.types.git_worktree** out_, libgit2.types.git_repository* repo, const (char)* name, const (char)* path, const (.git_worktree_add_options)* opts);

/**
 * Lock worktree if not already locked
 *
 * Lock a worktree, optionally specifying a reason why the linked
 * working tree is being locked.
 *
 * Params:
 *      wt = Worktree to lock
 *      reason = Reason why the working tree is being locked
 *
 * Returns: 0 on success, non-zero otherwise
 */
@GIT_EXTERN
int git_worktree_lock(libgit2.types.git_worktree* wt, const (char)* reason);

/**
 * Unlock a locked worktree
 *
 * Params:
 *      wt = Worktree to unlock
 *
 * Returns: 0 on success, 1 if worktree was not locked, error-code otherwise
 */
@GIT_EXTERN
int git_worktree_unlock(libgit2.types.git_worktree* wt);

/**
 * Check if worktree is locked
 *
 * A worktree may be locked if the linked working tree is stored
 * on a portable device which is not available.
 *
 * Params:
 *      reason = Buffer to store reason in. If null no reason is stored.
 *      wt = Worktree to check
 *
 * Returns: 0 when the working tree not locked, a value greater than zero if it is locked, less than zero if there was an error
 */
@GIT_EXTERN
int git_worktree_is_locked(libgit2.buffer.git_buf* reason, const (libgit2.types.git_worktree)* wt);

/**
 * Retrieve the name of the worktree
 *
 * Params:
 *      wt = Worktree to get the name for
 *
 * Returns: The worktree's name. The pointer returned is valid for the lifetime of the git_worktree
 */
@GIT_EXTERN
const (char)* git_worktree_name(const (libgit2.types.git_worktree)* wt);

/**
 * Retrieve the filesystem path for the worktree
 *
 * Params:
 *      wt = Worktree to get the path for
 *
 * Returns: The worktree's filesystem path. The pointer returned is valid for the lifetime of the git_worktree.
 */
@GIT_EXTERN
const (char)* git_worktree_path(const (libgit2.types.git_worktree)* wt);

/**
 * Flags which can be passed to git_worktree_prune to alter its
 * behavior.
 */
enum git_worktree_prune_t
{
	/**
	 * Prune working tree even if working tree is valid
	 */
	GIT_WORKTREE_PRUNE_VALID = 1u << 0,

	/**
	 * Prune working tree even if it is locked
	 */
	GIT_WORKTREE_PRUNE_LOCKED = 1u << 1,

	/**
	 * Prune checked out working tree
	 */
	GIT_WORKTREE_PRUNE_WORKING_TREE = 1u << 2,
}

//Declaration name in C language
enum
{
	GIT_WORKTREE_PRUNE_VALID = .git_worktree_prune_t.GIT_WORKTREE_PRUNE_VALID,
	GIT_WORKTREE_PRUNE_LOCKED = .git_worktree_prune_t.GIT_WORKTREE_PRUNE_LOCKED,
	GIT_WORKTREE_PRUNE_WORKING_TREE = .git_worktree_prune_t.GIT_WORKTREE_PRUNE_WORKING_TREE,
}

/**
 * Worktree prune options structure
 *
 * Initialize with `GIT_WORKTREE_PRUNE_OPTIONS_INIT`. Alternatively, you can
 * use `git_worktree_prune_options_init`.
 */
struct git_worktree_prune_options
{
	uint version_;

	uint flags;
}

enum GIT_WORKTREE_PRUNE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_worktree_prune_options GIT_WORKTREE_PRUNE_OPTIONS_INIT()

	do
	{
		.git_worktree_prune_options OUTPUT =
		{
			version_: .GIT_WORKTREE_PRUNE_OPTIONS_VERSION,
			flags: 0,
		};

		return OUTPUT;
	}

/**
 * Initialize git_worktree_prune_options structure
 *
 * Initializes a `git_worktree_prune_options` with default values. Equivalent to
 * creating an instance with `GIT_WORKTREE_PRUNE_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_worktree_prune_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_WORKTREE_PRUNE_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_worktree_prune_options_init(.git_worktree_prune_options* opts, uint version_);

/**
 * Is the worktree prunable with the given options?
 *
 * A worktree is not prunable in the following scenarios:
 *
 * - the worktree is linking to a valid on-disk worktree. The
 *   `valid` member will cause this check to be ignored.
 * - the worktree is locked. The `locked` flag will cause this
 *   check to be ignored.
 *
 * If the worktree is not valid and not locked or if the above
 * flags have been passed in, this function will return a
 * positive value.
 */
@GIT_EXTERN
int git_worktree_is_prunable(libgit2.types.git_worktree* wt, .git_worktree_prune_options* opts);

/**
 * Prune working tree
 *
 * Prune the working tree, that is remove the git data
 * structures on disk. The repository will only be pruned of
 * `git_worktree_is_prunable` succeeds.
 *
 * Params:
 *      wt = Worktree to prune
 *      opts = Specifies which checks to override. See `git_worktree_is_prunable`. May be null
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_worktree_prune(libgit2.types.git_worktree* wt, .git_worktree_prune_options* opts);

/* @} */
