/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.annotated_commit;


private static import libgit2_d.oid;
private static import libgit2_d.types;

/*
 * @file git2/annotated_commit.h
 * @brief Git annotated commit routines
 * @defgroup git_annotated_commit Git annotated commit routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Creates a `git_annotated_commit` from a revision string.
 * The resulting git_annotated_commit must be freed with
 * `git_annotated_commit_free`.
 *
 * Params:
 *      out_ = pointer to store the git_annotated_commit result in
 *      repo = repository that contains the given reference
 *      ref_ = reference to use to lookup the git_annotated_commit
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_annotated_commit_from_ref(libgit2_d.types.git_annotated_commit** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_reference)* ref_);

/**
 * Creates a `git_annotated_commit` from the given fetch head data.
 * The resulting git_annotated_commit must be freed with
 * `git_annotated_commit_free`.
 *
 * Params:
 *      out_ = pointer to store the git_annotated_commit result in
 *      repo = repository that contains the given commit
 *      branch_name = name of the (remote) branch
 *      remote_url = url of the remote
 *      id = the commit object id of the remote branch
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_annotated_commit_from_fetchhead(libgit2_d.types.git_annotated_commit** out_, libgit2_d.types.git_repository* repo, const (char)* branch_name, const (char)* remote_url, const (libgit2_d.oid.git_oid)* id);

/**
 * Creates a `git_annotated_commit` from the given commit id.
 * The resulting git_annotated_commit must be freed with
 * `git_annotated_commit_free`.
 *
 * An annotated commit contains information about how it was
 * looked up, which may be useful for functions like merge or
 * rebase to provide context to the operation.  For example,
 * conflict files will include the name of the source or target
 * branches being merged.  It is therefore preferable to use the
 * most specific function (eg `git_annotated_commit_from_ref`)
 * instead of this one when that data is known.
 *
 * Params:
 *      out_ = pointer to store the git_annotated_commit result in
 *      repo = repository that contains the given commit
 *      id = the commit object id to lookup
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_annotated_commit_lookup(libgit2_d.types.git_annotated_commit** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.oid.git_oid)* id);

/**
 * Creates a `git_annotated_comit` from a revision string.
 *
 * See `man gitrevisions`, or
 * http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
 * information on the syntax accepted.
 *
 * Params:
 *      out_ = pointer to store the git_annotated_commit result in
 *      repo = repository that contains the given commit
 *      revspec = the extended sha syntax string to use to lookup the commit
 *
 * Returns: 0 on success or error code
 */
//GIT_EXTERN
int git_annotated_commit_from_revspec(libgit2_d.types.git_annotated_commit** out_, libgit2_d.types.git_repository* repo, const (char)* revspec);

/**
 * Gets the commit ID that the given `git_annotated_commit` refers to.
 *
 * Params:
 *      commit = the given annotated commit
 *
 * Returns: commit id
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_annotated_commit_id(const (libgit2_d.types.git_annotated_commit)* commit);

/**
 * Get the refname that the given `git_annotated_commit` refers to.
 *
 * Params:
 *      commit = the given annotated commit
 *
 * Returns: ref name.
 */
//GIT_EXTERN
const (char)* git_annotated_commit_ref(const (libgit2_d.types.git_annotated_commit)* commit);

/**
 * Frees a `git_annotated_commit`.
 *
 * Params:
 *      commit = annotated commit to free
 */
//GIT_EXTERN
void git_annotated_commit_free(libgit2_d.types.git_annotated_commit* commit);

/* @} */
