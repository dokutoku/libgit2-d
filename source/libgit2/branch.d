/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.branch;


private static import libgit2.buffer;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/branch.h
 * @brief Git branch parsing routines
 * @defgroup git_branch Git branch management
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Create a new branch pointing at a target commit
 *
 * A new direct reference will be created pointing to
 * this target commit. If `force` is true and a reference
 * already exists with the given name, it'll be replaced.
 *
 * The returned reference must be freed by the user.
 *
 * The branch name will be checked for validity.
 * See `git_tag_create()` for rules about valid names.
 *
 * Params:
 *      out_ = Pointer where to store the underlying reference.
 *      repo = ?
 *      branch_name = Name for the branch; this name is validated for consistency. It should also not conflict with an already existing branch name.
 *      target = Commit to which this branch should point. This object must belong to the given `repo`.
 *      force = Overwrite existing branch.
 *
 * Returns: 0, git_error_code.GIT_EINVALIDSPEC or an error code. A proper reference is written in the refs/heads namespace pointing to the provided target commit.
 */
@GIT_EXTERN
int git_branch_create(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* branch_name, const (libgit2.types.git_commit)* target, int force);

/**
 * Create a new branch pointing at a target commit
 *
 * This behaves like `git_branch_create()` but takes an annotated
 * commit, which lets you specify which extended sha syntax string was
 * specified by a user, allowing for more exact reflog messages.
 *
 * See the documentation for `git_branch_create()`.
 *
 * @see git_branch_create
 */
@GIT_EXTERN
int git_branch_create_from_annotated(libgit2.types.git_reference** ref_out, libgit2.types.git_repository* repository, const (char)* branch_name, const (libgit2.types.git_annotated_commit)* commit, int force);

/**
 * Delete an existing branch reference.
 *
 * Note that if the deletion succeeds, the reference object will not
 * be valid anymore, and should be freed immediately by the user using
 * `git_reference_free()`.
 *
 * Params:
 *      branch = A valid reference representing a branch
 *
 * Returns: 0 on success, or an error code.
 */
@GIT_EXTERN
int git_branch_delete(libgit2.types.git_reference* branch);

/**
 * Iterator type for branches
 */
struct git_branch_iterator;

/**
 * Create an iterator which loops over the requested branches.
 *
 * Params:
 *      out_ = the iterator
 *      repo = Repository where to find the branches.
 *      list_flags = Filtering flags for the branch listing. Valid values are git_branch_t.GIT_BRANCH_LOCAL, git_branch_t.GIT_BRANCH_REMOTE or git_branch_t.GIT_BRANCH_ALL.
 *
 * Returns: 0 on success  or an error code
 */
@GIT_EXTERN
int git_branch_iterator_new(.git_branch_iterator** out_, libgit2.types.git_repository* repo, libgit2.types.git_branch_t list_flags);

/**
 * Retrieve the next branch from the iterator
 *
 * Params:
 *      out_ = the reference
 *      out_type = the type of branch (local or remote-tracking)
 *      iter = the branch iterator
 *
 * Returns: 0 on success, git_error_code.GIT_ITEROVER if there are no more branches or an error code.
 */
@GIT_EXTERN
int git_branch_next(libgit2.types.git_reference** out_, libgit2.types.git_branch_t* out_type, .git_branch_iterator* iter);

/**
 * Free a branch iterator
 *
 * Params:
 *      iter = the iterator to free
 */
@GIT_EXTERN
void git_branch_iterator_free(.git_branch_iterator* iter);

/**
 * Move/rename an existing local branch reference.
 *
 * The new branch name will be checked for validity.
 * See `git_tag_create()` for rules about valid names.
 *
 * Note that if the move succeeds, the old reference object will not
 * be valid anymore, and should be freed immediately by the user using
 * `git_reference_free()`.
 *
 * Params:
 *      out_ = New reference object for the updated name.
 *      branch = Current underlying reference of the branch.
 *      new_branch_name = Target name of the branch once the move is performed; this name is validated for consistency.
 *      force = Overwrite existing branch.
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC or an error code.
 */
@GIT_EXTERN
int git_branch_move(libgit2.types.git_reference** out_, libgit2.types.git_reference* branch, const (char)* new_branch_name, int force);

/**
 * Lookup a branch by its name in a repository.
 *
 * The generated reference must be freed by the user.
 * The branch name will be checked for validity.
 *
 * @see git_tag_create for rules about valid names.
 *
 * Params:
 *      out_ = pointer to the looked-up branch reference
 *      repo = the repository to look up the branch
 *      branch_name = Name of the branch to be looked-up; this name is validated for consistency.
 *      branch_type = Type of the considered branch. This should be valued with either git_branch_t.GIT_BRANCH_LOCAL or git_branch_t.GIT_BRANCH_REMOTE.
 *
 * Returns: 0 on success; git_error_code.GIT_ENOTFOUND when no matching branch exists, git_error_code.GIT_EINVALIDSPEC, otherwise an error code.
 */
@GIT_EXTERN
int git_branch_lookup(libgit2.types.git_reference** out_, libgit2.types.git_repository* repo, const (char)* branch_name, libgit2.types.git_branch_t branch_type);

/**
 * Get the branch name
 *
 * Given a reference object, this will check that it really is a branch (ie.
 * it lives under "refs/heads/" or "refs/remotes/"), and return the branch part
 * of it.
 *
 * Params:
 *      out_ = Pointer to the abbreviated reference name. Owned by ref_, do not free.
 *      ref_ = A reference object, ideally pointing to a branch
 *
 * Returns: 0 on success; GIT_EINVALID if the reference isn't either a local or remote branch, otherwise an error code.
 */
@GIT_EXTERN
int git_branch_name(const (char)** out_, const (libgit2.types.git_reference)* ref_);

/**
 * Get the upstream of a branch
 *
 * Given a reference, this will return a new reference object corresponding
 * to its remote tracking branch. The reference must be a local branch.
 *
 * @see git_branch_upstream_name for details on the resolution.
 *
 * Params:
 *      out_ = Pointer where to store the retrieved reference.
 *      branch = Current underlying reference of the branch.
 *
 * Returns: 0 on success; GIT_ENOTFOUND when no remote tracking reference exists, otherwise an error code.
 */
@GIT_EXTERN
int git_branch_upstream(libgit2.types.git_reference** out_, const (libgit2.types.git_reference)* branch);

/**
 * Set a branch's upstream branch
 *
 * This will update the configuration to set the branch named `branch_name` as the upstream of `branch`.
 * Pass a null name to unset the upstream information.
 *
 * @note the actual tracking reference must have been already created for the
 * operation to succeed.
 *
 * Params:
 *      branch = the branch to configure
 *      branch_name = remote-tracking or local branch to set as upstream.
 *
 * Returns: 0 on success; GIT_ENOTFOUND if there's no branch named `branch_name` or an error code
 */
@GIT_EXTERN
int git_branch_set_upstream(libgit2.types.git_reference* branch, const (char)* branch_name);

/**
 * Get the upstream name of a branch
 *
 * Given a local branch, this will return its remote-tracking branch information,
 * as a full reference name, ie. "feature/nice" would become
 * "refs/remote/origin/feature/nice", depending on that branch's configuration.
 *
 * Params:
 *      out_ = the buffer into which the name will be written.
 *      repo = the repository where the branches live.
 *      refname = reference name of the local branch.
 *
 * Returns: 0 on success, GIT_ENOTFOUND when no remote tracking reference exists, or an error code.
 */
@GIT_EXTERN
int git_branch_upstream_name(libgit2.buffer.git_buf* out_, libgit2.types.git_repository* repo, const (char)* refname);

/**
 * Determine if HEAD points to the given branch
 *
 * Params:
 *      branch = A reference to a local branch.
 *
 * Returns: 1 if HEAD points at the branch, 0 if it isn't, or a negative value as an error code.
 */
@GIT_EXTERN
int git_branch_is_head(const (libgit2.types.git_reference)* branch);

/**
 * Determine if any HEAD points to the current branch
 *
 * This will iterate over all known linked repositories (usually in the form of
 * worktrees) and report whether any HEAD is pointing at the current branch.
 *
 * Params:
 *      branch = A reference to a local branch.
 *
 * Returns: 1 if branch is checked out, 0 if it isn't, an error code otherwise.
 */
@GIT_EXTERN
int git_branch_is_checked_out(const (libgit2.types.git_reference)* branch);

/**
 * Find the remote name of a remote-tracking branch
 *
 * This will return the name of the remote whose fetch refspec is matching
 * the given branch. E.g. given a branch "refs/remotes/test/master", it will
 * extract the "test" part. If refspecs from multiple remotes match,
 * the function will return GIT_EAMBIGUOUS.
 *
 * Params:
 *      out_ = The buffer into which the name will be written.
 *      repo = The repository where the branch lives.
 *      refname = complete name of the remote tracking branch.
 *
 * Returns: 0 on success, GIT_ENOTFOUND when no matching remote was found, GIT_EAMBIGUOUS when the branch maps to several remotes, otherwise an error code.
 */
@GIT_EXTERN
int git_branch_remote_name(libgit2.buffer.git_buf* out_, libgit2.types.git_repository* repo, const (char)* refname);

/**
 * Retrieve the upstream remote of a local branch
 *
 * This will return the currently configured "branch.*.remote" for a given
 * branch. This branch must be local.
 *
 * Params:
 *      buf = the buffer into which to write the name
 *      repo = the repository in which to look
 *      refname = the full name of the branch
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_branch_upstream_remote(libgit2.buffer.git_buf* buf, libgit2.types.git_repository* repo, const (char)* refname);

/**
 * Retrieve the upstream merge of a local branch
 *
 * This will return the currently configured "branch.*.merge" for a given
 * branch. This branch must be local.
 *
 * Params:
 *      buf = the buffer into which to write the name
 *      repo = the repository in which to look
 *      refname = the full name of the branch
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_branch_upstream_merge(libgit2.buffer.git_buf* buf, libgit2.types.git_repository* repo, const (char)* refname);

/**
 * Determine whether a branch name is valid, meaning that (when prefixed
 * with `refs/heads/`) that it is a valid reference name, and that any
 * additional branch name restrictions are imposed (eg, it cannot start
 * with a `-`).
 *
 * Params:
 *      valid = output pointer to set with validity of given branch name
 *      name = a branch name to test
 *
 * Returns: 0 on success or an error code
 */
@GIT_EXTERN
int git_branch_name_is_valid(int* valid, const (char)* name);

/* @} */
